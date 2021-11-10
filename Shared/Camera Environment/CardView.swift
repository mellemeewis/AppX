//
//  CardView.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 26/10/2021.
//

import SwiftUI

struct CardView: View {

    @GestureState var translation: CGSize = .zero
    @GestureState var degrees: Double = 0

    let proxy: GeometryProxy
    let image: UIImage

    var body: some View {
        let dragGesture = DragGesture()
            .updating($translation) { (value, state, _) in
                            // 3
                            state = value.translation
                        }
            .updating($degrees) { (value, state, _) in
                       // 3
                      state = value.translation.width > 0 ? 2 : -2
                   }
        // 3
        Rectangle()
            // 4
            .cornerRadius(10)
            // 5
            .frame(
                maxWidth: proxy.size.width - 28,
                maxHeight: proxy.size.height * 0.8
            )
            // 6
            .position(
                x: proxy.frame(in: .global).midX,
                y: proxy.frame(in: .local).midY - 30
            )
            .overlay(
                  GeometryReader { proxy in
                      // 2
                      ZStack {
                         // 3
                        Image(uiImage: image)
                              .resizable()
                              .scaledToFit()
                              .aspectRatio(contentMode: .fit)
                              .clipped()
                          // 4
                          VStack(alignment: .leading) {
                              // 5
                              Text("Gary")
                                  .foregroundColor(.white)
                                  .fontWeight(.bold)
                              Text("iOS Dev")
                                  .foregroundColor(.white)
                                  .fontWeight(.bold)
                          }
                          // 6
                          .position(
                              x: proxy.frame(in: .local).minX + 75,
                              y: proxy.frame(in: .local).maxY - 50
                          )
                      }
                  }
              )
            .offset(x: translation.width, y: 0)
            .gesture(dragGesture)
            .animation(.interactiveSpring())
            .rotationEffect(.degrees(degrees))
        
    }
}
//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        // 2
//        GeometryReader { proxy in
//            CardView(proxy: proxy)
//        }
//    }
//}
