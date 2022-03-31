//
//  AppXApp.swift
//  Shared
//
//  Created by Melle Meewis on 13/09/2021.
//

import SwiftUI
import Firebase

@main
struct AppXApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
