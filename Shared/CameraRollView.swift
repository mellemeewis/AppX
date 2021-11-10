//
//  CameraRoll.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 08/10/2021.
//

import SwiftUI
import URLImage

struct CameraRollView: View {
    @ObservedObject var currentUser: User
    @State public var couponCode: String = ""

    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            
            VStack {
//                Spacer()
                Text("Photos taken:")
                    .fontWeight(.bold)
                    .font(.system(size: 500))
                    .scaledToFit()
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                    .padding()

                Text("\(currentUser.photosInCurrentPhotoRoll) / \(  currentUser.maxPhotosInCurrentPhotoRoll) ")
                    .fontWeight(.bold)
                    .font(.system(size: 500))
                    .scaledToFit()
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                    .padding()
                
                Spacer()
                
                if currentUser.promotionURL == "" {
                    
                    HStack {
                        Text("Did you recieve a discount coupon?")
                                .fontWeight(.bold)
                                .font(.system(size: 500))
                                .scaledToFit()
                                .minimumScaleFactor(0.01)
                                .lineLimit(1)
                                .padding([.top, .bottom, .trailing], 10)
                        Spacer()
                    }.padding(.leading)
                    
                        
                    TextField("Coupon code", text: $couponCode)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.gray)
                                    .opacity(0.3))
                            .padding()

                    Button(action: {
                            currentUser.setPromotion(couponCode: couponCode)
                        }) {
                        Text("Validate")
                            .fontWeight(.bold)
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("ButtonColor"))
                            .cornerRadius(10)
                        }.padding()
                    
                } else {
                    HStack {
                        Text("Your photos are provided by \(currentUser.promotionCompany).")                    .fontWeight(.bold)
                                .font(.system(size: 500))
                                .scaledToFit()
                                .minimumScaleFactor(0.01)
                                .lineLimit(1)
                                .padding([.top, .bottom, .trailing], 10)
                        Spacer()
                    }.padding(.leading)
                    
                    URLImage(URL(string: currentUser.promotionURL)!) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    
                }
            }
        }
    }
}

struct CameraRollView_Previews: PreviewProvider {
    static var previews: some View {
        CameraRollView(currentUser: User())
    }
}
