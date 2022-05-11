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


//import SwiftUI
//import URLImage
//import URLImageStore
//
//@main
//struct MyApp: App {
//    var body: some Scene {
//        let urlImageService = URLImageService(fileStore: nil, inMemoryStore: URLImageInMemoryStore())
//
//        return WindowGroup {
//            ContentView()
//                .environment(\.urlImageService, urlImageService)
//        }
//    }
//}
