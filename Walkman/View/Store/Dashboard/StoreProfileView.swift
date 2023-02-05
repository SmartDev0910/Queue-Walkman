//
//  StoreProfileView.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/13/23.
//

import SwiftUI

struct StoreProfileView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var storeManager: StoreManager
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Name: \(storeManager.loggedInStore?.name ?? "")")
            }
            .navigationTitle("\(storeManager.loggedInStore?.name ?? "Profile")")
        }
    }
}

struct StoreProfileView_Previews: PreviewProvider {
    static var previews: some View {
        StoreProfileView()
    }
}
