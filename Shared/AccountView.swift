//
//  AccountView.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 15/09/2021.
//

import SwiftUI
import Firebase

struct AccountView: View {
    @Binding var userSignedIn: Bool
    
    var body: some View {
        Button(action: { SignOut() }) {
            Text("Sign Out")
                .fontWeight(.bold)
                .font(.title)
                .foregroundColor(.white)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(20)
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
