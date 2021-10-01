//
//  StorageManager.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 27/09/2021.
//

import SwiftUI
import Firebase


class StorageManager: ObservableObject {
    let storage = Storage.storage()
    
    func upload(image: UIImage) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Failed to retrieve current user ID")
            return

        }
       
        let storageRef = storage.reference().child("images/\(currentUserID)/image.jpg")

        // Convert the image into JPEG and compress the quality to reduce its size
        let data = image.jpegData(compressionQuality: 1)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        if let data = data {
                storageRef.putData(data, metadata: metadata) { (metadata, error) in
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
