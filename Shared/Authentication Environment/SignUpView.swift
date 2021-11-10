//
//  SignUpView.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 01/10/2021.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    @ObservedObject var currentUser: User
    @ObservedObject var paymentService: PaymentService
    @Environment(\.presentationMode) var presentationMode
    @Binding var userSignedIn: Bool
    @State var showAddressView: Bool = false
    
    @State var detailsCorrect: Bool = false
    @State public var firstName: String = ""
    @State public var lastName: String = ""
    @State public var email: String = ""
    @State public var password: String = ""
    @State public var repeatPassword: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                VStack {
                    TextField("First Name", text: $firstName).onChange(of: firstName) { _ in checkDetails() }.textContentType(.givenName)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.3))
                        .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                    TextField("Last Name", text: $lastName).onChange(of: lastName) { _ in checkDetails() }.textContentType(.familyName)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.3))
                    TextField("Email", text: $email).onChange(of: email) { _ in checkDetails() }.textContentType(.emailAddress).keyboardType(.emailAddress).autocapitalization(.none)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.3))
                    SecureField("Password", text: $password).onChange(of: password) { _ in checkDetails() }.textContentType(.newPassword)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.3))
                    SecureField("Repeat password", text: $repeatPassword).onChange(of: repeatPassword) { _ in checkDetails() }.textContentType(.newPassword)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.3))
                }
                .padding(.all)
                Spacer()

                NavigationLink(destination: AddressViewAuthenticationEnvironment(currentUser: self.currentUser, userSignedIn: self.$userSignedIn).navigationBarBackButtonHidden(true), isActive: $showAddressView) { EmptyView() }

                Button(action: {
                    signUp(firstName: firstName, lastName: lastName, email: email, password: password, repeatPassword: repeatPassword)
                    }) {
                    Text("Sign Up")
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(detailsCorrect ? Color("ButtonColor") : Color("ButtonColor").opacity(0.4))
                        .cornerRadius(10)
                }.disabled(detailsCorrect==false)
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("ButtonColor"))
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color("BackgroundColor")).ignoresSafeArea()
            .onTapGesture {
                    hideKeyboard()
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
            }
            else {
                self.currentUser.uid = Auth.auth().currentUser!.uid
                self.currentUser.initializeDataBase(email: email, firstName: firstName, lastName: lastName)
                self.paymentService.createCustomer(firstName: firstName, lastName: lastName)
                self.currentUser.fetchUserDataFromDatabase()
                self.showAddressView = true
//                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
