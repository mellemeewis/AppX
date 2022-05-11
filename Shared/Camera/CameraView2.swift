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

struct CameraView2: View {

    @StateObject var model = CameraViewModel2()
    @StateObject var storageManager = StorageManager()
    @ObservedObject var currentUser: User
    @State var timeRemaining = 5
    @State var pictureHidden = true
    @State private var orientation: UIDeviceOrientation = .portrait
    @State private var showConfirmation: Bool = false
    @State private var rotateConfirmationCheckmark: Int = 45
    @State private var showConfirmationCheckmark: Int = -240
    @State private var showDeleteConfirmation: Bool = false
    private let label = Text("Camera feed")
    
    var body: some View {

        ZStack {
            Color(.black).ignoresSafeArea(edges: .top)
            .onRotate { newOrientation in
                withAnimation(.linear(duration: 0.5)) {
                    self.orientation = newOrientation
                }

            }

            FrameView(image: model.frame,  orientation: self.$orientation, model: self.model)
            ControlView(model: self.model,  orientation: self.$orientation)

            if self.showConfirmation == true {
                Image(systemName: "checkmark")
                    .font(.system(size: 240))
                    .foregroundColor(.green)
                    .rotationEffect(.degrees(Double(rotateConfirmationCheckmark)))
                    .clipShape(Rectangle().offset(x: CGFloat(showConfirmationCheckmark)))
                    .rotationEffect(.degrees(self.orientation == .landscapeLeft ? 90 : 0))
            }

            if let image = model.capturedPhoto {
                ZStack{
                    Color("ButtonColor")
                    Image(uiImage: image)
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
                        .onAppear(perform: {self.pictureHidden = false})

                    if currentUser.frameURL == "" {
                        Image("PolaroidFrame")
                            .resizable()
                            .scaledToFit()
                            .rotationEffect(.degrees(self.orientation == .landscapeLeft ? 90 : 0))
                    } else {

                        URLImage(URL(string: currentUser.frameURL)!) { progress in
                            EmptyView()
                        } failure: { error, retry in
                            Image("PolaroidFrame")
                                .resizable()
                        } content: { frame in
                            frame
                                .resizable()
                        }
                            .scaledToFit()

                            .rotationEffect(.degrees(self.orientation == .landscapeLeft ? 90 : 0))
                        }

                    VStack {
                        Spacer()
                        HStack {
                            Button(action: {
                                self.showDeleteConfirmation = true
                                model.capturedPhoto = nil
                                pictureHidden = true
                                model.continueUpdattingFrame()
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
                                model.continueUpdattingFrame()

                                self.showConfirmation = true
                                    withAnimation(.interpolatingSpring(stiffness: 80, damping: 150)){
                                        self.showConfirmationCheckmark = 0
                                        self.rotateConfirmationCheckmark = 0
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            self.showConfirmationCheckmark = -240
                                            self.rotateConfirmationCheckmark = 45
                                        }
                                    }
//                                self.showConfirmationCheckmark = 0
                                pictureHidden = true
                                storageManager.upload(image: model.capturedPhoto!, user: currentUser, cameraPosition: model.lastCameraPosition!)
                                currentUser.updatePhotoRollStatus()
                                model.capturedPhoto = nil
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
                    }
            }
            ErrorView(error: model.error)

        }
    }
}
