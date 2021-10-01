//
//  WelcomeView.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 15/09/2021.
//

import SwiftUI
import Firebase

struct WelcomeView: View {
    @State private var showSignInSheet = false
    @State private var showSignUpSheet = false
    @Binding var userSignedIn: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Text("Welcome to AppX. Sign in or sign up.")
            Spacer()
            VStack {
                Button(action: { showSignInSheet.toggle() }) {
                    Text("Sign In")
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(20)
                    
                        
                }
                Button(action: { showSignUpSheet.toggle() }) {
                    Text("Sign Up")
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(20)
                }
            }
            .padding(.all)
        }
        .sheet(isPresented: $showSignInSheet) {
            SignInView(userSignedIn: $userSignedIn)
        }
        .sheet(isPresented: $showSignUpSheet) {
            SignUpView(userSignedIn: $userSignedIn)
        }
    }
}




    

