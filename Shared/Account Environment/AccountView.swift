//
//  AccountView.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 15/09/2021.
//

import SwiftUI
import Firebase

struct AccountView: View {
    @ObservedObject var paymentService: PaymentService
    @ObservedObject var currentUser: User
    @Binding var userSignedIn: Bool
    @State var showNameAlert = false
    @State var showEmailAlert = false
    @State var showEmailErrorAlert = false
    @State var emailErrorAlertText: String = ""

    var body: some View {
        
        VStack {
            NavigationView {
                Form {
                    Section(header: Text("Contact details")) {
                        Button(action: { self.showNameAlert = true}) {
                            HStack {
                                Text("Name")
                                    .foregroundColor(Color.black)
                                    .bold()
                                Spacer()
                                Text("\(currentUser.firstName) \(currentUser.lastName)")
                                    .foregroundColor(Color.gray)
                                Image(systemName: "pencil")
                            }
  
                        }
                        .alert(isPresented: $showNameAlert,
                               TextAlert(title: "Name", message: "Enter your name", placeholder1: currentUser.firstName, placeholder2: currentUser.lastName, keyboardType: .default) { firstField, secondField in
                                if let firstName = firstField, let lastName = secondField {
                                    currentUser.updateName(firstName: firstName, lastName: lastName)
                                        print(firstName, lastName)
                                }
                            }
                        )
                        
                        Button(action: { self.showEmailAlert = true}) {
                            HStack {
                                Text("Email")
                                    .foregroundColor(Color.black)
                                    .bold()
                                Spacer()
                                Text(currentUser.email)
                                    .foregroundColor(Color.gray)
                                Image(systemName: "pencil")
                            }
                        }
                        .alert(isPresented: $showEmailAlert,
                            TextAlert(title: "Email", message: "Enter your email", placeholder1: currentUser.email, keyboardType: .emailAddress) { firstField, secondField in
                                if let email = firstField {
                                    currentUser.updateEmail(email: email) { error in
                                        if error != nil {
                                            self.emailErrorAlertText = error?.localizedDescription ?? "An unknown error occured."
                                            self.showEmailErrorAlert = true
                                        }
                                    }
                                        
                                }
                            }
                        )
                        .alert(isPresented: $showEmailErrorAlert) {
                            Alert(title: Text("Error Changing Email"), message: Text(self.emailErrorAlertText), dismissButton: .default(Text("Got it!")))
                        }
                        
                        NavigationLink(destination: AddressViewAccountEnvironment(currentUser: self.currentUser)) {
                            HStack {
                                Text("Adress")
                                    .foregroundColor(Color.black)
                                    .bold()
                                Spacer()
                                VStack {
                                    HStack {
                                        Spacer()
                                        Text("\(currentUser.address) \(currentUser.addition)")
                                            .foregroundColor(Color.gray)
                                    }
                                    HStack {
                                        Spacer()
                                        Text("\(currentUser.postalCode) \(currentUser.city)")
                                            .foregroundColor(Color.gray)
                                    }
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Financial information"))  {
                        NavigationLink(destination: PaymentMethodView(currentUser: self.currentUser, paymentService: self.paymentService)) {
                            HStack {
                                Text("Payment Method")
                                    .foregroundColor(Color.black)
                                    .bold()
                                Spacer()
                            }
                        }
                        NavigationLink(destination: OrdersView(currentUser: self.currentUser, paymentService: self.paymentService)) {
                            HStack {
                                Text("Orders")
                                    .foregroundColor(Color.black)
                                    .bold()
                                Spacer()
                            }
                        }
                    }
                    
                        

        
                    Section(header: Text("Sign Out"))  {

                    Button(action: { SignOut() }) {
                        Text("Sign Out")
                            .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(Color("ButtonColor"))
                        .cornerRadius(20)
                    }.padding()
                    }
                }
            }
        }
    }
    
    func SignOut() {
        do {
            try Auth.auth().signOut()
            self.paymentService.resetInformation()
            userSignedIn = false
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    
}

struct nameView: View {
    @Environment(\.presentationMode) var presentationMode
    @State public var newFirstName: String = ""
    @State public var newLastName: String = ""
    @ObservedObject var currentUser: User

    var body: some View {
        Form {
            TextField("First Name", text: $newFirstName)
            TextField("Last Name", text: $newLastName)
        }
        Button(action: {
            currentUser.updateName(firstName: newFirstName, lastName: newLastName)
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Save")
        })
    }
}

//struct AccountView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        AccountView(userSignedIn: .constant(true))
//    }
//}
