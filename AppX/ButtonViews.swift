//
//  ButtonViews.swift
//  AppX
//
//  Created by Melle Meewis on 03/07/2020.
//  Copyright © 2020 Melle Meewis. All rights reserved.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    var body: some View {
        Text(title.uppercased())
        .fontWeight(.bold)
        .foregroundColor(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.accentColor)
        .cornerRadius(5)
        .shadow(color: Color.gray, radius: 15, x: 0, y: 5)
 }
}

struct SecondaryButton: View {
 let title: String
 var body: some View {
   Text(title.uppercased())
     .fontWeight(.bold)
     .foregroundColor(.accentColor)
     .padding()
     .frame(maxWidth: .infinity)
     .background(Color.white)
     .cornerRadius(5)
    .shadow(color: Color.gray, radius: 15, x: 0, y: 5)
 }
}


struct ButtonViews_Previews: PreviewProvider {
    static var previews: some View {
        SecondaryButton(title: "A")
    }
}
