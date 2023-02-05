//
//  OrderRowCard.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/6/23.
//

import SwiftUI

struct OrderRowCard: View {
//    var order: Order
    @ObservedObject var cartManager: CartManager
    
    var body: some View {
        HStack(spacing: 20) {
            Image("pancakes")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50)
                .cornerRadius(10)
            
//            VStack(alignment: .leading) {
//                Text(order.name)
//                    .bold()
//                Text(item.sid)
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//                Text("$\(item.price, specifier: "%.2f")")
//                
//            }
//            Spacer()
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct OrderRowCard_Previews: PreviewProvider {
    static var previews: some View {
        OrderRowCard(cartManager: CartManager())
    }
}
