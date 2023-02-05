//
//  StoreCardDetailView.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/3/23.
//

import SwiftUI

struct StoreCardDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var cartManager: CartManager
    @ObservedObject var storeManager: StoreManager
    @Binding var store: Store
    
    var columns = [GridItem(.flexible(), spacing: nil, alignment: nil)]
    
    var body: some View {
        ScrollView {
            VStack {
                ZStack(alignment: .topLeading, content: {
                    Image("BYO_Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 400)
                        .overlay(alignment: .leading, content: {
                        }
                        )
                    Button {
                        dismiss()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 44, height: 44)
                                .offset(x: 12, y: 18)
                            Image(systemName: "arrow.backward")
                                .resizable()
                                .foregroundColor(.black)
                                .frame(maxWidth: 30, maxHeight: 25, alignment: .leading)
                                .offset(x: 12, y: 18)
                                .font(.largeTitle)
                        }
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)

                    }
                })
                VStack(spacing: 0) {
                    Group {
                        Text("\(store.name)")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
//                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 0))
                        Text("\(store.address?.street ?? "address")")
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .padding(.leading)
                            .fontWeight(.light)
                        Text("Open until 9:30 PM")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.leading)
                            .padding(.bottom)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    Divider()
                }
                
            }
            .onDisappear {
                storeManager.fetchData()
            }
            LazyVGrid(columns: columns) {
                ForEach(store.inventory ?? [], id: \.id) { item in
                    ItemCard(store: store, item: item)
                        .environmentObject(cartManager)
//                        .environmentObject(CartManager())
                }
            }
            .padding()
            
        }
        
    }
}

//struct StoreCardDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        StoreCardDetailView(cartManager: CartManager(), store: Store(id: "1", name: "", owner: "", phone: "", email: "", inventory: []))
////            .environmentObject(CartManager())
//    }
//}
