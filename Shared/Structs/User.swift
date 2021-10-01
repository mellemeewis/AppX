//
//  User.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 29/09/2021.
//

import Foundation
import Firebase

class User: ObservableObject {
    @Published var uid: String = ""
    @Published var email: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var street: String = "Street"
    @Published var ZIP: String = "XXXX12"
    @Published var houseNumber: String = "1"
    @Published var city: String = "Amsterdam"



    public func updateAll() {
        guard let FirUser = Auth.auth().currentUser  else { return }
        self.uid = FirUser.uid
        self.email = FirUser.email ?? ""
        self.firstName = FirUser.displayName ?? ""
        self.lastName = FirUser.displayName ?? ""
    }
    
    public func updateName(firstName: String, lastName: String) {
        // To DO USE FIRBASE DB AND ACTUALLY UPDATE DETILS
        self.firstName = firstName
        self.lastName = lastName
    }
    public func updateEmail(email: String) {
        // To DO USE FIRBASE DB AND ACTUALLY UPDATE DETILS
        self.email = email
    }
}
