//
//  Order.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 18/11/2021.
//

import Foundation

struct Order : Identifiable, Hashable {
    let id = UUID()
    public var orderNumber: String
    public var date: String
    public var status: String
    public var amount: String
    public var discount: String
    public var amountAfterDiscount: String
}
