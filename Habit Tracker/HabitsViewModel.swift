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
        guard let user = auth.currentUser, let id = habit.id else {return}
        let habitsRef = db.collection("users").document(user.uid).collection("habits")
        let habitDocumentRef = habitsRef.document(id)
        var newDoneStatus = !habit.done
        
        habitDocumentRef.updateData(["done" : newDoneStatus]) { error in
            if let error = error {
                print(error)
                return
            }
        }
        
        updateDaysDone(habitDocumentRef: habitDocumentRef, done: newDoneStatus)
        getDataFromFirestore(habit: habit) { updatedHabit in
            if let updatedHabit = updatedHabit {
                self.countStreakCount(habit: updatedHabit)
            }
        }
        
    }
    func updateDaysDone(habitDocumentRef : DocumentReference, done: Bool){
        let today = Calendar.current.startOfDay(for: Date())
        
        if done {
            habitDocumentRef.updateData(["daysDone" : FieldValue.arrayUnion([today])])
        } else {
            habitDocumentRef.updateData(["daysDone" : FieldValue.arrayRemove([today])])
        }
        
    }
    func updateStreakCountToFirestore(habit : Habit) {
        guard let user = auth.currentUser, let id = habit.id else {return}
        let habitsRef = db.collection("users").document(user.uid).collection("habits")
        let habitDocumentRef = habitsRef.document(id)
        
        habitDocumentRef.updateData(["streakCount" : habit.streakCount])
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
    func getDataFromFirestore(habit: Habit, completion: @escaping (Habit?) -> Void) {
        guard let user = auth.currentUser, let id = habit.id else { return }
        let habitsRef = db.collection("users").document(user.uid).collection("habits").document(id)
        
        habitsRef.getDocument { document, error in
            if let error = error {
                print("Error fetching document: \(error)")
                completion(nil)
                return
            }
            
            guard let document = document, document.exists else {
                print("Document does not exist")
                completion(nil)
                return
            }
            
            do {
                // Decode Firestore data into Habit object
                let habit = try document.data(as: Habit.self)
                completion(habit)
            } catch {
                print("Error decoding document data: \(error)")
                completion(nil)
            }
        }
    }
    func countStreakCount(habit : Habit) {
        
        var daysDone = habit.daysDone
        let today = Calendar.current.startOfDay(for: Date())
        
        print(" \(habit.name)\(daysDone)")
        guard !habit.daysDone.isEmpty else {
            habit.streakCount = 0
            print(habit.streakCount)
            updateStreakCountToFirestore(habit: habit)
            return
        }
        let sortedDays = habit.daysDone.sorted()
        var currentStreak = 1
        var maxStreak = 1
        
        for i in 1..<sortedDays.count {
            print("daysDone \(sortedDays[i])")
            let previousDay = Calendar.current.date(byAdding: .day, value: -1, to: sortedDays[i])
            
            if Calendar.current.isDate(sortedDays[i-1], inSameDayAs: previousDay!){
                currentStreak += 1
            } else {
                maxStreak = max(maxStreak, currentStreak)
                currentStreak = 1
            }
        }
        maxStreak = max(maxStreak, currentStreak)
        habit.streakCount = maxStreak
        print("StreakCount +  \(habit.name) \(habit.streakCount)")
        updateStreakCountToFirestore(habit: habit)
    }
}
