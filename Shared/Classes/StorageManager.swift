//
//  StorageManager.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 27/09/2021.
//

import SwiftUI
import Firebase


class StorageManager: ObservableObject {
    let storageRef = Storage.storage().reference()
    let formatter = DateFormatter()

    func upload(image: UIImage, inPhotoRoll photoRollNr: Int) {
        formatter.timeZone = TimeZone(identifier: "CET")
        formatter.dateFormat = "dd-MM-yyyy-HH:mm:ss"

        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Failed to retrieve current user ID")
            return

        }
        
        
        let storageRef = storageRef.child(currentUserID)
        let dateString = formatter.string(from: Date())
        let imageRef = storageRef.child("photoRoll\(photoRollNr)/\(dateString)")
        
        // Convert the image into JPEG and compress the quality to reduce its size
        let data = image.jpegData(compressionQuality: 1)
        
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
