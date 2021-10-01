//
//  CameraView.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 17/09/2021.
//
import SwiftUI
import Foundation

struct CameraView: View {
    @ObservedObject var model = CameraViewModel()
    @ObservedObject var storageManager = StorageManager()

    @State var currentZoomFactor: CGFloat = 1.0
    @State var timeRemaining = 5

    var captureButton: some View {
        Button(action: {
            print("PResssed")
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
    
    var capturedPhoto: some View {
        ZStack {
            let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

            if model.photo != nil {
        
                Image(uiImage: model.photo.image!)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width)
//                    .aspectRatio(contentMode: .fit)

//                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .animation(.spring())
                
                VStack {
                    HStack {
                        Button(action: {
                            model.showImage = false
                            timeRemaining = 5
                        }, label: {
                            Text("Retake")
                                .padding(.all)
                        })
                        Spacer()
                        Button(action: {
                                UIImageWriteToSavedPhotosAlbum(model.photo.image!, nil, nil, nil)
                                storageManager.upload(image: model.photo.image!)
                                model.showImage = false }, label: {
                            Text("Use this photo!")
                                .padding(.all)
                        })
                    }
                    Spacer()
                }
                    
                Text("\(timeRemaining)")
                    .font(.system(size: 100))
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .opacity(0.5)
                    .onReceive(timer) { _ in
                    timeRemaining -= 1
 
                    if timeRemaining == 0 {
                        UIImageWriteToSavedPhotosAlbum(model.photo.image!, nil, nil, nil)
                        storageManager.upload(image: model.photo.image!)

                        model.showImage = false
                        timeRemaining = 5
                        timer.upstream.connect().cancel()
                    }
                    }
                
            } else {
                EmptyView()
            }
        }
    }
    
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
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                CameraPreview(session: model.session)
                    .frame(width: reader.size.width, height: UIScreen.main.bounds.size.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .ignoresSafeArea()
                        .gesture(
                            DragGesture().onChanged({ (val) in
                                if abs(val.translation.height) > abs(val.translation.width) {
                                    let percentage: CGFloat = -(val.translation.height / reader.size.height)
                                    let calc = currentZoomFactor + percentage
                                    let zoomFactor: CGFloat = min(max(calc, 1), 5)
                                    currentZoomFactor = zoomFactor
                                    model.zoom(with: zoomFactor)
                                }
                            })
                        )
                        .onAppear {
                            model.configure()
                        }
                        .alert(isPresented: $model.showAlertError, content: {
                            Alert(title: Text(model.alertError.title), message: Text(model.alertError.message), dismissButton: .default(Text(model.alertError.primaryButtonTitle), action: {
                                model.alertError.primaryAction?()
                            }))
                        })
                        .overlay(
                            ZStack {
                                if model.service.willCapturePhoto {
                                    Color.black
                                }
                            }
                        )
                    .animation(.easeInOut)

                VStack {
                    HStack {
                        Spacer()
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
                    
                    Spacer()
                    ZStack {
                        HStack {
                            captureButton
                        }
                        HStack {
                            Spacer()
                            flipCameraButton
                        }
                    }
                }.padding()
                
                if model.showSpinner {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        .scaleEffect(4)
                }
            }
        }
        .sheet(isPresented: $model.showImage) {
            capturedPhoto
        }
    }
}
