//
//  NewPhotoRollView.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 17/11/2021.
//

import SwiftUI

struct NewPhotoRollView: View {
    @ObservedObject var currentUser: User
    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            
            VStack {
                Spacer()
                if currentUser.currentPromotion == "" {
                    Text("Thank you for using AppX, we are happy to have you on board and can't wait to take your memories offline! \n\nYour current photoroll is full and we'll be sending your photographs as soon as possible once your payment is proccesed.\n\nWe opened a new photoroll for you in which you can save your new memories! No worries, if you don't complete this new photoroll you won't be charged for anything.")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                } else {
                    if currentUser.photosInCurrentPhotoRoll > 0 {
                        Text("Thank you for using AppX, we are happy to have you on board and can't wait to take your memories offline! \n\nYour current photoroll is full and we'll be sending your photographs as soon as possible. The photos in this photoRoll were provided by \(currentUser.promotionCompany ).\n\nYou still had \(currentUser.maxPhotosInNormalPhotoRoll - currentUser.photosInCurrentPhotoRoll) remaning in your old photoroll! No worries, if you don't complete this photoroll you won't be charged for anything.")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding()
                    } else {
                        Text("Thank you for using AppX, we are happy to have you on board and can't wait to take your memories offline! \n\nYour current photoroll is full and we'll be sending your photographs as soon as possible. The photos in this photoRoll were provided by \(currentUser.promotionCompany ).\n\nWe opened a new photoroll for you in which you can save your new memories! No worries, if you don't complete this new photoroll you won't be charged for anything.")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding()
                    }
   
                }

                Spacer()
                
                Button(action: {currentUser.showNewPhotoRollSheet = false}) {
                    Text("OK")
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

struct NewPhotoRollView_Previews: PreviewProvider {
    static var previews: some View {
        NewPhotoRollView(currentUser: User())
    }
}
