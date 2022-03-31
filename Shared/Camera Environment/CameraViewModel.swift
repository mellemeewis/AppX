//
//  CameraViewModel.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 17/09/2021.
//

import SwiftUI
import Combine
import AVFoundation

final class CameraViewModel: ObservableObject {
    public let service = CameraService()
    
    @Published var photo: Photo!
    
    @Published var showAlertError = false
    @Published var showImage = false
    @Published var isFlashOn = false
    @Published var showSpinner = false

    var alertError: AlertError!
    
    var session: AVCaptureSession
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        self.session = service.session
        
        service.$photo.sink { [weak self] (photo) in
            guard let pic = photo else { return }
            self?.photo = pic
        }
        .store(in: &self.subscriptions)
        
        service.$shouldShowAlertView.sink { [weak self] (val) in
            self?.alertError = self?.service.alertError
            self?.showAlertError = val
        }
        .store(in: &self.subscriptions)
        
        service.$flashMode.sink { [weak self] (mode) in
            self?.isFlashOn = mode == .on
        }
        .store(in: &self.subscriptions)
        
        service.$shouldShowImageView.sink { [weak self] (val) in
            self?.showImage = val
        }
        .store(in: &self.subscriptions)
        
        service.$shouldShowSpinner.sink { [weak self] (val) in
            self?.showSpinner = val
        }
        .store(in: &self.subscriptions)
    }
    
    func configure() {
        service.checkForPermissions()
        service.configure()
    }
    
    func capturePhoto(orientation: UIDeviceOrientation, isFrontCamera: Bool) {
        service.capturePhoto(orientation: orientation, isFrontCamera: isFrontCamera)
    }
    
    func flipCamera() {
        service.changeCamera()
    }
    
    func zoom(with factor: CGFloat) {
        service.set(zoom: factor)
    }
    
    func switchFlash() {
        service.flashMode = service.flashMode == .on ? .off : .on
    }
}
