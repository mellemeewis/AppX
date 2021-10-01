//
//  SignInView.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 01/10/2021.
//

import SwiftUI
import Firebase
        
struct SignInView: View {
    @Environment(\.presentationMode) var presentationMode
    @State public var email: String = ""
    @State public var password: String = ""
    @Binding var userSignedIn: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Cancel") { presentationMode.wrappedValue.dismiss() }
                    .padding(.all)
            }
            Spacer()
            VStack {
                TextField("Email", text: $email).textContentType(.emailAddress).keyboardType(.emailAddress).autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                SecureField("Password", text: $password).textContentType(.newPassword)
            }.padding(.all)
            Button(action: {
                signIn(email: email, password: password)
            }) {
                Text("Sign In")
                    .fontWeight(.bold)
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(20)
            }
            Spacer()
        }
    }
    
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            if let error = error as NSError? {
                print(error)
                guard let errorCode = AuthErrorCode(rawValue: error.code) else {
                    print("there was an error signing up but it could not be matched with a firebase code")
                    return
                }
                switch errorCode {
                case .wrongPassword:
                    print("invalid email")
                case.userDisabled:
                    print("weak password")
                case .invalidEmail:
                    print("Email used")
                default:
                    print("there was an error signing up but it could not be matched with a firebase code")
                }
                return
            }
            else {
                self.userSignedIn = true
                presentationMode.wrappedValue.dismiss()
                return
            }
        }
    }
}

