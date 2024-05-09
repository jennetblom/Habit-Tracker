//
//  HabitsSummaryView.swift
//  Habit Tracker
//
//  Created by Jennet on 2024-04-26.
//

import SwiftUI

struct HabitsSummaryView: View {
    @StateObject var habitsViewModel = HabitsViewModel()
    @State private var selectedHabitIndex = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(height: 200)
            
            VStack {
                Text("Here's a summary of your achievements! Keep up the good work!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                Spacer()
                Picker("Select a Habit", selection: $selectedHabitIndex)
                {
                    ForEach(0..<habitsViewModel.habits.count, id: \.self) { index in
                        Text(habitsViewModel.habits[index].name)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                
                if habitsViewModel.habits.indices.contains(selectedHabitIndex) {
                    SummaryView(habit: habitsViewModel.habits[selectedHabitIndex], habitsViewModel: habitsViewModel)
                } else {
                    Text("No habit selected")
                }
            }
            .padding(.top, 70)
        }
        .ignoresSafeArea()
        .onAppear {
            habitsViewModel.listenToFirestore()
        }
    }
}
struct SummaryView: View {
    let habit: Habit
    let habitsViewModel: HabitsViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 6), spacing: 10) {
                ForEach(habitsViewModel.last30Days(), id: \.self) { date in
                    if habit.daysDone.contains(where: { Calendar.current.isDate($0, inSameDayAs: date) }) {
                        ImageView(imageName: "heart.square")
                    }else {
                        ImageView(imageName: "square")
                    }
                }
            }
            .padding()
            Spacer()
        }
        
        
        
    }
}
struct ExtractedView: View {
    
    var body: some View {
        HStack{
            ImageView(imageName: "square")
            ImageView(imageName: "heart.square")
            ImageView(imageName: "square")
            ImageView(imageName: "square")
            ImageView(imageName: "heart.square")
            ImageView(imageName: "square")
            ImageView(imageName: "heart.square")
        }
        
    }
}
struct ImageView : View {
    var imageName : String
    var body: some View {
        Image(systemName: imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 45, height: 50)
            .cornerRadius(10)
            .foregroundStyle(checkColorImage(), .black)
            .shadow(radius: 50)
            .background(.white)
    }
    func checkColorImage() -> Color{
        
        if imageName == "heart.square" {
            return Color(red: 255.0/255, green: 3.0/255, blue: 144.0/255)
        }
        return .black
    }
}
    
