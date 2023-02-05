//
//  OrderView.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/6/23.
//

import SwiftUI
import MapKit

struct MapLocation: Identifiable {
    let id: String
    let name: String
    dynamic var latitude: Double
    dynamic var longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    mutating func updateAnnotationPosition(coord: [Float64]) {
        self.latitude = coord[0]
        self.longitude = coord[1]
    }
}

struct OrderView: View {
    @EnvironmentObject var cartManager: CartManager
//    @ObservedObject var locationManager: LocationManager
    
    @StateObject var locationManager: LocationManager
    @EnvironmentObject var viewModel: AppViewModel
    @ObservedObject var orderManager: OrderManager
    @State private var tracking:MapUserTrackingMode = .follow
    @State private var driversIn: Bool = false
    
    let status: [Int: String] = [
        0: "Received",
        1: "Preparing",
        2: "Ready",
        3: "Queued",
        4: "Delivered"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(orderManager.orders) { order in
                        HStack {
                            Image("food2")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 85, height: 85)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 4))
                            VStack(alignment: .leading, spacing: 0) {
                                Text("\(order.sname ?? "")")
                                    .font(.system(size: 18))
                                    .bold()
//                                Text("\(order.store.phone)")
//                                    .font(.caption)
                                Text("\(order.items.count) \(order.items.count == 1 ? "item" : "items") • $\(order.total, specifier: "%.2f")")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .padding(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 0))
                                Text("\(order.created ?? "Date") • \(status[order.status]!)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Divider()
                        
                    }
                    
                    //                .onAppear(perform: cartManager.getOrders)
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Orders")
            .task {
                if !orderManager.isLoaded {
                    
                    orderManager.orders = try! await orderManager.fetchOrders(uid: viewModel.user?.id ?? "")
//                    orderManager.getOrders(uid: viewModel.user?.id ?? "")
                }
                
            }
//            .onAppear {
//                cartManager.getOrders(uid: viewModel.user?.id ?? "")
////                print("DEBUG: Cart manager ORder VIEW call \(cartManager.orders)")
//            }
        }
        
        
    }
}
//
//struct OrderView_Previews: PreviewProvider {
//    static var previews: some View {
//        OrderView(cartManager: CartManager(), locationManager: LocationManager())
//    }
//}
