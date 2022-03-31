//
//  ImageResizer.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 17/09/2021.
//

import Foundation
import UIKit

enum ImageResizingError: Error {
    case cannotRetrieveFromURL
    case cannotRetrieveFromData
}

public struct ImageResizer {
    
    public func resize(image: UIImage, orientation: UIDeviceOrientation, isFrontCamera: Bool) -> UIImage {
        let width = image.size.width
        let height = orientation.rawValue == 3 ? image.size.width * 1.1111 : image.size.width * 0.9

        let xOffset =  orientation.rawValue == 3 ?  UIScreen.main.bounds.width : UIScreen.main.bounds.width * 1.7333
        print(xOffset)
        // IN PORTRait X OFSET DECIDES HEIGHT, Y OFFSET WIDTH
        let yOffset = 0.0
        
        let cropRect = CGRect(x: xOffset, y: yOffset, width: height, height: width).integral
        var croppedCIImage: CIImage
        if isFrontCamera && orientation.rawValue == 3 {
            croppedCIImage = CIImage(cgImage: image.cgImage!).cropped(to: cropRect).oriented(.left).applyingFilter("CIPhotoEffectTransfer")
        } else {
            croppedCIImage = CIImage(cgImage: image.cgImage!).cropped(to: cropRect).oriented(.right).applyingFilter("CIPhotoEffectTransfer")
        }
        
        
        let uiImage = UIImage(ciImage: croppedCIImage)
        return uiImage
//        let targetSize = CGSize(width: (uiImage.size.width/2), height: (uiImage.size.height/2))
//        let renderer = UIGraphicsImageRenderer(size: targetSize)
//        let returnImage = renderer.image { (context) in
//            image.draw(in: CGRect(origin: .zero, size: targetSize))
//        }
         
//        let ciImage = CIImage(cgImage: returnImage.cgImage!)
//        return UIImage(ciImage: ciImage)
        

//        return uiImage

    }
    
    public func resize(data: Data, orientation: UIDeviceOrientation, isFrontCamera: Bool) -> UIImage? {
        guard let image = UIImage(data: data) else {return nil}
        return resize(image: image, orientation: orientation, isFrontCamera: isFrontCamera)
    }
}

struct MemorySizer {
    static func size(of data: Data) -> String {
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
        bcf.countStyle = .file
        let string = bcf.string(fromByteCount: Int64(data.count))
        return string
    }
}
