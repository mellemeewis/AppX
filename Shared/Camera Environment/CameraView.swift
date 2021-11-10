//
//  CameraView.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 17/09/2021.
//
import SwiftUI
import Foundation
import Firebase
import URLImage

struct CameraView: View {
    @StateObject var model = CameraViewModel()
    @StateObject var storageManager = StorageManager()
    @ObservedObject var currentUser: User
    @State var currentZoomFactor: CGFloat = 1.0
    @State var timeRemaining = 5
    @State var pictureHidden = true

    var promtionBanner: some View {

        ZStack {
            Spacer()
            URLImage(URL(string: currentUser.promotionURL)!) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            }
        }
    }
    
    var polaroidFrame: some View {
        
        GeometryReader { reader in

        Image("PolaroidFrame")
            .resizable()
            .gesture(
                DragGesture().onChanged({ (val) in
                    if abs(val.translation.width) > abs(val.translation.height) {
                        let percentage: CGFloat = (val.translation.width / reader.size.width)
                        let calc = currentZoomFactor + percentage
                        let zoomFactor: CGFloat = min(max(calc, 1), 5)
                        currentZoomFactor = zoomFactor
                        model.zoom(with: zoomFactor)
                    }
                })
            )
        }
//            .aspectRatio(contentMode: .fit)
    }
    

    var captureButton: some View {
        Button(action: {
            model.capturePhoto()
        }, label: {
            
            ZStack {
                Circle()
                    .frame(width: 65.0, height: 65.0)
                    .accentColor(.red)
                Circle()
                    .stroke(lineWidth: 6)
                    .frame(width: 75.0, height: 75.0)
                    .accentColor(.black)
                }
            })
    }
    
    var flashButton: some View {
        Button(action: {
            model.switchFlash()
        }, label: {
            Circle()
                .foregroundColor(Color.gray.opacity(0.2))
                .frame(width: 55, height: 55, alignment: .center)
                .overlay(
            Image(systemName: model.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
                .foregroundColor(model.isFlashOn ? .yellow : .blue))
                .imageScale(.large)
        })
    }
    
//    var capturedPhoto: some View {
//        ZStack {
//            let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//
//            if model.photo != nil {
//
//                Image(uiImage: model.photo.image!)
//                    .resizable()
////                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width)
////                    .aspectRatio(contentMode: .fit)
//
////                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
////                    .animation(.spring())
////                    .rotationEffect(.degrees(270))
//
////                VStack {
////                    HStack {
////                        Button(action: {
////                            model.showImage = false
////                            timer.upstream.connect().cancel()
////                        }, label: {
////                            Text("Retake")
////                                .padding(.all)
////                        })
////                        Spacer()
////                        Button(action: {
//////                                UIImageWriteToSavedPhotosAlbum(model.photo.image!, nil, nil, nil)
////                            storageManager.upload(image: model.photo.image!, inPhotoRoll: currentUser.currentPhotoRoll)
////                            model.showImage = false
////                            currentUser.updatePhotoRollStatus()
////                            timer.upstream.connect().cancel()
////                        }, label: {
////                            Text("Use this photo!")
////                                .padding(.all)
////                        })
////                    }
////                    Spacer()
////                }
//
//                Text("\(timeRemaining)")
//                    .font(.system(size: 100))
//                    .fontWeight(.bold)
//                    .foregroundColor(Color.white)
//                    .multilineTextAlignment(.center)
//                    .opacity(0.5)
//                    .onReceive(timer) { _ in
//                    timeRemaining -= 1
//
//                    if timeRemaining == 0 {
//                        storageManager.upload(image: model.photo.image!, inPhotoRoll: currentUser.currentPhotoRoll)
//                        model.showImage = false
//                        currentUser.updatePhotoRollStatus()
//                        timer.upstream.connect().cancel()
//                    }
//                    }
//
//            } else {
//                EmptyView()
//            }
//        }.onAppear(perform: {timeRemaining = 5})
//    }
//

    
    var flipCameraButton: some View {
        Button(action: {
            model.flipCamera()
        }, label: {
            Circle()
                .foregroundColor(Color.gray.opacity(0.2))
                .frame(width: 55, height: 55, alignment: .center)
                .overlay(
                    Image(systemName: "camera.rotate.fill")
                        .imageScale(.large)
                        .foregroundColor(.white))
        })
    }
    
    var cameraPreview: some View {
        CameraPreview(session: model.session)
            .onAppear(perform: {
                model.configure()
            })

            .overlay(
                ZStack {
                    if model.service.willCapturePhoto {
                        Color.black
                    }
                }
            )
    }
    
    var body: some View {
        ZStack {

            cameraPreview
                .ignoresSafeArea(edges: model.showImage ? .horizontal : .top)

            if model.showSpinner {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    .scaleEffect(4)
            }

            VStack {
                Spacer()
            
                HStack {
                    flashButton
                        .padding()
                        .rotationEffect(.degrees(90))
                    Spacer()
                    captureButton
                        .padding()
                        .rotationEffect(.degrees(90))
                    Spacer()
                    flipCameraButton
                        .padding()
                        .rotationEffect(.degrees(90))
                }
            }
            
            

            if model.showImage {
                ZStack{
                    Color("ButtonColor")
 
//                        .ignoresSafeArea()
//
//                        Image(uiImage: model.photo.image!)
//                            .resizable()
//                            .rotationEffect(.degrees(270))
//                            .aspectRatio(contentMode: .fit)
//                            .ignoresSafeArea()
//                            .scaledToFit()
//                            .opacity(pictureHidden ? 0 : 1)
//                            .animation(.easeIn(duration: 2))
                        
                        Image("PolaroidFrame")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width*0.85, height:(UIScreen.main.bounds.width*0.85)*1.25)
                    
                        Image(uiImage: model.photo.image!)
                            .resizable()
                            .scaledToFit()
                            .rotationEffect(.degrees(90))
                            .position(x: UIScreen.main.bounds.width*0.55466, y: UIScreen.main.bounds.height*0.44977)
                            .opacity(pictureHidden ? 0 : 1)
                            .animation(.easeIn(duration: 5))
                    
                    VStack {
                        Spacer()
                        HStack {
                            Button(action: {
                                model.showImage = false
                                pictureHidden = true
                                print(UIScreen.main.bounds)
                               //                      timer.upstream.connect().cancel()
                            }, label: {
                                Circle()
                                    .foregroundColor(Color.red)
                                    .frame(width: 55, height: 55, alignment: .center)
                                    .overlay(
                                        Image(systemName: "xmark")
                                            .rotationEffect(.degrees(90))
                                            .imageScale(.large)
                                            .foregroundColor(.white))
                            })
                                .padding()
                            Spacer()
                            Button(action: {
                                model.showImage = false
                                pictureHidden = true
                                storageManager.upload(image: model.photo.image!, inPhotoRoll: currentUser.currentPhotoRoll)
                                currentUser.updatePhotoRollStatus()
                                ////                            timer.upstream.connect().cancel()
                            }, label: {
                                Circle()
                                    .foregroundColor(Color.green)
                                    .frame(width: 55, height: 55, alignment: .center)
                                    .overlay(
                                        Image(systemName: "checkmark")
                                            .rotationEffect(.degrees(90))
                                            .imageScale(.large)
                                            .foregroundColor(.white))
                            })
                                .padding()
                        }

                    }
                            
                    
                }.onAppear(perform: {
                    pictureHidden = false
                })
            }
        }

        .alert(isPresented: $model.showAlertError, content: {
            Alert(title: Text(model.alertError.title), message: Text(model.alertError.message), dismissButton: .default(Text(model.alertError.primaryButtonTitle), action: {
                model.alertError.primaryAction?()
            }))
        })
    }
}
