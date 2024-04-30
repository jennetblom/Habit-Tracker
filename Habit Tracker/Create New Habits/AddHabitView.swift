//
//  AddHabitView.swift
//  Habit Tracker
//
//  Created by Jennet on 2024-04-26.
//

import SwiftUI

struct AddHabitView: View {
    @StateObject var habitsViewModel = HabitsViewModel()
    @State var habitName : String = ""
    
    var body: some View {
        VStack{
            TextField("What is the habit called?", text: $habitName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                    Button("Save habit") {
                        saveHabit()
                    }
        }
    }
    func saveHabit() {
        habitsViewModel.saveToFirestore(habitName: habitName)
    }
}

#Preview {
    AddHabitView()
}
