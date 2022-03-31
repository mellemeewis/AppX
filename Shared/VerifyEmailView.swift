//
//  VerifyEmailView.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 18/11/2021.
//

import SwiftUI

struct VerifyEmailView: View {
    @ObservedObject var currentUser: User
    
    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            VStack {
                Spacer()
                Text("Thank you for using AppX, we are happy to have you on board and can't wait to take your memories offline! \n\nCurrently, you email account is not verified by our system, which means we can't procces your order once your photoroll is full.\n\nPlease verify your email using the link we will send to your email account, and don't forget to check your spam folder when you can't find it.")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                Spacer()
                
                Button(action: {currentUser.sendEmailVerification()} ){
                    Text("Send email link")
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(Color("ButtonColor"))
                        .cornerRadius(20)
                }.padding()
                Spacer()
            }.padding()
            }
    }
}

struct VerifyEmail_Previews: PreviewProvider {
    static var previews: some View {
        VerifyEmailView(currentUser: User())
    }
}
