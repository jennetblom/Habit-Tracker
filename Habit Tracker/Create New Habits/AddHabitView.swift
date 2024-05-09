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
    @State var selectedDate = Date()
    @State var newHabit: Habit?
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.top)
            
            VStack{
                TextField("What is the habit called?", text: $habitName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                DatePicker("Choose a time for the reminder", selection: $selectedDate, displayedComponents: .hourAndMinute)
                    .padding()
                    .background(.white)
                    .cornerRadius(20.0)
                    .padding()
                    .foregroundColor(.gray)
                
                
                
                Button("Save habit") {
                    saveHabit()
                }
                .buttonStyle(CustomButtonStyle(foregroundColor: .white, backgroundColor: .green, cornerRadius: 10))
            }
        }.onAppear {
            habitsViewModel.requestNotificationPermission()
        }
    }
    func saveHabit() {
        if !habitName.isEmpty {
            
            let newHabit = Habit(name: habitName, reminderTime: selectedDate)
            
            habitsViewModel.saveNewHabitToFirestore(habit : newHabit)
            habitsViewModel.scheduleDailyReminder(habit: newHabit)
            habitName = ""
        } else {
            print("empty")
        }
    }
    
}
struct CustomButtonStyle: ButtonStyle {
    var foregroundColor: Color
    var backgroundColor: Color
    var cornerRadius: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .scaleEffect(configuration.isPressed ? 0.1 : 0.8) // Add a scaling effect when pressed
            .animation(.easeInOut(duration: 0.5)) // Add a smooth animation
    }
}

#Preview {
    AddHabitView()
}
