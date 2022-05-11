//
//  FrameView.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 05/05/2022.
//

import SwiftUI

struct FrameView: View {
  var image: CGImage?
  @Binding var orientation: UIDeviceOrientation
  @ObservedObject var model: CameraViewModel2
  private let label = Text("Camera feed")
  @State var currentZoomFactor: CGFloat = 1.0

  
  var body: some View {
    
    ZStack {
        if let image = image {
          GeometryReader { geometry in
              Image(image, scale: 1.0, orientation: self.model.cameraPostion == .back ? .up : .upMirrored, label: label)
              .resizable()
              .scaledToFill()
////              .frame(
////                width: geometry.size.width,
////                height: geometry.size.width,
////                alignment: .center)
////              .clipped()
////              .position(x:UIScreen.main.bounds.width/2, y:UIScreen.main.bounds.height/2.5)
//
              .frame(
                width: UIScreen.main.bounds.width,
                height: self.orientation == .landscapeLeft ? UIScreen.main.bounds.width * 1.111 : UIScreen.main.bounds.width * 0.9,
                alignment: .center)
              .animation(.linear(duration: 10))
              .clipped()
              .position(x:UIScreen.main.bounds.width/2, y:UIScreen.main.bounds.height/2.5)
              .gesture(
                DragGesture().onChanged({ (val) in
                    if orientation == .portrait {
                        if abs(val.translation.height) > abs(val.translation.width) {
                            let percentage: CGFloat = (-val.translation.height / geometry.size.height)
                            let calc = currentZoomFactor + percentage
                            let zoomFactor: CGFloat = min(max(calc, 1), 5)
                            currentZoomFactor = zoomFactor
                            model.zoom(with: zoomFactor)
                        }
                    }
                    else {
                        if abs(val.translation.width) > abs(val.translation.height) {
                            let percentage: CGFloat = (val.translation.width / geometry.size.width)
                            let calc = currentZoomFactor + percentage
                            let zoomFactor: CGFloat = min(max(calc, 1), 5)
                            currentZoomFactor = zoomFactor
                            model.zoom(with: zoomFactor)
                        }
                    }
                })
            )
          }
        } else {
          // 4
          Color.black
        }
//      }
      
//      Button(action: {
//        imageToSave = self.image
//        showCapturedImage = true
//      }) {
//        Text("Capture")
//      }
//
//      Button(action: {
//        print("FLIP")
//      }) {
//        Text("FLip")
//      }
    }
  }
}

//struct FrameView_Previews: PreviewProvider {
//    static var previews: some View {
//      FrameView( showCapturedImage: false)
//    }
//}
