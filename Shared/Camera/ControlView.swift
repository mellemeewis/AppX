//
//  ControlView.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 05/05/2022.
//


import SwiftUI
import AVFoundation

struct ControlView: View {

    @ObservedObject var model: CameraViewModel2
    @Binding var orientation: UIDeviceOrientation
    
    var captureButton: some View {
        Button(action: {
            model.capturePhoto(with: AVCapturePhotoSettings(), orientation: self.orientation, postion: self.model.cameraPostion!)
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
    
    var flipCameraButton: some View {
        Button(action: {
            model.switchCamera()
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
    
    var flashButton: some View {
         Button(action: {
             model.toggleFlash()
         }, label: {
             Circle()
                 .foregroundColor(Color.gray.opacity(0.2))
                 .frame(width: 55, height: 55, alignment: .center)
                 .overlay(
//         })
             Image(systemName: model.flashMode == .on ? "bolt.fill" : "bolt.slash.fill")
                 .foregroundColor(model.flashMode == .on ? .yellow : .blue))
                 .imageScale(.large)
         })
     }
                

  var body: some View {
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
  }
}
