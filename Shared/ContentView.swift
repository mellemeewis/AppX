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
    @StateObject var paymentService = PaymentService()
    init() {
//        UITabBar.appearance().barTintColor = UIColor.blue// UIColor(named: "Color1")
//        UITabBar.appearance().barTintColor =  UIColor.black

//        UITabBar.appearance().backgroundColor =  UIColor(named: "Color1")
//
//        UITabBar.appearance().barTintColor = UIColor.black
//        UITabBar.appearance().tintColor = .red
//        UITabBar.appearance().layer.borderColor = UIColor.clear.cgColor
//        UITabBar.appearance().clipsToBounds = true
        
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
//            appearance.backgroundColor = UIColor(named: "Color1")
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        } else {
            //TODO
        }
    }
    
    var body: some View {
        ZStack {
            if userSignedIn {

                TabView() {
                    CameraRollView(currentUser: self.currentUser)
                     .tabItem {
                         Image(systemName: "phone.fill")
                         Text("PhotoRoll")
                     }
                    CameraView(currentUser: self.currentUser)
                     .tabItem {
                        Image(systemName: "camera.fill")
                        Text("Camera")

                    }
                    AccountView(paymentService: self.paymentService, currentUser: currentUser, userSignedIn: $userSignedIn)
                      .tabItem {
                          Image(systemName: "person.circle.fill")
                          Text("Account")

                    }
                }
                .accentColor(Color("ButtonColor"))
                .onAppear {
                    self.currentUser.fetchUserDataFromDatabase()
//                    self.paymentService.listMandates(user: self.currentUser)
                }
                
            }
            else {
                WelcomeView(userSignedIn: $userSignedIn, currentUser: self.currentUser, paymentService: self.paymentService)
            }
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



//.onReceive(orientationChanged) { _ in
////                    model.service.stop()
//    self.orientation = UIDevice.current.orientation
//}
//@State var orientation = UIDevice.current.orientation
//
//let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
//        .makeConnectable()
//        .autoconnect()
