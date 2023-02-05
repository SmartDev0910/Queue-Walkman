//
//  QuantityButtonView.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/17/23.
//

import SwiftUI

struct QuantityButtonView: View {
    @ObservedObject var cartManager: CartManager
    @State var item: Item
    
    var body: some View {
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
    }
}

//struct QuantityButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuantityButtonView()
//    }
//}
