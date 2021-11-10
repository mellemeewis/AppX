//
//  AddressView.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 05/10/2021.
//

import SwiftUI
import MapKit

struct AddressViewAccountEnvironment: View {
    @ObservedObject var currentUser: User
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var locationService = LocationService()
    @State private var addresItem: MKMapItem?

    @State private var address = ""
    @State private var addition = ""
    @State private var postalCode = ""
    @State private var city = ""
    @State private var country = ""

    var body: some View {
        ScrollViewReader { proxy in

            VStack {
                Form {
                    Section(header: Text("Enter manually")) {
                        VStack {
                            TextField("Address", text: $address).disableAutocorrection(true)
                            TextField("Additional information", text: $addition).disableAutocorrection(true)
                            TextField("Postal code", text: $postalCode).disableAutocorrection(true)
                            TextField("City", text: $city).disableAutocorrection(true)
                            TextField("Country", text: $country).disableAutocorrection(true)
                        }
                    }
            
                    Section(header: Text("Or search new location")) {
                        ZStack(alignment: .trailing) {
                            TextField("Street + nr + addition", text: $locationService.queryFragment).onTapGesture(perform: { proxy.scrollTo(0, anchor: .top)})
                            // This is optional and simply displays an icon during an active search
                            if locationService.status == .isSearching {
                                Image(systemName: "clock")
                                    .foregroundColor(Color.gray)
                            }
                        }
                    
                        List {
                            switch locationService.status {
                            case .noResults:
                                AnyView(Text("No Results"))
                            case .error(let description):
                                AnyView(Text("Error: \(description)"))
                            default:
                                AnyView(EmptyView())
                            }

                            ForEach(locationService.searchResults, id: \.self) { completionResult in
                                
                                Button(action: {
                                    locationService.performMKLocalSearch(completionResult: completionResult) { succes in
                                        if succes == true {
                                            self.address = (locationService.addresItem?.placemark.name)!
                                            self.postalCode = (locationService.addresItem?.placemark.postalCode)!
                                            self.city = (locationService.addresItem?.placemark.locality)!
                                            self.country = (locationService.addresItem?.placemark.country)!
                                        }
                                        locationService.resetSearchResults()
                                        hideKeyboard()
                                    }
                                    
                                }) {
                                    Text(completionResult.title)
                                    Text(completionResult.subtitle)
                                }
                            }
                        }
                    }

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
                            .background(Color("ButtonsColor"))
                            .cornerRadius(20)
                    }
                }
            }.onAppear( perform: {
                self.address = currentUser.address
                self.addition = addition
                self.postalCode = currentUser.postalCode
                self.city = currentUser.city
                self.country = currentUser.country
            })
        }
    }
}

//struct AddressViewAccountEnvironment_Previews: PreviewProvider {
//    static var previews: some View {
//        AddressViewAccountEnvironment(currentUser: User(), locationService: LocationService())
//    }
//}
