//
//  DashboardView.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/13/23.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var storeManager: StoreManager
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var orderManager: OrderManager
    @State private var orderStatus: Int = 0
    
    let status: [Int: String] = [
        0: "Received",
        1: "Preparing",
        2: "Ready",
        3: "Queued",
        4: "Delivered"
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ForEach(storeManager.storeOrders, id: \.id) { order in
                        OrderCardView(id: order.id ?? "", total: order.total, orderStatus: order.status)
                            .environmentObject(orderManager)
                    }
                }
                .navigationTitle("Orders")
            }
            .task {
                storeManager.storeOrders = try! await storeManager.fetchOrders()
            }
        }
        
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
