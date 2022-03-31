//
//  User.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 29/09/2021.
//

import Foundation
import Firebase

class User: ObservableObject {
    let ref = Database.database(url: "https://appx-38f9f-default-rtdb.europe-west1.firebasedatabase.app/").reference()

    @Published var uid: String = ""
    @Published var email: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    
    @Published var address: String = ""
    @Published var postalCode: String = ""
    @Published var addition: String = ""
    @Published var city: String = ""
    @Published var country: String = ""

    @Published var mollieID: String = ""
    @Published var orders: Array<Order> = []

    @Published var currentPhotoRoll: Int = 1
    @Published var photosInCurrentPhotoRoll: Int = 0
    @Published var currentPromotionPhotoRoll: Int = 1
    @Published var photosInCurrentPromotionPhotoRoll: Int = 0

    @Published var currentPromotion: String = ""
    @Published var hasActivePaymentMethod: String = "false"

    // NOT STORED IN USER PART OF DB BUT IN PROMOTION PART
    @Published var bannerURL: String = ""
    @Published var promotionCompany: String = ""
    @Published var frameURL: String = ""
    @Published var maxPhotosInCurrentPromotionPhotoRoll = 3
    // NOT STORED IN USER PART OF DB BUT IN PROMOTION PART ^

    // NOT STORED IN USER PART OF DB BUT IN GENERAL PART
    @Published var maxPhotosInNormalPhotoRoll = 10
    // NOT STORED IN USER PART OF DB BUT IN GENERAL PART ^

    
    // NOT STORED IN DB
    @Published var showPaymentSheet: Bool = false
    @Published var forcePayment: Bool = false
    @Published var showNewPhotoRollSheet: Bool = false
//    @Published var forceEmailVerification: Bool = false
    // NOT STORED IN DB ^


    public func setPromotion(couponCode: String) {
        self.ref.child("users/\(self.uid)").updateChildValues(["currentPromotion": couponCode])
    }
    
    public func endPromotion() {
        self.ref.child("users/\(self.uid)").updateChildValues(["currentPromotion": ""])
    }
    
    public func initializeDataBase(email: String, firstName: String, lastName: String) {
        self.ref.child("users/\(self.uid)").setValue(["firstName": firstName,
                                                      "email": email,
                                                      "lastName": lastName,
                                                      "address": "",
                                                      "postalCode": "",
                                                      "addition": "",
                                                      "city": "",
                                                      "country": "",
                                                      "currentPhotoRoll": 1,
                                                      "photosInCurrentPhotoRoll": 0,
                                                      "currentPromotionPhotoRoll": 1,
                                                      "photosInCurrentPromotionPhotoRoll": 0,
                                                      "currentPromotion": "",
                                                      "hasActivePaymentMethod": "false"
                                                     ])
    }


    public func fetchUserDataFromDatabase() {

        guard let FirUser = Auth.auth().currentUser  else { return }
        self.uid = FirUser.uid
        self.email = FirUser.email ?? ""
    
        let userInfoRef = self.ref.child("users/\(self.uid)")
        
        userInfoRef.observe(.value, with: { (snapshot) in
            guard let value = snapshot.value as? NSDictionary else { return }
            self.email = value["email"] as? String ?? ""
            self.firstName = value["firstName"] as? String ?? ""
            self.lastName = value["lastName"] as? String ?? ""
            self.address = value["address"] as? String ?? ""
            self.postalCode = value["postalCode"] as? String ?? ""
            self.addition = value["addition"] as? String ?? ""
            self.city = value["city"] as? String ?? ""
            self.country = value["country"] as? String ?? ""
            self.mollieID = value["mollieID"] as? String ?? ""
            self.orders = self.createOrderArray(orders: value["orders"] as? Dictionary ?? [:])
            self.hasActivePaymentMethod = value["hasActivePaymentMethod"] as? String ?? "false"
            self.currentPhotoRoll = value["currentPhotoRoll"] as? Int ?? 0
            self.photosInCurrentPhotoRoll = value["photosInCurrentPhotoRoll"] as? Int ?? 0
            self.currentPromotionPhotoRoll = value["currentPromotionPhotoRoll"] as? Int ?? 0
            self.photosInCurrentPromotionPhotoRoll = value["photosInCurrentPromotionPhotoRoll"] as? Int ?? 0
            self.currentPromotion = value["currentPromotion"] as? String ?? ""
            
            if self.currentPromotion != "" {
                let promotionRef = self.ref.child("promotions").child(self.currentPromotion)
                promotionRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let value = snapshot.value as? NSDictionary else { return }
                    self.bannerURL = value["bannerURL"] as? String ?? ""
                    self.frameURL = value["frameURL"] as? String ?? ""
                    self.promotionCompany = value["company"] as? String ?? ""
                    self.maxPhotosInCurrentPromotionPhotoRoll = value["nrOfPhotos"] as? Int ?? 0
                })
            } else {
                let generalInfoRef = self.ref.child("generalInfo")
                generalInfoRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let value = snapshot.value as? NSDictionary else { return }
                    self.maxPhotosInNormalPhotoRoll = value["maxPhotosInNormalPhotoRoll"] as? Int ?? 0
                    self.bannerURL = ""
                    self.frameURL = ""
                    self.promotionCompany = ""
                    self.currentPromotion = ""
                })
            }
