//
//  CustomTabBarView.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/2/23.
//

import SwiftUI

struct CustomTabBarView: View {
    let tabs: [TabBarItem]
    @Binding var selection: TabBarItem
    @Namespace private var namespace
    @State var localSelection: TabBarItem
    @ObservedObject var cartManager: CartManager
    
    var numberOfItems: Int
    
    var body: some View {
        tabBarVersion2
            .onChange(of: selection) { newValue in
                withAnimation(.easeInOut) {
                    localSelection = newValue
                }
            }
    }
}

struct CustomTabBarView_Previews: PreviewProvider {
    static let tabs: [TabBarItem] = [
        .home, .cart, .orders, .profile
        ]
    
    static var previews: some View {
        VStack {
            Spacer()
            CustomTabBarView(tabs: tabs, selection: .constant(tabs.first!), localSelection: tabs.first!, cartManager: CartManager(), numberOfItems: 1)

        }
        
    }
}

extension CustomTabBarView {
    private func tabView(tab: TabBarItem) -> some View {
        VStack {
            Image(systemName: tab.iconName)
                .font(.subheadline)
            Text(tab.title)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
        }
        .foregroundColor(localSelection == tab ? tab.color : Color.gray)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(localSelection == tab ? tab.color.opacity(0.2) : Color.clear)
        .cornerRadius(10)
        
    }
    
    private var tabBarVersion1: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                
                tabView(tab: tab)
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
            }
        }
        .background(Color.white.ignoresSafeArea(edges: .bottom))
        .padding()
    }
    
    private func switchToTab(tab: TabBarItem) {
//        withAnimation(.easeInOut) {
        selection = tab
        if tab == .cart && cartManager.paymentSuccess == true {
            cartManager.paymentSuccess = false
        }
//        }
    }
}

extension CustomTabBarView {
    private func tabView2(tab: TabBarItem) -> some View {
        
        VStack {
            if tab == .cart {
                ZStack(alignment: .topTrailing, content: {
                    VStack {
                        Image(systemName: tab.iconName)
                            .font(.headline)
                        Text(tab.title)
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                    }
                    
                    if cartManager.items.count > 0 {
                        Text("\(cartManager.items.count)")
                            .font(.caption2).bold()
                            .foregroundColor(.white)
                            .frame(width:15, height: 15)
                            .background(Color("cartIcon"))
//                            .background(Color(hue: 1.0, saturation: 0.89, brightness: 0.835))
                            .cornerRadius(50)
                            .offset(x: 10)
                    }
                })
            } else {
                Image(systemName: tab.iconName)
                    .font(.headline)
                Text(tab.title)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
            }
        }
        .foregroundColor(localSelection == tab ? tab.color : Color.gray)
        .fontWidth(.expanded)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                if localSelection == tab {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(tab.color.opacity(0.05))
                        .matchedGeometryEffect(id: "background_rectangle", in: namespace)
                }
            }
        
        )
        
    }
    
    private var tabBarVersion2: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                    tabView2(tab: tab)
                        .onTapGesture {
                            switchToTab(tab: tab)
                    
                }
            }
        }
        .padding(6)
//        .background(.ignoresSafeArea(edges: .bottom))
        .cornerRadius(10)
//        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}

enum TabBarItem: Hashable {
    case home, cart, orders, profile
    var iconName: String {
        switch self {
        case .home: return "house"
        case .cart: return "cart"
        case .orders: return "heart"
        case .profile: return "person"
        }
    }
    var title: String {
        switch self {
        case .home: return "Home"
        case .cart: return "Cart"
        case .orders: return "Orders"
        case .profile: return "Profile"
        }
    }
    var color: Color {
        switch self {
        case .home: return Color.primary
        case .cart: return Color.primary
        case .orders: return Color.primary
        case .profile: return Color.primary
        }
    }
}

