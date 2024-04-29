//
//  Habit.swift
//  Habit Tracker
//
//  Created by Jennet on 2024-04-23.
//

import Foundation
import FirebaseFirestoreSwift

struct Habit : Codable, Identifiable {
    @DocumentID var id : String?
    
    var name : String = ""
    var category : String = ""
    var done : Bool = false
    @ServerTimestamp var date:Date? = nil
    var daysDone : [Date] = []
    
    
//    init(name: String) {
//        self.id = nil
//        self.name = name
//        self.category = ""
//        self.done = false
//    }
    var formattedDate : String? {
        guard let date = date else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date )
    }
    func getStreakCount() -> Int {
        
        guard !daysDone.isEmpty else {return 0}
        
        var streakCount = 0
        var currentStreak = 1
        
        for i in 1..<daysDone.count {
            let previousDate = daysDone[i - 1]
            let currentDate = daysDone[i]
            
            if Calendar.current.isDate(previousDate, inSameDayAs: currentDate.addingTimeInterval(-86400)) {
                currentStreak += 1
            } else {
                streakCount = max(streakCount,currentStreak)
            }
        }
        
        streakCount = max(streakCount, currentStreak)
        return streakCount
        
    }
//    func formattedDate(from date: Date) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        return dateFormatter.string(from: date)
//    }
}
