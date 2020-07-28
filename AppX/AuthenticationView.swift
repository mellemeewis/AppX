//
//  SwiftUIView.swift
//  AppX
//
//  Created by Melle Meewis on 03/07/2020.
//  Copyright © 2020 Melle Meewis. All rights reserved.
//

import SwiftUI
import Firebase

struct AuthenticationView: View {
    @State var showSignInView = false
    @State private var email = ""
    @State private var password = ""
    @State private var repeatPassword = ""
    
    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        ZStack {
            Color.gray.edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("pngegg").resizable().scaledToFit().edgesIgnoringSafeArea(.all)
                    
                VStack {
                    TextField("Email", text: $email)
                    TextField("Password", text: $password)
                }
                    
                if showSignInView {
                    Button(action: { self.handleSignUp(email: self.email, password: self.password, repeatPassword: self.repeatPassword)
                    }) { PrimaryButton(title: "Sign Up")}
                    
                } else {
                    VStack {
                        TextField("Repeat Password", text: $repeatPassword)
                        Button(action: { self.handleSignIn(email: self.email, password: self.password)}) { PrimaryButton(title: "Sign In") }
                    }
                }
            }
        }
    }



    func handleSignIn(email: String, password: String) {
        print("Handle Sign IN")
        print(email, password)
     
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                print("USER", Auth.auth().currentUser?.email as Any)
                self.viewRouter.userLoggedIn = true
                
            } else {
                print("FAIL")
    //            guard let myError = error?.localizedDescription else { return }
    //            let erroralert = UIAlertController(title: "LogIn Failed", message: myError , preferredStyle: .alert)
    //            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
    //            erroralert.addAction(okButton)
    //            self.present(erroralert, animated: true, completion: nil)
            }
        }
    }

    func handleSignUp(email: String, password: String, repeatPassword: String) {
        print("Handle Sign Up")
        print(email, password, repeatPassword)
        
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                print(Auth.auth().currentUser?.email as Any)
                self.viewRouter.userLoggedIn = true
            } else {
                print(error as Any)
            }
        }
    }
}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
