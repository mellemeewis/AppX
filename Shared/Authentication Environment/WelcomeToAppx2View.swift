//
//  WelcomeToAppx2View.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 18/11/2021.
//

import SwiftUI

struct WelcomeToAppx2View: View {
    @Binding var userSignedIn: Bool
    @ObservedObject var currentUser: User

    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            VStack {
                Spacer()
                Text("When you have taken 10 pictures, your photoroll is full and we'll start developing your photographs as soon as possible!")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                Spacer()
                Image("DevelopingWelcome")
                    .resizable()
                    .scaledToFit()
                Spacer()
                NavigationLink(destination: {WelcomeToAppx3View(userSignedIn: $userSignedIn, currentUser: currentUser)
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
struct WelcomeToAppx2View_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeToAppx2View(userSignedIn: .constant(false), currentUser: User())
    }
}
