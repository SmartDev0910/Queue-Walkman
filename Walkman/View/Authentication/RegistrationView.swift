//
//  RegistrationView.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/3/23.
//

import SwiftUI
import Foundation

struct RegisterView: View {
    @State private var name: String = ""
    @State private var owner: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var password: String = ""
    
    @State private var street: String = ""
    @State private var suite: String = ""
    @State private var city: String = ""
    @State private var zip: String = ""
    @State private var state: String = "VA"
    
    @State private var accountType: Int = 0
    @State private var isLoading = false
    @State private var error: String?
    @State private var isHomeViewActive = false
    @State var selection: String?
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let id = "2"
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var locationManager: LocationManager

    var body: some View {
        
        VStack {
            ScrollView {
                TextField(accountType != 2 ? "Name" : "Store name", text: $name)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding(.top, 16)
                    .padding(.leading)
                    .padding(.trailing)
                    .textFieldStyle(CustomOutlinedTextField(icon: Image(systemName: "house")))
                
                if accountType == 2 {
                    TextField("Owner", text: $owner)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding(.top, 10)
                        .padding(.leading)
                        .padding(.trailing)
                        .textFieldStyle(CustomOutlinedTextField(icon: Image(systemName: "person")))
                }
                
                TextField("Email", text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(.leading)
                    .padding(.trailing)
                    .textFieldStyle(CustomOutlinedTextField(icon: Image(systemName: "mail")))
                
                TextField("Phone", text: $phone)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .keyboardType(.phonePad)
                    .padding(.leading)
                    .padding(.trailing)
                    .textFieldStyle(CustomOutlinedTextField(icon: Image(systemName: "phone")))
                
                SecureField("Password", text: $password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding(.leading)
                    .padding(.trailing)
                    .textFieldStyle(CustomOutlinedTextField(icon: Image(systemName: "lock")))
                if self.accountType == 2 {
                    AddressView(street: street, suite: suite, zip: zip, state: state)
                }
            }
            
            
            if error != nil {
                Text(error!)
                    .font(.caption)
                    .foregroundColor(.red)
                    .bold()
                    .padding()
            }
            Spacer()

            Picker(selection: $accountType, label: Text("Picker here")) {
                Text("User")
                    .tag(0)
                Text("Courier")
                    .tag(1)
                Text("Store")
                    .tag(2)
                    
            }.pickerStyle(SegmentedPickerStyle())
                .padding()
            
                
            
            Button(action: {
                switch accountType {
                case 0:
                    let location = locationManager.createGeo()
                    if location.coordinates[0] == 0.00 {
                        print("DEBUG: Set alert saying we need to access your location.")
                        return
                    }
                    print("DEBUG: location - \(location)")
                    viewModel.register(user: User(name: name, email: email, password: password,location: location, phone: phone))
                    break
                case 1:
                    print("DEBUG: viewModel.signUp()")
                    let location = locationManager.createGeo()
                    if location.coordinates[0] == 0.00 {
                        print("DEBUG: Set alert saying we need to access your location.")
                        return
                    }
                    print("DEBUG: location - \(location)")
                    viewModel.registerDriver(driver: Driver(name: name, email: email, phone: phone, password: password, location: location))
                    break
                case 2:
                    print("DEBUG: storeManager.register()")
                    let location = locationManager.createGeo()
                    if location.coordinates[0] == 0.00 {
                        print("DEBUG: Set alert saying we need your location...")
                        return
                    }
                    viewModel.registerStore(store: Store(name: name, owner: owner, phone: phone, email: email, location: location, inventory: [Item]()))
                default:
                    break
                }
                
            }, label: {
                Text("Create Account")
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .frame(width: 200, height: 50)
                    .background(Color("cartIcon"))
                    .cornerRadius(8)
                    .padding()
            })
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Already have an account?")
                    .bold()
                    .font(.subheadline)
                    .padding()
                    .foregroundColor(.primary)
            }
        }
        .navigationTitle("Register")
        .navigationBarTitleDisplayMode(.large)
        
    }

}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
