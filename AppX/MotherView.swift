//
//  MotherView.swift
//  AppX
//
//  Created by Melle Meewis on 03/07/2020.
//  Copyright © 2020 Melle Meewis. All rights reserved.
//

import SwiftUI
import Firebase

struct MotherView : View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        VStack {
            if viewRouter.userLoggedIn == true {
                HomeScreenView()
            } else if viewRouter.userLoggedIn == false {
                WelcomeView()
            }
        }.onAppear() {
            if Auth.auth().currentUser != nil {
                self.viewRouter.userLoggedIn = true
            } else {
                self.viewRouter.userLoggedIn = false
            }
        }
    }
}
