//
//  StorageManager.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 27/09/2021.
//

import SwiftUI
import Firebase
import AVFoundation


class StorageManager: ObservableObject {
    let storageRef = Storage.storage().reference()
    let formatter = DateFormatter()

    func upload(image: UIImage, user : User, cameraPosition: AVCaptureDevice.Position) {
        
        let cgImage = image.cgImage

        var result: UIImage
        if image.size.height > image.size.width {
            if cameraPosition == .front {
                result = UIImage(cgImage: cgImage!, scale: image.scale/10, orientation: UIImage.Orientation.down)
            } else {
                result = UIImage(cgImage: cgImage!, scale: image.scale/10, orientation: UIImage.Orientation.up)
            }
        } else {
            result = UIImage(cgImage: cgImage!, scale: image.scale/10, orientation: image.imageOrientation)
        }
        formatter.timeZone = TimeZone(identifier: "CET")
        formatter.dateFormat = "dd-MM-yyyy-HH:mm:ss"

        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Failed to retrieve current user ID")
            return
        }
        
        
        let storageRef = storageRef.child("users").child(currentUserID)
        let dateString = formatter.string(from: Date())
        
        var imageRef: StorageReference!
        if user.currentPromotion == "" {
            imageRef = storageRef.child("photoRoll\(user.currentPhotoRoll)/\(dateString)")
        } else {
            imageRef = storageRef.child("promotionPhotoRolls/promotionPhotoRoll\(user.currentPromotionPhotoRoll)_\(user.promotionCompany)/\(dateString)_\(user.promotionCompany)")
        }
        
        // Convert the image into JPEG and compress the quality to reduce its size
        let data = result.jpegData(compressionQuality: 0.1)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        if let data = data {
            imageRef.putData(data, metadata: metadata) { (metadata, error) in
                        if let error = error {
                                print("Error while uploading file: ", error)
                        }

                        if let metadata = metadata {
                                print("Metadata: ", metadata)
                        }
                }
        }
    }

}
