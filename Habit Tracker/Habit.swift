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
    var name : String
    var category : String = ""
    var done : Bool = false
}
