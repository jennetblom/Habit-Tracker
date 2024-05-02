//
//  HabitsViewModel.swift
//  Habit Tracker
//
//  Created by Jennet on 2024-04-25.
//

import Foundation
import Firebase

class HabitsViewModel : ObservableObject {
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    @Published var habits = [Habit]()
    
    func toggle(habit: Habit){
        guard let user = auth.currentUser else {return}
        let habitsRef = db.collection("users").document(user.uid).collection("habits")
        
        if let id = habit.id {
            habitsRef.document(id).updateData(["done" : !habit.done])
            
            toggleHabitDate(habit: habit)
        }
        
    }
    func toggleHabitDate(habit: Habit){
        guard let user = auth.currentUser else {return}
        let habitsRef = db.collection("users").document(user.uid).collection("habits")
        
        if let id = habit.id {
            let habitDocumentRef = habitsRef.document(id)
            
            let today = Calendar.current.startOfDay(for: Date())
            
            habitDocumentRef.getDocument{ (document, error) in
                if let document = document, document.exists {
                    let habitData = document.data()
                    let habitDone = habitData?["done"] as? Bool ?? false
                    
                    if habitDone {
                        habitDocumentRef.updateData(["daysDone" : FieldValue.arrayUnion([today])])
                    } else if !habitDone {
                        habitDocumentRef.updateData(["daysDone" : FieldValue.arrayRemove([today])])
                    }
                }
            }
        }
    }

    func saveNewHabitToFirestore (habitName : String) {
        
        guard let user = auth.currentUser else {return}
        let habitsRef = db.collection("users").document(user.uid).collection("habits")
        
        let habit = Habit(name: habitName)
        
        do{
            try habitsRef.addDocument(from: habit)
        } catch {
            print("Error saving to db \(error.localizedDescription)")
        }
    }
    func listenToFirestore() {
        
        guard let user = auth.currentUser else {return}
        let habitsRef = db.collection("users").document(user.uid).collection("habits")
        
        habitsRef.addSnapshotListener() {
            snapshot, err in
            guard let snapshot = snapshot else {return}
            
            if let err = err {
                print("Error getting document\(err)")
            } else{
                self.habits.removeAll()
                for document in snapshot.documents {
                    do {
                        let habit = try document.data(as: Habit.self)
                        self.habits.append(habit)
                    } catch{
                        print("Error reading from db \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    func updateDaysDone(habit : Habit) {
        guard let user = auth.currentUser else {return}
        let habitsRef = db.collection("users").document(user.uid).collection("habits")
                   
        if let id = habit.id {
            if habit.done {
                habitsRef.document(id).updateData(["daysDone" : [habit.date]])
            }
        }
    }
}
