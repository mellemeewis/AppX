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
    @State private var orientation: UIDeviceOrientation = .portrait
    @State private var isFrontCamera: Bool = false
    @State private var showConfirmation: Bool = false
    @State private var rotateConfirmationCheckmark: Int = 30
    @State private var showConfirmationCheckmark: Int = -240

    @State private var showDeleteConfirmation: Bool = false
    
    var polaroidFrame: some View {
        GeometryReader { reader in

        Image("PolaroidFrame")
            .resizable()
        }
    }
    

    var captureButton: some View {
        Button(action: {
            model.capturePhoto(orientation: self.orientation, isFrontCamera: self.isFrontCamera)
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
            self.isFrontCamera.toggle()
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
    }
    
    var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea(edges: .top)

            GeometryReader { reader in
                cameraPreview
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: self.orientation == .landscapeLeft ? UIScreen.main.bounds.width * 1.111 : UIScreen.main.bounds.width * 0.9,
                        alignment: .center)
                    .animation(.linear(duration: 1))
                    .position(x:UIScreen.main.bounds.width/2, y:UIScreen.main.bounds.height/2.5)
//                    .rotationEffect(.degrees(self.orientation == .landscapeLeft ? 90 : 0))
                    .gesture(
                        DragGesture().onChanged({ (val) in
                            if abs(val.translation.height) > abs(val.translation.width) {
                                let percentage: CGFloat = (-val.translation.height / reader.size.height)
                                let calc = currentZoomFactor + percentage
                                let zoomFactor: CGFloat = min(max(calc, 1), 5)
                                currentZoomFactor = zoomFactor
                                model.zoom(with: zoomFactor)
                            }
                        })
                    )
            }.onRotate { newOrientation in
                if model.showImage == false {
                    self.orientation = newOrientation
                }
            }
                

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
                        .rotationEffect(.degrees(self.orientation == .landscapeLeft ? 90 : 0))
                    Spacer()
                    captureButton
                        .padding()
                        .rotationEffect(.degrees(self.orientation == .landscapeLeft ? 90 : 0))
                    Spacer()
                    flipCameraButton
                        .padding()
                        .rotationEffect(.degrees(self.orientation == .landscapeLeft ? 90 : 0))
                }
            }
            
//            if self.showConfirmation == true {
                Image(systemName: "checkmark")
                    .font(.system(size: 240))
                    .foregroundColor(.green)
                    .rotationEffect(.degrees(Double(rotateConfirmationCheckmark)))
                    .clipShape(Rectangle().offset(x: CGFloat(showConfirmationCheckmark)))
                    
                    
            
//            }
            
            if self.showDeleteConfirmation {
                
            }

            if model.showImage {
                ZStack{
                    Color("ButtonColor")
                        Image(uiImage: model.photo.image!)
                            .resizable()
                            .scaledToFit()
                            .opacity(pictureHidden ? 0 : 1)
                            .animation(.easeIn(duration: 5))
                            .frame(
                                width: self.orientation == .landscapeLeft ? UIScreen.main.bounds.width * 0.81 : UIScreen.main.bounds.width * 0.88,
                                height: self.orientation == .landscapeLeft ? UIScreen.main.bounds.width * 0.9 : UIScreen.main.bounds.width * 0.88 * 0.9,
                                alignment: .center)
                            .offset(
                                x: self.orientation == .landscapeLeft ? UIScreen.main.bounds.width*0.045 : 0,
                                y: self.orientation == .landscapeLeft ? 0: -UIScreen.main.bounds.width*0.05)
                      

                    if currentUser.frameURL == "" {
                        Image("PolaroidFrame")
                            .resizable()
                            .scaledToFit()
                            .rotationEffect(.degrees(self.orientation == .landscapeLeft ? 90 : 0))
                    } else {
                        URLImage(URL(string: currentUser.frameURL)!) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .rotationEffect(.degrees(self.orientation == .landscapeLeft ? 90 : 0))
                        }
                    }

                    VStack {
                        Spacer()
                        HStack {
                            Button(action: {
                                self.showDeleteConfirmation = true
                                model.showImage = false
                                pictureHidden = true
                               //                      timer.upstream.connect().cancel()
                            }, label: {
                                Circle()
                                    .foregroundColor(Color.red)
                                    .frame(width: 55, height: 55, alignment: .center)
                                    .overlay(
                                        Image(systemName: "xmark")
                                            .rotationEffect(.degrees(self.orientation == .landscapeLeft ? 90 : 0))
                                            .imageScale(.large)
                                            .foregroundColor(.white))
                            })
                                .padding()
                            Spacer()
                            Button(action: {
                                self.showConfirmation = true
                                    withAnimation(.interpolatingSpring(stiffness: 170, damping: 15)){
                                        self.showConfirmationCheckmark = 0
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            self.showConfirmationCheckmark = -240
                                        }
                                    }
//                                self.showConfirmationCheckmark = 0
                                self.rotateConfirmationCheckmark = 0
                                model.showImage = false
                                pictureHidden = true
                                storageManager.upload(image: model.photo.image!, user: currentUser)
                                currentUser.updatePhotoRollStatus()
                                ////                            timer.upstream.connect().cancel()
                            }, label: {
                                Circle()
                                    .foregroundColor(Color.green)
                                    .frame(width: 55, height: 55, alignment: .center)
                                    .overlay(
                                        Image(systemName: "checkmark")
                                            .rotationEffect(.degrees(self.orientation == .landscapeLeft ? 90 : 0))
                                            .imageScale(.large)
                                            .foregroundColor(.white))
                                
                            })
                                .padding()
                        }

                    }
                            
                    
                }.onAppear(perform: {
                    pictureHidden = false
                    self.orientation = UIDevice.current.orientation
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
