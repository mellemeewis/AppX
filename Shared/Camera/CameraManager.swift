//
//  CameraManager.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 05/05/2022.
//

import AVFoundation
import UIKit
class CameraManager: ObservableObject {
  
  @Published var error: CameraError?
  @Published var cameraPostion: AVCaptureDevice.Position?
  @Published public var flashMode: AVCaptureDevice.FlashMode = .off

  let session = AVCaptureSession()
  private let sessionQueue = DispatchQueue(label: "cameraSessionQueue")
  private let videoOutput = AVCaptureVideoDataOutput()
  private let photoOutput = AVCapturePhotoOutput()
  private var currentDevice: AVCaptureDevice?

  private var status = Status.unconfigured
  
  enum Status {
    case unconfigured
    case configured
    case unauthorized
    case failed
  }


  static let shared = CameraManager()
  private init() {
    configure()
  }
  
      
  private func configure() {
    checkPermissions()
    sessionQueue.async {
      self.configureCaptureSession()
      self.session.startRunning()
    }
  }
  
  private func set(error: CameraError?) {
    DispatchQueue.main.async {
      self.error = error
    }
  }


  private func checkPermissions() {
    // 1
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .notDetermined:
      // 2
      sessionQueue.suspend()
      AVCaptureDevice.requestAccess(for: .video) { authorized in
        // 3
        if !authorized {
          self.status = .unauthorized
          self.set(error: .deniedAuthorization)
        }
        self.sessionQueue.resume()
      }
    // 4
    case .restricted:
      status = .unauthorized
      set(error: .restrictedAuthorization)
    case .denied:
      status = .unauthorized
      set(error: .deniedAuthorization)
    // 5
    case .authorized:
      break
    // 6
    @unknown default:
      status = .unauthorized
      set(error: .unknownAuthorization)
    }
  }
  

  
  private func configureCaptureSession() {
    guard status == .unconfigured else {
      return
    }
    
    session.beginConfiguration()
    defer {
      session.commitConfiguration()
    }
    
    let device = AVCaptureDevice.default(
      .builtInWideAngleCamera,
      for: .video,
      position: .back)
      
//    DispatchQueue.main.async {
        self.cameraPostion = .back
//    }
    
    guard let camera = device else {
      set(error: .cameraUnavailable)
      status = .failed
      return
    }
    
    do {
        try camera.lockForConfiguration()
        defer {camera.unlockForConfiguration()}
              
//        camera.videoZoomFactor = camera.activeFormat.videoMaxZoomFactor
//        camera.ramp(toVideoZoomFactor: 16, withRate: 1)
        let cameraInput = try AVCaptureDeviceInput(device: camera)
        
        if session.canAddInput(cameraInput) {
            session.addInput(cameraInput)
        } else {
            set(error: .cannotAddInput)
            status = .failed
            return
        }
    } catch {
      set(error: .createCaptureInput(error))
      status = .failed
      return
    }
      
      // Add Output for captured Photos
      if session.canAddOutput(photoOutput) {
        session.addOutput(photoOutput)
        
        let photoConnection = photoOutput.connection(with: .video)
        
        photoConnection!.videoOrientation = .portrait
      
      } else {
        set(error: .cannotAddOutput)
        status = .failed
        return
      }
    
    if session.canAddOutput(videoOutput) {
      session.addOutput(videoOutput)
      videoOutput.videoSettings =
        [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
      let videoConnection = videoOutput.connection(with: .video)
      videoConnection?.videoOrientation = .portrait
    } else {
      set(error: .cannotAddOutput)
      status = .failed
      return
    }
      self.currentDevice = camera
    status = .configured
  }
  
  func switchCamera() {
      guard let currentCameraInput: AVCaptureInput = session.inputs.first else { return }
      guard let position = currentCameraInput.ports.first?.sourceDevicePosition else { return }
      var newPosition: AVCaptureDevice.Position
    
      if position.rawValue == 2 { //CURRENT POSTION = FRONT CAMERA
          newPosition = AVCaptureDevice.Position.back
      } else {// 0 or 1 = UNSPECIFIED RESP. BACK CAMERA
          newPosition = AVCaptureDevice.Position.front
      }
//      DispatchQueue.main.async {
          self.cameraPostion = newPosition
//      }
    
    session.beginConfiguration()
    defer {
      session.commitConfiguration()
    }
    
    session.removeInput(currentCameraInput)

    let device = AVCaptureDevice.default(
      .builtInWideAngleCamera,
      for: .video,
      position: newPosition
    )
    

    guard let camera = device else {
      set(error: .cameraUnavailable)
      status = .failed
      return
    }
    
    do {
      let cameraInput = try AVCaptureDeviceInput(device: camera)
      if session.canAddInput(cameraInput) {
        session.addInput(cameraInput)
      } else {
        set(error: .cannotAddInput)
        status = .failed
        return
      }
    } catch {
      set(error: .createCaptureInput(error))
      status = .failed
      return
    }
    
    
    let videoConnection = videoOutput.connection(with: .video)
    videoConnection?.videoOrientation = .portrait
    self.currentDevice = camera
    status = .configured
  }
  
//  func switchOrientation() {
//    print("HELLO")
//    session.beginConfiguration()
//    defer {
//      session.commitConfiguration()
//    }
//
//    let videoConnection = videoOutput.connection(with: .video)
//    if UIDevice.current.orientation.isLandscape {
//      print("landscapeleft")
//        videoConnection?.videoOrientation = .landscapeRight
//    } else {
//      print("portrait")
//      videoConnection?.videoOrientation = .portrait
//    }
//  }
    public func set(zoom: CGFloat){
        let factor = zoom < 1 ? 1 : zoom
        guard let camera = self.currentDevice else { return }
        do {
            try camera.lockForConfiguration()
            camera.videoZoomFactor = factor
            camera.unlockForConfiguration()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func toggleFlash() {
        self.flashMode = self.flashMode == .on ? .off : .on
    }
    
    
  func set(
    _ delegate: AVCaptureVideoDataOutputSampleBufferDelegate,
    queue: DispatchQueue
  ) {
    sessionQueue.async {
      self.videoOutput.setSampleBufferDelegate(delegate, queue: queue)
    }
  }
    
    func capturePhoto(
      with settings: AVCapturePhotoSettings,
      _ delegate: AVCapturePhotoCaptureDelegate
    ) {
      sessionQueue.async {
          guard let camera = self.currentDevice else {return}
          if camera.isFlashAvailable {
              settings.flashMode = self.flashMode
          }
        self.photoOutput.capturePhoto(with: settings, delegate: delegate)
      }
    }
}
