//
//  DriverToolbar.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/16/23.
//

import SwiftUI
import MapKit

struct DriverToolbar: View {
    @EnvironmentObject var driverManager: DriverManager
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $locationManager.region, interactionModes: .all, showsUserLocation: true)
                .accentColor(Color("cartIcon"))
                .ignoresSafeArea()
        }
    }
}

struct DriverToolbar_Previews: PreviewProvider {
    static var previews: some View {
        DriverToolbar()
    }
}
