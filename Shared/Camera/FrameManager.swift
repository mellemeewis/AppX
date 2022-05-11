//
//  FrameManager.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 05/05/2022.
//

import AVFoundation
import UIKit

class FrameManager: NSObject, ObservableObject {
  static let shared = FrameManager()
//  var lastCaptureOrientation: UIDeviceOrientation?
//  var lastCameraPosition: AVCaptureDevice.Position?
  @Published var current: CVPixelBuffer?
  var keepUpdatingFrame: Bool = true
//  @Published var capturedPhoto: UIImage?


  let videoOutputQueue = DispatchQueue(
    label: "VideoOutputQ",
    qos: .userInitiated,
    attributes: [],
    autoreleaseFrequency: .workItem)

  private override init() {
    super.init()
    CameraManager.shared.set(self, queue: videoOutputQueue)
  }
    
//    func capturePhoto(with settings: AVCapturePhotoSettings, orientation: UIDeviceOrientation, postion: AVCaptureDevice.Position) {
//        self.lastCaptureOrientation = orientation
//        self.lastCameraPosition = postion
//       CameraManager.shared.capturePhoto(with: settings, self)
//     }
}

extension FrameManager: AVCaptureVideoDataOutputSampleBufferDelegate {
  func captureOutput(
    _ output: AVCaptureOutput,
    didOutput sampleBuffer: CMSampleBuffer,
    from connection: AVCaptureConnection
  ) {
    if let buffer = sampleBuffer.imageBuffer {
      DispatchQueue.main.async {
          if self.keepUpdatingFrame {
              self.current = buffer
          }
      }
    }
  }
}

//extension FrameManager: AVCapturePhotoCaptureDelegate {
//  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//    // captured photo
//  if let cgImage = photo.cgImageRepresentation() {
//
//      let height = cgImage.height
//      let width = lastCaptureOrientation!.rawValue == 3 ? Double(cgImage.height) * 1.1111 : Double(cgImage.height) * 0.9
//      let yOffset = 0.0
//      let xOffset = lastCaptureOrientation!.rawValue == 3 ? UIScreen.main.bounds.width * 0.9 : UIScreen.main.bounds.width * 1.11111
//      let cropRect = CGRect(x: xOffset, y: yOffset, width: Double(width), height: Double(height)).integral
//      let croppedImage = cgImage.cropping(to: cropRect)
//
//      if self.lastCaptureOrientation!.rawValue == 3 && lastCameraPosition == .front{
//          self.capturedPhoto = UIImage(cgImage: croppedImage!, scale: 1, orientation: .left)
//      } else {
//          self.capturedPhoto = UIImage(cgImage: croppedImage!, scale: 1, orientation: .right)
//      }
//    }
//  }
//}
