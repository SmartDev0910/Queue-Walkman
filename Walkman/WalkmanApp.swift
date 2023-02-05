//
//  WalkmanApp.swift
//  Walkman
//
//  Created by Patrick Cockrill on 11/17/22.
//

import SwiftUI
//import FirebaseCore
//import Firebase

@main
struct WalkmanApp: App {
    var body: some Scene {
        
        
        WindowGroup {
            let viewModel = AppViewModel()
            let locationManager = LocationManager()
            let storeManager = StoreManager()
            let orderManager = OrderManager()
            let driverManager = DriverManager()
            let cartManager = CartManager()
            LoginView()
                .environmentObject(viewModel)
                .environmentObject(locationManager)
                .environmentObject(storeManager)
                .environmentObject(orderManager)
                .environmentObject(driverManager)
                .environmentObject(cartManager)
//                .environmentObject(viewModel)
//            .frame(maxWidth: .infinity, maxHeight: .infinit
        }
    }
}


