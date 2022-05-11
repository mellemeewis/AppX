//
//  PaymentSheetView.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 17/11/2021.
//

import SwiftUI

struct PaymentSheetView: View {
    @ObservedObject var currentUser: User
//    @ObservedObject var paymentService: PaymentService
    @Binding var tabSelection: Int

    var body: some View {
        NavigationView {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            VStack {
                Spacer()
                Text("Thank you for using AppX, we are happy to have you on board and can't wait to take your memories offline! \n\nYou already have \(currentUser.photosInCurrentPhotoRoll) photos in your current photoroll, which means it almost full.\nYou don't have a payment method activated (anymore), which means we are not able to process your order when your photoroll is full.")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                Spacer()
                
                Button(action: {tabSelection = 3}) {
                    Text("Add payment method")
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
}

//struct PaymentSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        PaymentSheetView(currentUser: User(), paymentService: PaymentService())
//    }
//}
