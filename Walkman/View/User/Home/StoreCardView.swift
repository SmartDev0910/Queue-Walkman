//
//  StoreCardView.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/2/23.
//

import SwiftUI

struct StoreCardView: View {
    let storeName: String = "Panera Bread"
    @EnvironmentObject var cartManager: CartManager
    @StateObject var storeManager: StoreManager
    @State private var showingStore = false
    @State var currentStore: Store = Store(id:"1", name: "", owner: "", phone: "", email: "", location: GeoJSON(coordinates: [0.00, 0.00]), inventory: [Item]())
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(storeManager.stores ?? [], id: \.id) { store in
                    Button {
//                        print("STORE HERE: ", store)
                        self.currentStore = store
//                        print("STORE HERE: ", self.selectedStore)
                        showingStore.toggle()
                    } label: {
                        VStack {
                            ZStack {
                                Image("BYO_Logo")
                                    .resizable()
                                    .frame(maxWidth: .infinity, maxHeight: 225)
                                    .cornerRadius(4)
                                
                                
                            }
                            .padding(.leading)
                            .padding(.trailing)
                            HStack {
                                Group {
                                    VStack(alignment: .leading, spacing: 2) {
                                        
                                        Text(store.name)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text("\(store.owner) • 15-20 min")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
                            }
                            
                        }
                        //                            .environmentObject(cartManager)
                    }
                }
                .onAppear {
                    if !storeManager.isLoaded {
                        storeManager.fetchData()
                    }
                }
            }
            .toolbar {
                NavigationLink(destination: Text("Testing")) {
                    Image(systemName: "house")
                }
            }
            
            .navigationTitle("Restaurants")
            .sheet(isPresented: $showingStore) {
                StoreCardDetailView(storeManager: storeManager, store: self.$currentStore)
                    .environmentObject(cartManager)
            }
//            .onChange(of: showingStore) { showingStore in
//                
//            }
        }
    }
}

//struct StoreCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        StoreCardView(cartManager: CartManager(), storeManager: StoreManager())
////            .environmentObject(CartManager())
//    }
//}
