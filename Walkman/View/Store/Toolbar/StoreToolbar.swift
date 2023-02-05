//
//  StoreToolbar.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/13/23.
//

import SwiftUI
import MapKit

struct StoreToolbar: View {
    @State private var selection: String = "Home"
    let cartManager = CartManager()
    //    @ObservedObject var userManager: UserManager = UserManager()
    @ObservedObject var storeManager: StoreManager
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var orderManager: OrderManager
//    @ObservedObject var orderManager: OrderManager = OrderManager()
    //    @State var uid: String
    @State private var tabSelection: TabBarItem = .home
    
    //    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var viewModel: AppViewModel
    
    
    var body: some View {
        TabView {
            DashboardView()
                .environmentObject(locationManager)
                .environmentObject(storeManager)
                .environmentObject(orderManager)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            StoreProfileView()
                .environmentObject(locationManager)
                .environmentObject(storeManager)
                .tabItem {
                    Image(systemName: "person")
                    Text("Store")
                }
            
                
        }
        .accentColor(.primary)
        .toolbarBackground(Color.white, for: ToolbarPlacement.navigationBar)
        .task {
            storeManager.loggedInStore = try? await storeManager.fetchStore()
        }
//        NavigationStack {
//            VStack {
//                CustomTabBarContainerView(cartManager: cartManager, selection: $tabSelection, content: {
//                    StoreCardView(cartManager: cartManager, storeManager: storeManager)
//                        .tabBarItem(tab: .home, selection: $tabSelection)
//                    //
//                    CartView(cartManager: cartManager, orderManager: orderManager)
//
//                        .environmentObject(viewModel)
//                        .tabBarItem(tab: .cart, selection: $tabSelection)
//                    //
//                    //
//                    OrderView(cartManager: cartManager, locationManager: locationManager, orderManager: orderManager)
//                        .tabBarItem(tab: .orders, selection: $tabSelection)
//                        .environmentObject(viewModel)
//                    //                    .environmentObject(locationManager)
//
//                    UserProfileView()
//                        .tabBarItem(tab: .profile, selection: $tabSelection)
//                        .environmentObject(viewModel)
//
//
//                })
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .task {
//                    viewModel.user = try? await viewModel.fetchUser()
//                }
//            }
//        }
//
//        .onAppear {
//            viewModel.getUser()
//        }
    }
}

//struct StoreToolbar_Previews: PreviewProvider {
//    static var previews: some View {
//        StoreToolbar()
//    }
//}
