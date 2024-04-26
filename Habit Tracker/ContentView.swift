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
    @State private var selectedTab = 1
    
    var body: some View {
        if !signedIn {
            SignInView(signedIn: $signedIn)
        } else {
            TabView(selection: $selectedTab) {
                AddHabitView()
                    .tabItem {
                        Label("Create new habits", systemImage: "plus.circle")
                    }.tag(0)
                HabitListView()
                    .tabItem {
                        Label("Habits",systemImage: "list.bullet.clipboard")
                    }.tag(1)
                HabitsSummaryView()
                    .tabItem {
                        Label("Summary", systemImage: "person")
                    }.tag(2)
            }
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
            }.onAppear() {
                signedIn = checkIfLoggedIn()
            }
        }
    }
    func checkIfLoggedIn() -> Bool{
        if let currentUser = auth.currentUser {
            return true
        }
        return false
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


#Preview {
    ContentView()
}
