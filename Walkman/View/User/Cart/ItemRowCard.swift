//
//  ItemRowCard.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/3/23.
//

import SwiftUI

struct ItemRowCard: View {
    @EnvironmentObject var cartManager: CartManager
    var item: Item
    
    
    var body: some View {
        VStack {
            HStack {
                Image("food2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 4))
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(item.name)")
                        .font(.headline)
                        .bold()
                    //                                Text("\(order.store.phone)")
                    //                                    .font(.caption)
                    Text("$\(Double(item.quantity) * item.price, specifier: "%.2f")")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.secondary)
                        .padding(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 0))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Button {
                        cartManager.decreaseQuantity(item: item)
                    } label: {
                        Image(systemName: "minus")
                            .frame(width: 20, height: 20)
                            .bold()
                            .padding(4)
                            .background(.black)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                        
                    }
                    Text("\(item.quantity)")
                        .frame(width: 28, height: 28)
                        .font(.system(size: 20))
                        .bold()
                    Button {
                        cartManager.increaseQuantity(item: item)
                    } label: {
                        Image(systemName: "plus")
                            .frame(width: 20, height: 20)
                            .bold()
                            .padding(4)
                            .background(.black)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                }
                    .padding(.trailing, 24)
//                Spacer()
//                Image(systemName: "trash")
//                    .foregroundColor(.red)
//                    .onTapGesture {
//                        cartManager.removeFromCart(item: item)
//                    }
            }
            Divider()
            
        }
        .padding()
    }
}

//struct ItemRowCard_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemRowCard(cartManager: CartManager(), item: Item(sid: "1", name: "test", price: 1.50, description: "testing", quantity: 1))
//    }
//}
