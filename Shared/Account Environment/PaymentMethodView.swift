//
//  PaymentMethodView.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 08/11/2021.
//

import SwiftUI

struct PaymentMethodView: View {
    @ObservedObject var currentUser: User
    @ObservedObject var paymentService: PaymentService
    @State var mandateStatus: String = "unchecked"
    @State var paymentMethod: String = ""
    @State var accountNumber: String = ""
    @State var name: String = ""
    @State var busy: Bool = false

    var body: some View {
        ZStack {
            if mandateStatus == "unchecked" {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
            } else if mandateStatus == "valid" {
                Form {
                    HStack {
                        Image(systemName: "person")
                        Spacer()
                        Text(self.name)
                    }
                    HStack {
                        Image(systemName: "creditcard")
                        Spacer()
                        Text(paymentMethod == "creditcard" ? "**** **** **** \(self.accountNumber)" : self.accountNumber)
                    }
                    Button(action: { busy = true
                        paymentService.deletePaymentMethod(completion: { done in
                            if done {
                                busy = false
                                self.fetchMandate()
                            }
                        })
                        
                    }) {
                        Text("Delete method")
                            .fontWeight(.bold)
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .background(Color("ButtonColor"))
                            .cornerRadius(20)
                    }.padding()
                        .disabled(busy==true)

                }
            } else {
                Form {
                    HStack {
                        Image(systemName: "creditcard")
                        Spacer()
                        Text("No method added yet")
                    }
                    Button(action: { busy = true
                        self.paymentService.createFirstOrder(user: self.currentUser, completion: { done in
                            if done {
                                busy = false
                                self.fetchMandate()
                            }
                        })
                    }) {
                            Text("Add payment method")
                                .fontWeight(.bold)
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(maxWidth: .infinity)
                                .background(Color("ButtonColor"))
                                .cornerRadius(20)
                        }.padding()
                        .disabled(busy==true)
                }
            }
            if busy {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
            }
        }
        .onAppear(perform: { self.fetchMandate() })
        .onOpenURL { (url) in
            self.fetchMandate()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            print("FOREGROUND")
            self.fetchMandate()
        }
    }
    
    func fetchMandate() {
        self.mandateStatus = "unchecked"
        busy = false
        paymentService.listMandates(user: self.currentUser, completion: { succes in
            if succes == false {
                self.mandateStatus = "NO"
            }
            if self.paymentService.mandateStatus == "valid" {
                self.mandateStatus = self.paymentService.mandateStatus
                self.paymentMethod = paymentService.paymentMethod
                self.accountNumber = paymentService.accountNumber
                self.name = paymentService.name
            }
        })
    }
}

//struct PaymentMethodView_Previews: PreviewProvider {
//    static var previews: some View {
//        PaymentMethodView()
//    }
//}
