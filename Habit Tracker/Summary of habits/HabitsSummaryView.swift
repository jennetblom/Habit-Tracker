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
            // Gradient-färg som en header
            LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(height: 200)
            
            VStack {
                // Texten "Good job!" som en header
                Text("Here's a summary of your achievements! Keep up the good work!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                Spacer()
                // Resten av innehållet nedanför headern
                Picker("Select a Habit", selection: $selectedHabitIndex)
                {
                    ForEach(0..<habitsViewModel.habits.count, id: \.self) { index in
                        Text(habitsViewModel.habits[index].name)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                if habitsViewModel.habits.indices.contains(selectedHabitIndex) {
                    SummaryView(habit: habitsViewModel.habits[selectedHabitIndex], habitsViewModel: habitsViewModel)
                } else {
                    Text("No habit selected")
                }
            }
            .padding(.top, 70) // Justera om du vill ändra avståndet mellan text och gradient
        }
        .ignoresSafeArea() // Ignorera safe area för att fylla hela skärmen med färgen
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
//                             let imageName = habit.daysDone.contains(date) ? "heart.square" : "square"
//                             Image(systemName: imageName)
//                                 .resizable()
//                                 .aspectRatio(contentMode: .fill)
//                                 .frame(width: 40, height: 40)
//                                 .cornerRadius(10)
//                                 .padding(5)
//                                 .foregroundColor(.gray)
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
        
        
        //#Preview {
        //    HabitsSummaryView()
        //}
        
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
    

            //    func checkColorImage() -> Color{
            //
            //        if imageName == "star.square" {
            //            return Color(red: 255.0/255, green: 3/255, blue: 144/255)
            //        }
            //        return .black
            //    }
            //    struct SummaryView: View {
            //        let habit: Habit
            //        @ObservableObject var habitsViewModel = HabitsViewModel()
            //        var body: some View {
            //            ScrollView(.horizontal, showsIndicators: false) {
            //                HStack(spacing: 10) {
            //                    ForEach(last30Days(), id: \.self) { date in
            //                        VStack {
            //                            Text(dayString(from: date))
            //                            if habit.daysDone.contains(date) {
            //                                Image(systemName: "checkmark.circle.fill")
            //                                    .foregroundColor(.green)
            //                            } else {
            //                                Image(systemName: "xmark.circle.fill")
            //                                    .foregroundColor(.red)
            //                            }
            //                        }
            //                    }
            //                }
            //                .padding()
            //            }
            //        }
            //}
            //#Preview {
            //    HabitsSummaryView()
            //}
    
