//
//  Extension Date.swift
//  Habit Tracker
//
//  Created by Jennet on 2024-05-06.
//

import Foundation

extension Date {
    func formattedString(for timeZone: TimeZone = TimeZone(identifier: "Europe/Stockholm")!) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: self)
    }
}
