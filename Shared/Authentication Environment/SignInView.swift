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
    
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
                .onTapGesture {
                        hideKeyboard()
                }
            VStack {
                Spacer()
                VStack {
                    TextField("Email", text: $email).textContentType(.emailAddress).keyboardType(.emailAddress).autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)                         .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.3))
                    SecureField("Password", text: $password).textContentType(.newPassword)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.3))
                }.padding(.all)
                Spacer()
                Button(action: {
                    signIn(email: email, password: password)
                }) {
                    Text("Sign In")
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(Color("ButtonColor"))
                        .cornerRadius(20)
                }
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(Color("ButtonColor"))
                        .cornerRadius(20)
                }
            }
            .padding()
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

