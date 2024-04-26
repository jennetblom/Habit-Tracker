//
//  ContentView.swift
//  Habit Tracker
//
//  Created by Jennet on 2024-04-22.
//

import SwiftUI
import Firebase

struct ContentView : View {
    
    @State var signedIn : Bool = false
    
    var body: some View {
        if !signedIn {
            SignInView(signedIn: $signedIn)
        } else {
            HabitListView()
        }
    }
}
struct SignInView : View {
    
    @Binding var signedIn : Bool
    var auth = Auth.auth()
    @State var email : String = ""
    @State var password : String = ""
    @State var signInError : String?
    
    var body: some View{
        ZStack{
//            Color(red: 240/255, green: 240/255, blue: 240/255)
//                .ignoresSafeArea()
            
            VStack{
                TextField("Write your email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Write your password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button(action: {
                    createUser()
                }) {
                    Text("Register")
                        .padding(5)
                        .foregroundColor(.white)
                }.background(Color.blue)
                .cornerRadius(10)
                Button(action: {
                    signIn()
                }) {
                    Text("Sign in")
                        .padding(5)
                        .foregroundColor(.white)
                }.background(Color.blue)
                    .cornerRadius(10)
            }
        }
    }
    func createUser() {
        auth.createUser(withEmail: email, password: password){
            result, error in
            print("\(email) \(password)")
            if let error = error {
                print("Error \(error)")
            }else{
                signedIn = true
            }
        }
    }
    func signIn() {
        auth.signIn(withEmail: email, password: password){
            result, error in
            print("\(email) \(password)")
            if let error = error {
                print("Error \(error)")
            }else{
                signedIn = true
            }
        }
    }
        
}
struct HabitListView: View {
    
    @StateObject var habitsViewModel = HabitsViewModel()
    
    var body: some View {
   
        VStack{
            List{
                ForEach(habitsViewModel.habits){ habit in
                    RowView(habit: habit, habitsViewModel: habitsViewModel)
                    
                }
            }
        }.onAppear() {
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

#Preview {
    ContentView()
}
