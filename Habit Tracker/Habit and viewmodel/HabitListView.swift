//
//  HabitListView.swift
//  Habit Tracker
//
//  Created by Jennet on 2024-04-26.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct HabitListView: View {
    
    @StateObject var habitsViewModel = HabitsViewModel()
    @State var date = Date()
    
    var body: some View {
        
        ZStack{
                        LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
            //                        .edgesIgnoringSafeArea(.all)
                            .ignoresSafeArea()
            VStack{
                Text("What habits have you done today?")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                Text("\(date.formattedString())")
                List{
                    ForEach(habitsViewModel.habits){ habit in
                        RowView(habit: habit, habitsViewModel: habitsViewModel)
                    }
                }
            }
            .navigationTitle("What habits have you done today?")
            .onAppear() {
                habitsViewModel.listenToFirestore()
            }
            
        }
    }
    func checkDate() ->String {
        guard let date = habitsViewModel.habits.first?.formattedDate else {
            return "No date available"
        }
        return date
    }

}

struct RowView: View {
    var imageName : String = ""
    let habit : Habit
    let habitsViewModel : HabitsViewModel
    @State var streakCount = 0
    var body: some View {
        HStack{
            Text(habit.name)
            Text("\(habit.streakCount)")
            Spacer()
            Button(action: {
                
                habitsViewModel.toggle(habit: habit)
                
            }) {
                Image(systemName: habit.done ?  "heart.square" : "square")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40)
                    .foregroundStyle(checkColorImage(imageName: habit.done ? "heart.square" : "square"), .black)
            }
            
        }.onAppear(){
        }
    }
    func checkColorImage(imageName: String) -> Color{
        
        if imageName == "heart.square" {
            return Color(red: 255.0/255, green: 3.0/255, blue: 144.0/255)
        }
        return .black
    }
}
