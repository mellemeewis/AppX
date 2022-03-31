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
    
    @State public var errorMessage: String = ""
    @State public var showAlert: Bool = false

    var body: some View {
    
        NavigationView {
            ZStack {
                Color("BackgroundColor").ignoresSafeArea()
                VStack {
                    Text("Welcome! Please fill in your information so we can sign you up!")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.vertical)
                    TextField("First Name", text: $firstName).onChange(of: firstName) { _ in checkDetails() }.textContentType(.givenName)
                        .padding(10)
                        .font(.system(size: 20))
                        .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.2))
                        .keyboardType(.default)
//                        .padding(.horizontal)
                    TextField("Last Name", text: $lastName).onChange(of: lastName) { _ in checkDetails() }.textContentType(.familyName)
                        .padding(10)
                        .font(.system(size: 20))
                        .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.2))
//                        .padding(.horizontal)
                    TextField("Email", text: $email).onChange(of: email) { _ in checkDetails() }
                        .textContentType(.emailAddress).keyboardType(.emailAddress).autocapitalization(.none)
                        .padding(10)
                        .font(.system(size: 20))
                        .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.2))
//                        .padding(.horizontal)
                    SecureField("Password", text: $password).onChange(of: password) { _ in checkDetails() }.textContentType(.newPassword)
                        .padding(10)
                        .font(.system(size: 20))
                        .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.2))
//                        .padding(.horizontal)
                    SecureField("Repeat password", text: $repeatPassword).onChange(of: repeatPassword) { _ in checkDetails() }
                        .textContentType(.newPassword)
                        .padding(10)
                        .font(.system(size: 20))
                        .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.2))
//                        .padding(.horizontal)
                    
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
                    }
                        .disabled(detailsCorrect==false)
                        .padding([.top])

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
                        .padding([.bottom])
                }.padding()
            }
        }
        .onTapGesture { hideKeyboard() }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error Signing Up"), message: Text(errorMessage), dismissButton: .default(Text("Got it!")))
        }
    }
    
    func checkDetails() {
        guard self.firstName != "" else { self.detailsCorrect = false; return }
        guard self.lastName != "" else { self.detailsCorrect = false; return }
        guard self.email != "" else { self.detailsCorrect = false; return }
        guard self.password != "" else { self.detailsCorrect = false; return }
        self.detailsCorrect = true
    }
    
    func signUp(firstName: String, lastName: String, email: String, password: String, repeatPassword: String) {
        guard password == repeatPassword else {
            self.errorMessage = "The passwords do not match"
            self.showAlert = true
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if let error = error as NSError? {
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
                self.currentUser.uid = Auth.auth().currentUser!.uid
                self.currentUser.initializeDataBase(email: email, firstName: firstName, lastName: lastName)
                self.paymentService.createCustomer(firstName: firstName, lastName: lastName)
                self.currentUser.fetchUserDataFromDatabase()
                self.showAddressView = true
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(currentUser: User(), paymentService: PaymentService(), userSignedIn: .constant(false))
    }
}
