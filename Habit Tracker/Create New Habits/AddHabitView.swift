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
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.top)
//                .ignoresSafeArea()
                
            VStack{
                TextField("What is the habit called?", text: $habitName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button("Save habit") {
                    saveHabit()
                }
                .buttonStyle(CustomButtonStyle(foregroundColor: .white, backgroundColor: .green, cornerRadius: 10))
            }
        }
    }
    func saveHabit() {
        if !habitName.isEmpty {
            habitsViewModel.saveNewHabitToFirestore(habitName: habitName)
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
