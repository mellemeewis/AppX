//
//  ContentView.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 14/09/2021.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @State var userSignedIn: Bool = Auth.auth().currentUser != nil
    @StateObject var currentUser = User()
    
    var body: some View {
        
            if userSignedIn {
                TabView() {
                    Text("TBD")
                     .tabItem {
                        Image(systemName: "phone.fill")
                        Text("First Tab")
                    }
                    CameraView()
                     .tabItem {
                        Image(systemName: "camera.fill")
                        Text("Second Tab")
                    }
                    AccountView(currentUser: currentUser, userSignedIn: $userSignedIn)
                      .tabItem {
                         Image(systemName: "person.circle.fill")
                         Text("Account")
                    }
                }.onAppear {
                    self.currentUser.updateAll()
                }
            }
            else {
                WelcomeView(userSignedIn: $userSignedIn).onAppear {
                    print("I APPEARED\n\n\n\n\n\n\n")
                }
            }
    }
    
//    mutating func InitiliazeCurrentUser() {
//        guard let currentFirUser = Auth.auth().currentUser else { return }
//        let name = currentFirUser.displayName!
//        let email = currentFirUser.email!
//        let uid = currentFirUser.uid
//
//        self.currentUser = User(uid: uid, firstName: name, email: email)
//
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
