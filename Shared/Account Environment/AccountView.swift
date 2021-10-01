//
//  AccountView.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 15/09/2021.
//

import SwiftUI
import Firebase

struct AccountView: View {
    @ObservedObject var currentUser: User
    @Binding var userSignedIn: Bool
    @State var showNameAlert = false
    @State var showEmailAlert = false
    
    var body: some View {
        
        VStack {
            NavigationView {
                Form {
                    Section(header: Text("Contact details")) {
                        Button(action: { self.showNameAlert = true}) {
                            Text("Name")
                                .foregroundColor(Color.black)
                                .bold()
                            Spacer()
                            Text(currentUser.firstName)
                                .foregroundColor(Color.gray)
                            Text(currentUser.lastName)
                                .foregroundColor(Color.gray)
                        }
                        .alert(isPresented: $showNameAlert,
                            TextAlert(title: "Name", message: "Enter your name", keyboardType: .default) { firstField, secondField in
                                if let firstName = firstField, let lastName = secondField {
                                    currentUser.updateName(firstName: firstName, lastName: lastName)
                                        print(firstName, lastName)
                                }
                            }
                        )
                        
                        Button(action: { self.showEmailAlert = true}) {
                            Text("Email")
                                .foregroundColor(Color.black)
                                .bold()
                            Spacer()
                            Text(currentUser.email)
                                .foregroundColor(Color.gray)
                        }
                        .alert(isPresented: $showEmailAlert,
                            TextAlert(title: "Email", message: "Enter your email", keyboardType: .emailAddress) { firstField, secondField in
                                if let email = firstField {
                                    currentUser.updateEmail(email: email)
                                        print(email)
                                }
                            }
                        )
                        
                        NavigationLink(destination: Text("Adress")) {
                            HStack {
                                Text("Adress")
                                    .foregroundColor(Color.black)
                                    .bold()
                                Spacer()
                                VStack {
                                    HStack {
                                        Spacer()
                                        Text("\(currentUser.street) \(currentUser.houseNumber)")
                                            .foregroundColor(Color.gray)
                                    }
                                    HStack {
                                        Spacer()
                                        Text("\(currentUser.ZIP) \(currentUser.city)")
                                            .foregroundColor(Color.gray)
                                    }
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Payment details"))  {
                        Text("GEEN IDEE")
                    }

        
        
        Button(action: { SignOut() }) {
            Text("Sign Out")
                .fontWeight(.bold)
                .font(.title)
                .foregroundColor(.white)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(20)
        }.padding()
            }
            }
    }
    }
    
    func SignOut() {
        do {
            try Auth.auth().signOut()
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
