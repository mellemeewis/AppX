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
    
    @State public var errorMessage: String = ""
    @State public var showAlert: Bool = false
    
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
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error Signing In"), message: Text(errorMessage), dismissButton: .default(Text("Got it!")))
        }
    }
    
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            if let error = error as NSError? {
                print(error)
                guard let errorMessage = error.userInfo["NSLocalizedDescription"] as? String else {
                    self.errorMessage = "An unknown error occured"
                    self.showAlert = true
                    return
                }
                guard let errorCode = AuthErrorCode(rawValue: error.code) else {
                    self.errorMessage = "There was an error signing up but it could not be matched with a firebase code"
                    self.showAlert = true
                    return
                }
                self.errorMessage = errorMessage
                self.showAlert = true
            }
            else {
                self.userSignedIn = true
                presentationMode.wrappedValue.dismiss()
                return
            }
        }
    }
}

