//
//  WelcomeToAppx4View.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 18/11/2021.
//

import SwiftUI

struct WelcomeToAppx4View: View {
    @Binding var userSignedIn: Bool
    @ObservedObject var currentUser: User

    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            VStack {
                Spacer()
                Text("For now, please confirm your email account.")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                Spacer()
                Image("VerifyEmailWelcome")
                    .resizable()
                    .scaledToFit()
                Spacer()
                Button(action: {
                    self.userSignedIn = true
                    UIApplication.shared.open(URL(string: "message://")!, options: [:], completionHandler: nil) }) {
                    Text("Open email app!")
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
        }.onAppear(perform: {currentUser.sendEmailVerification()})
    }
}
struct WelcomeToAppx4View_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeToAppx4View(userSignedIn: .constant(false), currentUser: User())
    }
}
