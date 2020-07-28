//
//  HomeScreenView.swift
//  AppX
//
//  Created by Melle Meewis on 03/07/2020.
//  Copyright © 2020 Melle Meewis. All rights reserved.
//

import SwiftUI
import Firebase

struct HomeScreenView: View {
    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        VStack {
            Button(action: { self.handleSignOut() }) { PrimaryButton(title: "Sign Out") }
        }
    }
    
    func handleSignOut() {
        try! Auth.auth().signOut()
        print("Signed out")
        viewRouter.userLoggedIn = false
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
