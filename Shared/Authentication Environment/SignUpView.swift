//
//  SignUpView.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 01/10/2021.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var userSignedIn: Bool
    
    @State var detailsCorrect: Bool = false
    @State public var firstName: String = ""
    @State public var lastName: String = ""
    @State public var email: String = ""
    @State public var password: String = ""
    @State public var repeatPassword: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Button("Cancel") { presentationMode.wrappedValue.dismiss() }
                        .padding()
                }
                Spacer()
                VStack {
                    HStack{
                        TextField("First Name", text: $firstName).onChange(of: firstName) { _ in checkDetails() }.textContentType(.givenName)
                        TextField("Last Name", text: $lastName).onChange(of: lastName) { _ in checkDetails() }.textContentType(.familyName)
                    }
                    TextField("Email", text: $email).onChange(of: email) { _ in checkDetails() }.textContentType(.emailAddress).keyboardType(.emailAddress).autocapitalization(.none)
                    SecureField("Password", text: $password).onChange(of: password) { _ in checkDetails() }.textContentType(.newPassword)
                    SecureField("Repeat password", text: $repeatPassword).onChange(of: repeatPassword) { _ in checkDetails() }.textContentType(.newPassword)
                }
                .padding(.all)
                NavigationLink(destination: Text("Addres"), isActive: $userSignedIn) { EmptyView() }

                Button(action: {
                    signUp(firstName: firstName, lastName: lastName, email: email, password: password, repeatPassword: repeatPassword)
                }) {
                    Text("Sign Up")
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(detailsCorrect ? Color.blue : Color.gray)
                        .cornerRadius(20)
                }.disabled(detailsCorrect==false)
                Spacer()
            }
        }
    }
    
    func checkDetails() {
        guard self.firstName != "" else { self.detailsCorrect = false; return }
        guard self.lastName != "" else { self.detailsCorrect = false; return }
        guard self.email != "" else { self.detailsCorrect = false; return }
        guard self.password != "" else { self.detailsCorrect = false; return }
        guard self.password == self.repeatPassword else { self.detailsCorrect = false; return }
        
        self.detailsCorrect = true
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
//                presentationMode.wrappedValue.dismiss()
                return
            }
        }
    }
}
