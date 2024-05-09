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
    @ServerTimestamp var reminderTime: Date? = nil
    
    
    
    init(name: String, reminderTime : Date) {
        self.name = name
        self.date = Date()
        self.reminderTime = reminderTime
    }
    var formattedDate : String? {
        guard let date = date else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date )
    }
    func diff(numDays: Int, to date : Date) -> Date {
        
        
        if let newDate = Calendar.current.date(byAdding: .day, value: numDays, to: date) {
            //            print("newDate: \(newDate)")
            return newDate
        } else {
            // Hantera fallet där nytt datum inte kan beräknas
            return Date()
        }
    }
    
}
