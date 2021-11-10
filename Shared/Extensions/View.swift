//
//  View.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 04/11/2021.
//

import Foundation
import SwiftUI

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
