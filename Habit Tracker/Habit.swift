//
//  Habit.swift
//  Habit Tracker
//
//  Created by Jennet on 2024-04-23.
//

import Foundation
import FirebaseFirestoreSwift

class Habit : Codable, Identifiable {
    @DocumentID var id : String?
    
    var name : String = ""
    var category : String = ""
    var done : Bool = false
    var streakCount : Int = 0
    @ServerTimestamp var date:Date? = nil
    var daysDone : [Date] = []
    
    init(name: String) {
        self.name = name
        self.date = Date()
    }
    var formattedDate : String? {
        guard let date = date else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date )
    }
    func diff(numDays : Int) -> Date? {
        if let date = date {
            return Calendar.current.date(byAdding: .day, value: numDays, to: date)
        }
        return nil
    }
    func getStreakCount() -> Int {
        
        var streak = 0
        
        guard !daysDone.isEmpty else {
            print("daysDone is empty")
            return 0
        }
        
        for i in stride(from: daysDone.count - 1, through: 0, by: -1){
            let habitDate = diff(numDays: i - daysDone.count + 1 )
            print("HabitDate: \(habitDate)")
            if let habitDate = habitDate, daysDone.contains(habitDate){
                streak += 1
                print("streak \(streak)")
            } else {
                print("Break on date: \(habitDate)")
                break
            }
        }
        return streak
    }
    func handleDone() {
        guard !daysDone.isEmpty else {return}
        
        
        
    }
    
}
