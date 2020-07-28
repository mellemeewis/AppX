//
//  ViewRouter.swift
//  AppX
//
//  Created by Melle Meewis on 03/07/2020.
//  Copyright © 2020 Melle Meewis. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ViewRouter: ObservableObject {
    
    let objectWillChange = PassthroughSubject<ViewRouter,Never>()
    
    var userLoggedIn: Bool = false {
        didSet {
            withAnimation() {
                objectWillChange.send(self)
            }
        }
    }
}
