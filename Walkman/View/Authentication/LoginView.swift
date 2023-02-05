//
//  LoginView.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/2/23.
//

import SwiftUI
import Foundation


struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    @State private var error: String?
    @State private var isHomeViewActive = false
    @State var selection: String?
    @State var accountType: Int = 0
    
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var storeManager: StoreManager
    @EnvironmentObject var orderManager: OrderManager
    @EnvironmentObject var driverManager: DriverManager
//    @ObservedObject var locationManager: LocationManager = LocationManager()
    
    let id = "1"
    var body: some View {
        NavigationView {
            if viewModel.signedIn {
                AppTabBarView(storeManager: storeManager)
                    .environmentObject(viewModel)
                    .environmentObject(locationManager)
            } else if storeManager.signedIn {
                StoreToolbar(storeManager: storeManager)
                    .environmentObject(storeManager)
                    .environmentObject(locationManager)
                    .environmentObject(orderManager)
                    .background(.secondary)
                    .toolbar(.hidden)
                    
            } else if driverManager.signedIn {
                DriverToolbar()
                    .environmentObject(driverManager)
                    .environmentObject(locationManager)
            } else {
                VStack {
                    Spacer()
                    TextField("Email", text: $email)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .textContentType(.emailAddress)
                        .textFieldStyle(CustomOutlinedTextField(icon: Image(systemName: "mail")))
                        .padding(.leading)
                        .padding(.trailing)
                        
                    
                    SecureField("Password", text: $password)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding(.leading)
                        .padding(.trailing)
                        .textFieldStyle(CustomOutlinedTextField(icon: Image(systemName: "lock")))
                    
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
                            viewModel.login(email: email, password: password)
                            break
                        case 1:
                            print("DEBUG: viewModel.signIn() Driver")
//                            let location = locationManager.createGeo()
//                            if location.coordinates[0] == 0.00 {
//                                print("DEBUG: Set alert saying we need to access your location.")
//                                return
//                            }
//                            print("DEBUG: location - \(location)")
                            driverManager.loginDriver(email: email, password: password)
                            break
                        case 2:
                            print("DEBUG: viewModel.signIn() Store")
                            storeManager.loginStore(email: email, password: password)
                            break
                        default:
                            break
                        }
                        
                    }, label: {
                        Text("Sign in")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .frame(width: 200, height: 50)
                            .background(Color("cartIcon"))
                            .cornerRadius(8)
                            .padding()
                    })
                    
                    NavigationLink(destination:
                                    RegisterView()
                        .environmentObject(viewModel)
                        .environmentObject(locationManager)
                    ) {
                        Text("Don't have an acccount?")
                            .bold()
                            .font(.subheadline)
                            .padding()
                            .foregroundColor(.primary)
                        
                    }
                }
                .navigationBarTitle("Sign in")
                .navigationBarTitleDisplayMode(.large)
                .task {
                    // Fetch to see if the user or store is currently logged in
                    viewModel.user = try? await viewModel.fetchUser()
                    storeManager.loggedInStore = try? await storeManager.fetchStore()
                    
                    viewModel.signedIn = viewModel.isSignedIn
                    storeManager.signedIn = storeManager.isSignedIn
                }
            }
            
        }
        .accentColor(.primary)
    }
}


    
//




struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


