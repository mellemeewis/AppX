//
//  PaymentService.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 07/11/2021.
//

import Foundation
import Firebase
import SwiftUI

class PaymentService: ObservableObject {
//    lazy var functions = Functions.functions()
    @Published var mandateStatus: String = ""
    @Published var paymentMethod: String = ""
    @Published var accountNumber: String = ""
    @Published var name: String = ""
    @Published var customerID: String = ""
    @Published var mandateID: String = ""
    

    func createCustomer(firstName: String, lastName: String) {
        let customerInfo = ["firstName": firstName, "lastName": lastName]
        Functions.functions().httpsCallable("createCustomer").call(customerInfo) { result, error in
            if let error = error as NSError? {
                print(error)
            }
        }
    }

    func createFirstOrder(user: User, completion: @escaping (Bool) -> Void) {
        let orderInfo = ["customerID": user.mollieID]
        Functions.functions().httpsCallable("createFirstOrder").call(orderInfo) { result, error in
            if let error = error as NSError? {
                print(error)
                if error.domain == FunctionsErrorDomain {
                    let message = error.localizedDescription
                    print(message)
                }
            }
            if let data = result?.data as? [String: Any] {
                let checkoutURL = data["checkoutURL"] as! String
                UIApplication.shared.open(NSURL(string: checkoutURL)! as URL)
            }
            completion(true)
        }
    }
    
    func listMandates(user: User, completion: @escaping (Bool) -> Void) {
        let listMandateInfo = ["customerID": user.mollieID]
        Functions.functions().httpsCallable("listMandates").call(listMandateInfo) { result, error in
            print("LISTING")
            if let error = error as NSError? {
                print(error)
                if error.domain == FunctionsErrorDomain {
                    let message = error.localizedDescription
                    print(message)
                }
                completion(false)
            }
            if let data = result?.data as? [String: Any] {
                guard let method = data["method"] as? String else  {completion(false); return}
                guard let customerID = data["customerId"] as? String, let mandateID = data["id"] as? String else {completion(false); return}
                guard let details = data["details"] as? [String: String], let mandateStatus = data["status"] as? String else {completion(false); return}

                if method == "directdebit" || method == "paypal" {
                    guard let accountNumber = details["consumerAccount"], let name = details["consumerName"] else {completion(false); return}
                    self.accountNumber = accountNumber
                    self.name = name
                } else {
                    guard let accountNumber = details["cardNumber"], let name = details["cardHolder"] else {completion(false); return}
                    self.accountNumber = accountNumber
                    self.name = name
                }
                self.paymentMethod = method
                self.mandateStatus = mandateStatus
                self.customerID = customerID
                self.mandateID = mandateID
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func getOrder(user: User, completion: @escaping (Bool) -> Void) {
        
    }

    func deletePaymentMethod(completion: @escaping (Bool) -> Void) {
        let mandateInfo = ["mandateID": self.mandateID, "customerID": self.customerID]
        Functions.functions().httpsCallable("deleteMandate").call(mandateInfo) { result, error in
            if let error = error as NSError? {
                print(error)
            } else {
                self.resetInformation()
            }
            completion(true)
        }
    }
    
    func resetInformation() {
        self.mandateStatus = ""
        self.paymentMethod = ""
        self.accountNumber = ""
        self.name = ""
        self.customerID = ""
        self.mandateID = ""
    }
}

