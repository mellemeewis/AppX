//
//  OrdersView.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 10/11/2021.
//

import SwiftUI

struct OrdersView: View {
    @ObservedObject var currentUser: User
    @ObservedObject var paymentService: PaymentService
    
    var body: some View {
            Form {
                Section(header: Text("Orders")) {
                    ForEach(self.currentUser.orders, id: \.orderNumber)  { order in
                    HStack {
                        Image(systemName: "envelope")
                        Spacer()
                        VStack {
                            Text("Order #:  \(order.orderNumber)\nDate: \(order.date)")
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()
                        Spacer()
                        if order.status == "created"  {
                            Text("€ \(order.amount)\nPending")
                                .bold()
                                .foregroundColor(.orange)
                                .multilineTextAlignment(.leading)
                        } else if order.status == "paid" || order.status == "shipping" || order.status == "completed" {
                            Text("€ \(order.amount)\nPaid")
                                .bold()
                                .foregroundColor(.green)
                                .multilineTextAlignment(.leading)
                        } else if order.status == "authorized" {
                            Text("€ \(order.amount)\nAuthorized")
                                .bold()
                                .foregroundColor(.green)
                                .multilineTextAlignment(.leading)
                        } else {
                            Text("€ \(order.amount)\nCanceled")
                                .bold()
                                .foregroundColor(.red)
                                .multilineTextAlignment(.leading)
                        }
                    }.padding()
                }
            }
        }
    }
}

//struct OrdersView_Previews: PreviewProvider {
//    static var previews: some View {
//        OrdersView()
//    }
//}
