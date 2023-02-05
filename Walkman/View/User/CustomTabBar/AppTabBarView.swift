//
//  AppTabBarView.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/2/23.
//

import SwiftUI
import MapKit

struct AppTabBarView: View {
    @State private var selection: String = "Home"
    @EnvironmentObject var cartManager: CartManager
    //    @ObservedObject var userManager: UserManager = UserManager()
    @ObservedObject var storeManager: StoreManager
    @EnvironmentObject var locationManager: LocationManager
    @ObservedObject var orderManager: OrderManager = OrderManager()
    //    @State var uid: String
    @State private var tabSelection: TabBarItem = .home
    
    //    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var viewModel: AppViewModel
    
    
    var body: some View {
        TabView {
            StoreCardView(storeManager: storeManager)
                .environmentObject(viewModel)
                .environmentObject(cartManager)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            CartView(orderManager: orderManager)
                .environmentObject(viewModel)
                .environmentObject(cartManager)
                .tag(cartManager.items.count)
                .tabItem {
                    Image(systemName: "cart")
                    Text("Cart")
                }
            OrderView(locationManager: locationManager, orderManager: orderManager)
                .environmentObject(viewModel)
                .environmentObject(cartManager)
                .tabItem {
                    Image(systemName: "heart")
                    Text("Orders")
                }
            UserProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                
        }
        .accentColor(.primary)
        .toolbarBackground(Color.white, for: ToolbarPlacement.navigationBar)
        .task {
            viewModel.user = try? await viewModel.fetchUser()
            
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

//struct AppTabBarView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        AppTabBarView()
//            
//    }
//}




