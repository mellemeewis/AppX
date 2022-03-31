//
//  WelcomeToAppxView.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 16/11/2021.
//

import SwiftUI

struct WelcomeToAppxView: View {
    @Binding var userSignedIn: Bool
    @ObservedObject var currentUser: User

    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            VStack {
                Spacer()
                Text("Welcome to AppX! We just opened your first photoroll and you can start taking pictures right away!")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                Spacer()
                Image("CameraWelcome")
                    .resizable()
                    .scaledToFit()
                Spacer()
                NavigationLink(destination: {
                    WelcomeToAppx2View(userSignedIn: $userSignedIn, currentUser: currentUser)
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                }) {
                    Text("Next")
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(Color("ButtonColor"))
                        .cornerRadius(20)
                        .padding()
                }
                Spacer()
            }
        }
    }
}

struct WelcomeToAppxView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeToAppxView(userSignedIn: .constant(false), currentUser: User())
    }
}
