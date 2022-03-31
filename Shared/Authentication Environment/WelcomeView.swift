//
//  WelcomeView.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 15/09/2021.
//

import SwiftUI
import Firebase

struct WelcomeView: View {
    @State private var showSignInSheet = false
    @State private var showSignUpSheet = false
    @Binding var userSignedIn: Bool
    @ObservedObject var currentUser: User
    @ObservedObject var paymentService: PaymentService

    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            VStack {

            Image("LaunchScreenImage")
                .resizable()
                .scaledToFit()
        
//                Spacer()
                VStack {
                    Button(action: { showSignUpSheet.toggle() }) {
                        Text("Create Account")
                            .fontWeight(.bold)
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .background(Color("ButtonColor"))
                            .cornerRadius(10)
                    }
                    Button(action: { showSignInSheet.toggle() }) {
                        Text("Sign In")
                            .fontWeight(.bold)
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .background(Color("ButtonColor"))
                            .cornerRadius(10)
                    }
                }
                .padding(.all)
            }
        }
        .sheet(isPresented: $showSignInSheet) {
            SignInView(userSignedIn: $userSignedIn)
        }
        .sheet(isPresented: $showSignUpSheet) {
            SignUpView(currentUser: self.currentUser, paymentService: self.paymentService, userSignedIn: $userSignedIn).onDisappear(perform: {
                if Auth.auth().currentUser != nil {
                    self.userSignedIn = true
                } })
//            SignUpView(currentUser: self.currentUser)
        }
    }
}

//struct WelcomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        WelcomeView(userSignedIn: .constant(false), currentUser: User(), paymentService: self.paymentService)
//    }
//}



    

