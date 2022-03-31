//
//  AddressView.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 05/10/2021.
//

import SwiftUI
import MapKit
//
//struct AddressViewAccountEnvironment: View {
//    @ObservedObject var currentUser: User
//
//    @Environment(\.presentationMode) var presentationMode
//    @StateObject var locationService = LocationService()
//    @State private var addresItem: MKMapItem?
//
//    @State private var address = ""
//    @State private var addition = ""
//    @State private var postalCode = ""
//    @State private var city = ""
//    @State private var country = ""
//
//    var body: some View {
//        ScrollViewReader { proxy in
//
//            VStack {
//                Form {
//                    Section(header: Text("Enter manually")) {
//                        VStack {
//                            TextField("Address", text: $address).disableAutocorrection(true)
//                            TextField("Additional information", text: $addition).disableAutocorrection(true)
//                            TextField("Postal code", text: $postalCode).disableAutocorrection(true)
//                            TextField("City", text: $city).disableAutocorrection(true)
//                            TextField("Country", text: $country).disableAutocorrection(true)
//                        }
//                    }
//
//                    Section(header: Text("Or search new location")) {
//                        ZStack(alignment: .trailing) {
//                            TextField("Street + nr + addition", text: $locationService.queryFragment).onTapGesture(perform: { proxy.scrollTo(0, anchor: .top)})
//                            // This is optional and simply displays an icon during an active search
//                            if locationService.status == .isSearching {
//                                Image(systemName: "clock")
//                                    .foregroundColor(Color.gray)
//                            }
//                        }
//
////                        List {
////                            switch locationService.status {
////                            case .noResults:
////                                AnyView(Text("No Results"))
////                            case .error(let description):
////                                AnyView(Text("Error: \(description)"))
////                            default:
////                                AnyView(EmptyView())
////                            }
////
////                            ForEach(locationService.searchResults, id: \.self) { completionResult in
////
////                                Button(action: {
////                                    locationService.performMKLocalSearch(completionResult: completionResult) { succes in
////                                        if succes == true {
////                                            self.address = (locationService.addresItem?.placemark.name)!
////                                            self.postalCode = (locationService.addresItem?.placemark.postalCode)!
////                                            self.city = (locationService.addresItem?.placemark.locality)!
////                                            self.country = (locationService.addresItem?.placemark.country)!
////                                        }
////                                        locationService.resetSearchResults()
////                                        hideKeyboard()
////                                    }
////
////                                }) {
////                                    Text(completionResult.title)
////                                    Text(completionResult.subtitle)
////                                }
////                            }
////                        }
//                    }
//
//                    Button(action: {
//                        currentUser.updateAddres(address: self.address, postalCode: self.postalCode, addition: self.addition, city: self.city, country: self.country)
//                        self.presentationMode.wrappedValue.dismiss()
//
//                    }) {
//                        Text("Confirm")
//                            .fontWeight(.bold)
//                            .font(.title)
//                            .foregroundColor(.white)
//                            .padding(.vertical)
//                            .frame(maxWidth: .infinity)
//                            .background(Color("ButtonColor"))
//                            .cornerRadius(20)
//                    }
//                }
//            }.onAppear( perform: {
//                self.address = currentUser.address
//                self.addition = addition
//                self.postalCode = currentUser.postalCode
//                self.city = currentUser.city
//                self.country = currentUser.country
//            })
//        }
//    }
//}


import SwiftUI
import MapKit
struct AddressViewAccountEnvironment: View {
    @ObservedObject var currentUser: User
    @StateObject var locationService = LocationService()
    @State private var addresItem: MKMapItem?
    @Environment(\.presentationMode) var presentationMode

    @State private var address = ""
    @State private var street = ""
    @State private var number = ""
    @State private var addition = ""
    @State private var postalCode = ""
    @State private var city = ""
    @State private var country = ""

    @State private var autoFillPerformed: Bool = false
    
    var body: some View {
        ZStack {
//            Color("BackgroundColor").ignoresSafeArea()
            VStack {
                Text("Please fill in your address so we know where to send your photographs!")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
//                HStack {
                TextField("Street", text: $street)
                    .padding(10)
                    .font(.system(size: 20))
                    .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.2))
                    .disableAutocorrection(true)
                    .onChange(of: street) { _ in  self.completeAddress() }
                TextField("Number + addition", text: $number)
                    .padding(10)
                    .font(.system(size: 20))
                    .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.2))
                    .disableAutocorrection(true)
                    .onChange(of: number) { _ in  self.completeAddress() }
//                }
                TextField("Additional information", text: $addition).disableAutocorrection(true)
                    .padding(10)
                    .font(.system(size: 20))
                    .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(autoFillPerformed ? 0.2 : 0.5))
                    .disabled(autoFillPerformed ? false : true)

                TextField("Postal code", text: $postalCode).disableAutocorrection(true)
                    .padding(10)
                    .font(.system(size: 20))
                    .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.2))
                    .onChange(of: postalCode) { _ in  self.completeAddress() }
                TextField("City", text: $city).disableAutocorrection(true)
                    .disabled(autoFillPerformed ? false : true)
                    .padding(10)
                    .font(.system(size: 20))
                    .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(autoFillPerformed ? 0.2 : 0.5))
                TextField("Country", text: $country).disableAutocorrection(true)
                    .disabled(autoFillPerformed ? false : true)
                    .padding(10)
                    .font(.system(size: 20))
                    .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(autoFillPerformed ? 0.2 : 0.5))
                

                Button(action: {
                    currentUser.updateAddres(address: self.address, postalCode: self.postalCode, addition: self.addition, city: self.city, country: self.country)
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Confirm")
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(Color("ButtonColor"))
                        .cornerRadius(20)
                        .padding(.vertical)

                }
            }.padding()
        }
    }
    
    func completeAddress() {
        guard self.autoFillPerformed == false else { return }
        guard self.street != "" else { return }
        guard self.number != "" else { return }
        if self.postalCode.contains(" ") {
            guard self.postalCode.count == 7 else { return }
        } else {
            guard self.postalCode.count == 6 else { return }
        }
    
        locationService.performMKLocalSearch(query: "\(self.street) \(self.number), \(self.postalCode)") { succes in
            if succes == true {
                self.address = (locationService.addresItem?.placemark.name)!
                self.postalCode = (locationService.addresItem?.placemark.postalCode)!
                self.city = (locationService.addresItem?.placemark.locality)!
                self.country = (locationService.addresItem?.placemark.country)!
            }
//            locationService.resetSearchResults()
            hideKeyboard()
            self.autoFillPerformed = true
        }
    }
}
//struct AddressViewAccountEnvironment_Previews: PreviewProvider {
//    static var previews: some View {
//        AddressViewAccountEnvironment(currentUser: User(), locationService: LocationService())
//    }
//}
