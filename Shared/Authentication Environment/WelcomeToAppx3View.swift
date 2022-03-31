//
//  WelcomeToAppx3View.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 18/11/2021.
//

import SwiftUI

struct WelcomeToAppx3View: View {
    @Binding var userSignedIn: Bool
    @ObservedObject var currentUser: User

    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            VStack {
                Spacer()
                Text("Once we've recieved your payment, we'll take your memories offline by delivering the developed photographs at your home!")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                Spacer()
                Image("MailboxWelcome")
                    .resizable()
                    .scaledToFit()
                Spacer()
                NavigationLink(destination: {WelcomeToAppx4View(userSignedIn: $userSignedIn, currentUser: currentUser)
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
struct WelcomeToAppx3View_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeToAppx3View(userSignedIn: .constant(false), currentUser: User())
    }
}
