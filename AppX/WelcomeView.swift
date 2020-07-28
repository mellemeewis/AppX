//
//  ContentView.swift
//  AppX
//
//  Created by Melle Meewis on 02/07/2020.
//  Copyright © 2020 Melle Meewis. All rights reserved.
//

import SwiftUI
import Firebase

struct WelcomeView: View {
    @EnvironmentObject var viewRouter: ViewRouter

//    init(){
//        UINavigationBar.setAnimationsEnabled(false)
//    }
    
    var body: some View {
        {
            ZStack {
                Color.gray.edgesIgnoringSafeArea(.all)
                    
                VStack(spacing: 30) {
                    Image("pngegg").resizable().scaledToFit().edgesIgnoringSafeArea(.all)
                    Text("Welcome to AppX!\nPlease sign in or sign up.")

                    NavigationLink(destination: AuthenticationView(showSignInView: true)) {
                        PrimaryButton(title: "Sign In")
                    }
                        
                    NavigationLink(destination: AuthenticationView(showSignInView: false)) {
                        SecondaryButton(title: "Sign Up")
                    }
                    Divider()
                }
            }
        }
    }
}
    




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
