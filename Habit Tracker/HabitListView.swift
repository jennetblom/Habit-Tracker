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
    
    var body: some View {
        
        
            VStack{
                Text("What habits have you done today?")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
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

struct RowView: View {
    let habit : Habit
    let habitsViewModel : HabitsViewModel
    var body: some View {
        HStack{
            Text(habit.name)
//                .font(.caption)
//            Text(habit.formattedDate ?? "")
            Text("\(habit.getStreakCount())")
            Spacer()
            Button(action: {
                habitsViewModel.toggle(habit: habit)
            }) {
                Image(systemName: habit.done ? "star.square" : "square")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.purple)
                    .frame(width: 40)
            }
            
        }
    }
}
