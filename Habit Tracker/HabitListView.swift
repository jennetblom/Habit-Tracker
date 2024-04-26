//
//  HabitListView.swift
//  Habit Tracker
//
//  Created by Jennet on 2024-04-26.
//

import Foundation
import SwiftUI

struct HabitListView: View {
    
    @StateObject var habitsViewModel = HabitsViewModel()
    
    var body: some View {
   
        
            VStack{
                List{
                    ForEach(habitsViewModel.habits){ habit in
                        RowView(habit: habit, habitsViewModel: habitsViewModel)
                    }
                }
            }.navigationTitle("List of habits")
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
            Spacer()
            Button(action: {
                habitsViewModel.toggle(habit: habit)
            }) {
                Image(systemName: habit.done ? "checkmark.square" : "square")
            }
            
        }
    }
}
