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
    
    var body: some View {
        
        if userSignedIn {
            TabView() {
                Text("TBD")
                 .tabItem {
                    Image(systemName: "phone.fill")
                    Text("First Tab")
                }
//                Text("camera")
                CameraView()
                 .tabItem {
                    Image(systemName: "camera.fill")
                    Text("Second Tab")
                }
                AccountView(userSignedIn: $userSignedIn)
                  .tabItem {
                     Image(systemName: "person.circle.fill")
                     Text("Account")
                }
            }
        }
        else {
            WelcomeView(userSignedIn: $userSignedIn).onAppear {
                print("I APPEARED\n\n\n\n\n\n\n")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
