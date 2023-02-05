//
//  CustomTabBarContainerView.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/2/23.
//

import SwiftUI

struct CustomTabBarContainerView<Content: View>: View {
    
    @Binding var selection: TabBarItem
    let content: Content
    @State private var tabs: [TabBarItem] = []
    @ObservedObject var cartManager: CartManager
    
    init(cartManager: CartManager, selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
        self.cartManager = cartManager
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                content
            }

            CustomTabBarView(tabs: tabs, selection: $selection, localSelection: selection, cartManager: cartManager, numberOfItems: 1)
                .ignoresSafeArea()
                .toolbarBackground(.hidden, for: .bottomBar)
        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self) { value in
            self.tabs = value
        }
    }
}

struct CustomTabBarContainerView_Previews: PreviewProvider {
    static let tabs: [TabBarItem] = [
        .home, .cart, .orders, .profile]
    static var previews: some View {
        CustomTabBarContainerView(cartManager: CartManager(), selection: .constant(tabs.first!)) {
            Color.red
        }
    }
}