//            if self.maxPhotosInCurrentPromotionPhotoRoll - self.photosInCurrentPromotionPhotoRoll == 1 || self.maxPhotosInNormalPhotoRoll - self.photosInCurrentPhotoRoll == 1 {
//                self.forceEmailVerification = true
//            }
            if self.hasActivePaymentMethod == "false" && self.currentPromotion == "" && self.maxPhotosInNormalPhotoRoll - self.photosInCurrentPhotoRoll == 1 {
                self.forcePayment = true
            }
            if self.hasActivePaymentMethod == "false" && self.currentPromotion == "" && self.maxPhotosInNormalPhotoRoll - self.photosInCurrentPhotoRoll <= 3 && self.forcePayment == false {
                self.showPaymentSheet = true
            }
            if self.hasActivePaymentMethod == "true" {
                self.showPaymentSheet = false
                self.forcePayment = false
            }
            
        })
    }
    
    private func createOrderArray(orders: Dictionary<AnyHashable, Any>) -> Array<Order> {
        var orderArray: Array<Order> = []
        for (key, value) in orders {
            let orderNumber = key as! String
            let valueDict = value as! NSDictionary
            let date = valueDict["date"] as! String
            let status = valueDict["status"] as! String
            let amount = valueDict["amount"] as! String
            let discount = valueDict["discount"] as! String
            let amountAfterDiscount = valueDict["amountAfterDiscount"] as! String

            let newOrder = Order(orderNumber: orderNumber, date: date, status: status, amount: amount, discount: discount, amountAfterDiscount: amountAfterDiscount)
            orderArray.append(newOrder)
        }
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        let sortedOrderArray = orderArray.sorted {df.date(from: $0.date)! > df.date(from: $1.date)!}
        return sortedOrderArray
    }
    
    public func updatePhotoRollStatus() {
        if self.currentPromotion == "" {
            let newRollValues = ["currentPhotoRoll": ServerValue.increment(1), "photosInCurrentPhotoRoll": 0] as [String : Any]
            let newPhotoValues = ["photosInCurrentPhotoRoll": ServerValue.increment(1)]
            
            if self.photosInCurrentPhotoRoll == maxPhotosInNormalPhotoRoll - 1 {
                self.showNewPhotoRollSheet = true
                self.ref.child("users/\(self.uid)").updateChildValues(newRollValues)
                self.endPromotion()
            } else {
                self.ref.child("users/\(self.uid)").updateChildValues(newPhotoValues)
            }
            
        } else {
            let newRollValues = ["currentPromotionPhotoRoll": ServerValue.increment(1), "photosInCurrentPromotionPhotoRoll": 0] as [String : Any]
            let newPhotoValues = ["photosInCurrentPromotionPhotoRoll": ServerValue.increment(1)]
            
            if self.photosInCurrentPromotionPhotoRoll == maxPhotosInCurrentPromotionPhotoRoll - 1 {
                self.showNewPhotoRollSheet = true
                self.ref.child("users/\(self.uid)").updateChildValues(newRollValues)
            } else {
                self.ref.child("users/\(self.uid)").updateChildValues(newPhotoValues)
            }
        }
        

    }
        
//        if self.currentPromotion == "" {
//            if self.photosInCurrentPhotoRoll == maxPhotosInCurrentPhotoRoll - 1 {
//                self.showNewPhotoRollSheet = true
//                self.ref.child("users/\(self.uid)").updateChildValues(["currentPhotoRoll": ServerValue.increment(1), "photosInCurrentPhotoRoll": 0] as [String : Any])
//            } else {
//                self.ref.child("users/\(self.uid)").updateChildValues(["photosInCurrentPhotoRoll": ServerValue.increment(1)])
//            }
//        } else {
//            if self.photosInCurrentPhotoRoll == maxPhotosInCurrentPhotoRoll - 1 {
//                self.showNewPhotoRollSheet = true
//                self.ref.child("users/\(self.uid)").updateChildValues(["currentPromotionPhotoRoll": ServerValue.increment(1), "photosInCurrentPromotionPhotoRoll": 0] as [String : Any])
//                self.endPromotion()
//            } else {
//                self.ref.child("users/\(self.uid)").updateChildValues(["photosInCurrentPromotionPhotoRoll": ServerValue.increment(1)])
//            }
//        }
//    }
    
    
    public func updateAddres(address: String, postalCode: String, addition: String, city: String, country: String) {
        self.ref.child("users/\(self.uid)").updateChildValues(["address": address,
                                                     "postalCode": postalCode,
                                                     "addition": addition,
                                                     "city": city,
                                                     "country": country])
    }
    
    public func updateName(firstName: String, lastName: String) {

        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = firstName
        changeRequest?.commitChanges { error in
            if error != nil {
                print("display name update failed")
            }
        }
        if firstName != "" {
            self.ref.child("users/\(self.uid)/firstName").setValue(firstName)
        }
        if lastName != "" {
            self.ref.child("users/\(self.uid)/lastName").setValue(lastName)
        }
    }
    
    public func updateEmail(email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().currentUser?.updateEmail(to: email) { error in
            if error != nil {
                print(error as Any)
                completion(error)
            } else {
//                completion("succes")
                self.ref.child("users/\(self.uid)/email").setValue(email)
            }
        }
    }
    
    public func sendEmailVerification() {
        Auth.auth().currentUser?.sendEmailVerification { error in
            if error != nil {
                print(error)
                print("email verification failed")
            }
        }
    }
}
