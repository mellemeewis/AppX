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
    @State var rotation: Double = 270.0
    
    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            
            VStack {
                
                VStack {
//                    Color("BackgroundColor")
                    Spacer()
                    Text("Photos remaining in current roll:")
                        .fontWeight(.bold)
                        .font(.system(size: 500))
                        .scaledToFit()
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
                        .padding()
                    
                    if currentUser.currentPromotion == "" {
                        Spacer()
                         Image("Spinner\(currentUser.maxPhotosInNormalPhotoRoll - currentUser.photosInCurrentPhotoRoll)")
                     .onAppear(perform: { withAnimation(.linear(duration: 1),        {rotation = 0})})
//                         .onAppear(perform: {startRotation = true})
                            .rotationEffect(.degrees(rotation))
//                         .animation(.linear(duration: 1))
//                            .onDisappear(perform: { rotation = 270.0})
                     } else {
                         Image("Spinner\(currentUser.maxPhotosInCurrentPromotionPhotoRoll - currentUser.photosInCurrentPromotionPhotoRoll)")
                         .onAppear(perform: { withAnimation(.linear(duration: 1), {rotation = 0})})
 //                      .onAppear(perform: startRotation = true})
                         .rotationEffect(.degrees(rotation))
//                         .animation(.linear(duration: 1))
//                         .onDisappear(perform: { rotation = 270.0})
     
                     }
//                   .overlay(
//                        HStack {
//                        Spacer()
//                            RoundedRectangle(cornerRadius: 20)
//                            .fill(Color.white)
//                            .frame(width: 40, height: 30, alignment: .center)
//                            .opacity(0.3)
//                            .padding()
//                    })
                    Spacer()
                    
                }//.frame(height: UIScreen.main.bounds.height/1.9)
                
                VStack {
                    if currentUser.bannerURL == "" {
                        Spacer()
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

//                        Spacer()
                        TextField("Coupon code", text: $couponCode)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.gray)
                                        .opacity(0.3))
                                .padding()
                                .onAppear(perform: {self.couponCode = ""})
                        
                        Spacer()
                        Button(action: {
                            print("HI")
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
                        Spacer()
                    } else {
                        HStack {
                            Text("Your photos are provided by \(currentUser.promotionCompany).")
                                    .fontWeight(.bold)
                                    .font(.system(size: 500))
                                    .scaledToFit()
                                    .minimumScaleFactor(0.01)
                                    .lineLimit(1)
                                    .padding([.top, .bottom, .trailing], 10)
                            Spacer()
                        }.padding(.leading)
                        URLImage(URL(string: currentUser.bannerURL)!) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        
                    }
                }//.frame(height: UIScreen.main.bounds.height/1.9)
                //
//                Spacer()
//
//
//
//                Spacer()
//

            }
            
        }
    }
}

struct CameraRollView_Previews: PreviewProvider {
    static var previews: some View {
        CameraRollView(currentUser: User())
    }
}
