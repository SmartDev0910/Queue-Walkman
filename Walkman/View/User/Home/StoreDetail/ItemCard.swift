//
//  ItemCard.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/3/23.
//

import SwiftUI

struct ItemCard: View {
//    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var cartManager: CartManager
    var store: Store
    @State var item: Item
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, content: {
               
                Text(item.name)
                    .bold()
                    .font(.system(size: 18))

                Text("\(item.description)").font(.subheadline).foregroundColor(.secondary)
                Button {
                    print("add to cart")
                    self.item.quantity = 1
//                    DispatchQueue.main.async {
                        cartManager.addToCart(item: item)
//                    }
                } label: {
                    HStack {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .bold()
                            .font(.system(size: 18))
                            .frame(width: 20, height: 20)
//                            .cornerRadius(50)
                        
                        
//                        Text("Add to cart")
//                            .foregroundColor(.white)
                        Text("$\(item.price, specifier: "%.2f")")
                            .font(.system(size: 16))
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.white)
                            

                        
                    }
                    .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
                    
                    .background(.primary)
                    .foregroundColor(.secondary)
                    .cornerRadius(10)
                }
                .padding(.top, 8)
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            ZStack {
                Image("pancakes")
                    .resizable()
                    .cornerRadius(5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .scaledToFit()
//                    .frame(height: 200)
                    
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 125)
        .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
    }
}

//struct ItemCard_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemCard(cartManager: CartManager(), store: Store(id: "1", name: "", owner: "", phone: "", email: "", location: GeoJSON(coordinates: [0.00, 0.00]), inventory: [Item]()), item: Item(sid: "2", name: "", price: 4.2, description: "", quantity: 0))
////            .environmentObject(CartManager())
//    }
//}
