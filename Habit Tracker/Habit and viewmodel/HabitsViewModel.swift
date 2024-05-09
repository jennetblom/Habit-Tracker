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
        //        let today = Date()
        
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
    
    func saveNewHabitToFirestore (habit : Habit) {
        
        guard let user = auth.currentUser else {return}
        let habitsRef = db.collection("users").document(user.uid).collection("habits")
        
        
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
    func fetchHabits() {
        guard let user = auth.currentUser else { return }
        let habitsRef = db.collection("users").document(user.uid).collection("habits")
        
        habitsRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching habits: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents")
                return
            }
            
            self.habits = documents.compactMap { document in
                try? document.data(as: Habit.self)
            }
        }
    }
    func countStreakCount(habit: Habit) {
        var daysDone = habit.daysDone
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        
        guard !daysDone.isEmpty else {
            habit.streakCount = 0
            updateStreakCountToFirestore(habit: habit)
            return
        }
        
        daysDone.sort()
        
        
        if let lastDay = daysDone.last, lastDay < yesterday {
            habit.streakCount = 0
            updateStreakCountToFirestore(habit: habit)
            return
        }
        
        var streakCount = 0
        var checkDate = daysDone.last!
        
        
        while daysDone.contains(where: { calendar.isDate($0, inSameDayAs: checkDate) }) {
            streakCount += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
            if !daysDone.contains(where: { calendar.isDate($0, inSameDayAs: previousDay) }) {
                break
            }
            checkDate = previousDay
        }
        
        habit.streakCount = streakCount
        updateStreakCountToFirestore(habit: habit)
    }
    func last30Days() -> [Date]{
        let today = Date()
        let calendar = Calendar.current
        return (0..<30).map { calendar.date(byAdding: .day, value: -$0, to: today)! }.reversed()
    }
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Permission granted")
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    func scheduleDailyReminder(habit : Habit) {
        var reminderTime = habit.reminderTime
        var habitName = habit.name
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "It's time to perform your habit: \(habitName)"
        content.sound = UNNotificationSound.default
        
        // Skapa en trigger för att aktivera påminnelsen varje dag vid den angivna tiden
        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: reminderTime ?? Date())
        dateComponents.second = 0 // Sätt sekunder till 0 för att undvika problem med utlösningen
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Skapa en anmälningsbegäran med innehållet och triggern
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // Lägg till anmälningsbegäran i UNUserNotificationCenter
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling daily reminder: \(error.localizedDescription)")
            } else {
                print("Daily reminder scheduled successfully for habit: \(habitName)")
            }
        }
    }
    
}
    

