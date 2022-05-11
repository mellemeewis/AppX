//
//  CameraViewModel.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 05/05/2022.
//

import CoreImage
import AVFoundation
import UIKit

class CameraViewModel2: NSObject, ObservableObject {
    var lastCaptureOrientation: UIDeviceOrientation?
    var lastCameraPosition: AVCaptureDevice.Position?
    let filter = "CIPhotoEffectTransfer"
    private let context = CIContext()

    @Published var frame: CGImage?
    @Published var capturedPhoto: UIImage?
    private let frameManager = FrameManager.shared
  
    @Published var error: Error?
    @Published var cameraPostion: AVCaptureDevice.Position?
    private let cameraManager = CameraManager.shared
    
    @Published var flashMode: AVCaptureDevice.FlashMode = .off

    override init() {
        super.init()
    setupSubscriptions()
  }
  
  func switchCamera() {
    self.cameraManager.switchCamera()
  }
    
    func capturePhoto(with settings: AVCapturePhotoSettings, orientation: UIDeviceOrientation, postion: AVCaptureDevice.Position) {
        self.lastCaptureOrientation = orientation
        self.lastCameraPosition = postion
        cameraManager.capturePhoto(with: settings, self)
        frameManager.keepUpdatingFrame = false
     }
    
    func continueUpdattingFrame() {
        frameManager.keepUpdatingFrame = true
    }
  
    
    func zoom(with factor: CGFloat) {
        self.cameraManager.set(zoom: factor)
    }
  func toggleFlash() {
    self.cameraManager.toggleFlash()
  }

  func setupSubscriptions() {
    // 1
    cameraManager.$flashMode
        .receive(on: RunLoop.main)
        .map { $0 }
        .assign(to: &$flashMode)

    cameraManager.$error
        .receive(on: RunLoop.main)
        .map { $0 }
        .assign(to: &$error)

    cameraManager.$cameraPostion
        .receive(on: RunLoop.main)
        .map { $0 }
        .assign(to: &$cameraPostion)

//    frameManager.$capturedPhoto
//        .receive(on: RunLoop.main)
//        .map { $0 }
//        .assign(to: &$capturedPhoto)
    
    frameManager.$current
      .receive(on: RunLoop.main)
      .compactMap { $0 }
      .compactMap { buffer in
        // 1
        guard let image = CGImage.create(from: buffer) else {
          return nil
        }
        let ciImage = CIImage(cgImage: image).applyingFilter(self.filter)
        return self.context.createCGImage(ciImage, from: ciImage.extent)
      }
      .assign(to: &$frame)
  }
}


extension CameraViewModel2: AVCapturePhotoCaptureDelegate {
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    // captured photo
  if let cgImage = photo.cgImageRepresentation() {
      
      let height = cgImage.height
      let width = lastCaptureOrientation!.rawValue == 3 ? Double(cgImage.height) * 1.1111 : Double(cgImage.height) * 0.9
      let yOffset = 0.0
      let xOffset = lastCaptureOrientation!.rawValue == 3 ? UIScreen.main.bounds.width * 0.9 : UIScreen.main.bounds.width * 1.11111
      let cropRect = CGRect(x: xOffset, y: yOffset, width: Double(width), height: Double(height)).integral
      let croppedImage = cgImage.cropping(to: cropRect)
      
      let ciImage = CIImage(cgImage: croppedImage!).applyingFilter(self.filter)
      var capturedPhoto = self.context.createCGImage(ciImage, from: ciImage.extent)
      
      if self.lastCaptureOrientation!.rawValue == 3 && lastCameraPosition == .front{
          self.capturedPhoto = UIImage(cgImage: capturedPhoto!, scale: 1, orientation: .left)
      } else {
          self.capturedPhoto = UIImage(cgImage: capturedPhoto!, scale: 1, orientation: .right)
      }
    }
  }
}
