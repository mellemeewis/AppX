//
//  ContentView.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 14/09/2021.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selection = 2
    @State var userSignedIn: Bool = Auth.auth().currentUser != nil
    @StateObject var currentUser = User()
    @StateObject var paymentService = PaymentService()
    @State var showVerifyEmailSheet: Bool = false
    @State var forceEmailVerification: Bool = false

//    init() {
////        UITabBar.appearance().barTintColor = UIColor.blue// UIColor(named: "Color1")
////        UITabBar.appearance().barTintColor =  UIColor.black
//
////        UITabBar.appearance().backgroundColor =  UIColor(named: "Color1")
////
////        UITabBar.appearance().barTintColor = UIColor.black
////        UITabBar.appearance().tintColor = .red
////        UITabBar.appearance().layer.borderColor = UIColor.clear.cgColor
////        UITabBar.appearance().clipsToBounds = true
//        
//        
//        if #available(iOS 15.0, *) {
//            let appearance = UITabBarAppearance()
//            appearance.configureWithOpaqueBackground()
////            appearance.backgroundColor = UIColor(named: "Color1")
//            UITabBar.appearance().standardAppearance = appearance
//            UITabBar.appearance().scrollEdgeAppearance = appearance
//        } else {
//            //TODO
//        }
//    }
    
    var body: some View {
        ZStack {
            if userSignedIn {

                TabView(selection: $selection) {
                    CameraRollView(currentUser: self.currentUser)
                     .tabItem {
                         Image(systemName: "photo.on.rectangle")
                         Text("PhotoRoll")
                     }
                     .tag(1)
                    CameraView(currentUser: self.currentUser)
                     .tabItem {
                        Image(systemName: "camera.fill")
                        Text("Camera")

                     }
                     .tag(2)
                    AccountView(paymentService: self.paymentService, currentUser: currentUser, userSignedIn: $userSignedIn)
                      .tabItem {
                          Image(systemName: "person.circle.fill")
                          Text("Account")

                    }
                      .tag(3)
                }
                .accentColor(Color("ButtonColor"))
                .onAppear {
                    self.currentUser.fetchUserDataFromDatabase()
                    self.selection = 2
                }
                .fullScreenCover(isPresented: $currentUser.forcePayment, content: { PaymentSheetView(currentUser: self.currentUser, paymentService: self.paymentService) })
                .sheet(isPresented: $currentUser.showPaymentSheet, content: { PaymentSheetView(currentUser: self.currentUser, paymentService: self.paymentService) })
                .sheet(isPresented: $currentUser.showNewPhotoRollSheet, onDismiss: {currentUser.endPromotion() } ,content: {NewPhotoRollView(currentUser: self.currentUser)})
                .sheet(isPresented: $showVerifyEmailSheet ,content: {VerifyEmailView(currentUser: self.currentUser)})
            }
            else {
                WelcomeView(userSignedIn: $userSignedIn, currentUser: self.currentUser, paymentService: self.paymentService)
            }
        }
//        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
//            if Auth.auth().currentUser != nil {
//                print(Auth.auth().currentUser?.isEmailVerified)
//                if Auth.auth().currentUser?.isEmailVerified == false  && currentUser.forceEmailVerification == false {
//                        self.showVerifyEmailSheet = true
//                }
//            }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
