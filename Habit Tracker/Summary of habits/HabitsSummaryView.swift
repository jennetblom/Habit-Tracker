//
//  HabitsSummaryView.swift
//  Habit Tracker
//
//  Created by Jennet on 2024-04-26.
//

import SwiftUI

struct HabitsSummaryView: View {
    var body: some View {
        ZStack{
//            Color(red: 204/255, green: 255/255, blue: 204/255)
//            /*.ignoresSafeArea()*/
            
            VStack{
                Text("Good job! ")
                    .font(.largeTitle)
                ExtractedView()
                ExtractedView()
                ExtractedView()
                ExtractedView()
                ExtractedView()
                ExtractedView()
                ExtractedView()
            }
        }
    }
}

#Preview {
    HabitsSummaryView()
}

struct ExtractedView: View {
    
    var body: some View {
        HStack{
            ImageView(imageName: "square")
            ImageView(imageName: "square")
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
            .frame(width: 40, height: 40)
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
//    func checkColorImage() -> Color{
//        
//        if imageName == "star.square" {
//            return Color(red: 255.0/255, green: 3/255, blue: 144/255)
//        }
//        return .black
//    }
}
