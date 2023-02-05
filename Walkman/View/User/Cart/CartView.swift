//
//  CartView.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/3/23.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var viewModel: AppViewModel
    @StateObject var orderManager: OrderManager
    @State private var showingOrder = false
    @State private var itemCount = 0
    @State private var items = [Item]()
    @State private var total = 0.00
    @State private var tax = 0.00
    @State private var deliveryFee = 5.00
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    if self.itemCount > 0 {
                        ForEach(cartManager.items) { item in
                                ItemRowCard(item: item)
                                    .environmentObject(cartManager)
                            }
                        } else {
                            Text("Your cart is empty")
                        }
                }
                .navigationBarTitle("Cart")
                .sheet(isPresented: $showingOrder) {
                    Text("Your order is now being processed")
                }
                if itemCount > 0 {
                    Spacer()
                    VStack(spacing: 0) {
                        HStack(alignment: .bottom) {
                            Text("\("Subtotal")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("$\(cartManager.total, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                
                        }
                        .padding(.bottom, 4)
                        HStack(alignment: .bottom) {
                            Text("\("Taxes")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("$\(cartManager.taxes, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                
                        }
                        .padding(.bottom, 4)
                        .padding(.bottom, 4)
                        HStack(alignment: .bottom) {
                            Text("\("Delivery Fee")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("$\(self.deliveryFee, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                
                        }
                        .padding(.bottom, 4)

                        Divider()
                            .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        HStack(alignment: .bottom) {
                            Text("\("Total")")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                            Text("$\(cartManager.total + cartManager.taxes + self.deliveryFee, specifier: "%.2f")")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .bottom)
                    .padding(.trailing)
                    .padding(.leading)
                    PaymentButton(action: {
                        guard let uid = viewModel.user?.id else { return }
                        let order = Order(sid: cartManager.items[0].sid, uid: uid, status: 0, items: cartManager.items, total: cartManager.total)
                        cartManager.pay(order: order)
                        
                    })
                    .padding()
                    .disabled(cartManager.items.count > 0 ? false : true)
                    .opacity(cartManager.items.count > 0 ? 1.0 : 0.80)
                }
            }
        }
        .onChange(of: cartManager.items.count) { newValue in
            self.itemCount = cartManager.items.count
//            self.items = cartManager.items
//            self.total = cartManager.total
//            self.tax = cartManager.taxes
        }
    }
}

//struct CartView_Previews: PreviewProvider {
//    static var previews: some View {
//        CartView(orderManager: OrderManager())
//            
//    }
//}
