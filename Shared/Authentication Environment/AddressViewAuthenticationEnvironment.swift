//
//  AddressViewAuthenticationEnvironment.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 06/10/2021.
//

import SwiftUI
import MapKit
struct AddressViewAuthenticationEnvironment: View {
    @ObservedObject var currentUser: User
    @Binding var userSignedIn: Bool
    @StateObject var locationService = LocationService()
    @State private var addresItem: MKMapItem?
    @State var showWelcomeToAppXView: Bool = false

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
            Color("BackgroundColor").ignoresSafeArea()
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
                
                NavigationLink(destination: WelcomeToAppxView(userSignedIn: $userSignedIn, currentUser: self.currentUser).navigationBarBackButtonHidden(true), isActive: $showWelcomeToAppXView) { EmptyView() }

                Button(action: {
                    currentUser.updateAddres(address: self.address, postalCode: self.postalCode, addition: self.addition, city: self.city, country: self.country)
                    self.showWelcomeToAppXView.toggle()
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



struct AddressViewAuthenticationEnvironment_Previews: PreviewProvider {
    static var previews: some View {
        AddressViewAuthenticationEnvironment(currentUser: User(), userSignedIn: .constant(false))
    }
}
