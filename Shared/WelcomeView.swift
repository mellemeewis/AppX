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

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var userSignedIn: Bool

    @State public var firstName: String = ""
    @State public var lastName: String = ""
    @State public var email: String = ""
    @State public var password: String = ""
    @State public var repeatPassword: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Cancel") { presentationMode.wrappedValue.dismiss() }
                    .padding()
            }
            Spacer()
            VStack {
                HStack{
                    TextField("First Name", text: $firstName).textContentType(.givenName)
                    TextField("Last Name", text: $lastName).textContentType(.familyName)
                }
                TextField("Email", text: $email).textContentType(.emailAddress).keyboardType(.emailAddress).autocapitalization(.none)
                SecureField("Password", text: $password).textContentType(.newPassword)
                SecureField("Repeat password", text: $repeatPassword).textContentType(.newPassword)
            }
            .padding(.all)
            Button(action: {
                signUp(firstName: firstName, lastName: lastName, email: email, password: password, repeatPassword: repeatPassword)
            }) {
                Text("Sign Up")
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
    
    func signUp(firstName: String, lastName: String, email: String, password: String, repeatPassword: String) {
        guard password == repeatPassword else {
            print("Passwords don't match")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if let error = error as NSError? {
                print(error)
                guard let errorCode = AuthErrorCode(rawValue: error.code) else {
                    print("there was an error signing up but it could not be matched with a firebase code")
                    return
                }
                switch errorCode {
                case .invalidEmail:
                    print("invalid email")
                case.weakPassword:
                    print("weak password")
                case .emailAlreadyInUse:
                    print("Email used")
                default:
                    print("there was an error signing up but it could not be matched with a firebase code")
                }
                return
            }
            else {
                self.userSignedIn = true
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = firstName
                changeRequest?.commitChanges { error in
                    if error != nil {
                        print("display name update failed")
                    }
                }
                Auth.auth().currentUser?.sendEmailVerification { error in
                    if error != nil {
                        print("email verification failed")
                    }
                }
                presentationMode.wrappedValue.dismiss()
                return
            }
        }
    }
}
    

