//
//  CartButton.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/3/23.
//

import SwiftUI

struct CartButton: View {
    var numberOfItems: Int
    
    
    var body: some View {
        ZStack(alignment: .topTrailing, content: {
            Image(systemName: "cart")
                .padding(.top, 5)
            
            if numberOfItems > 0 {
                Text("\(numberOfItems)")
                    .font(.caption2).bold()
                    .foregroundColor(.white)
                    .frame(width:15, height: 15)
                    .background(Color(hue: 1.0, saturation: 0.89, brightness: 0.835))
                    .cornerRadius(50)
            }
        })
    }
}

struct CartButton_Previews: PreviewProvider {
    static var previews: some View {
        CartButton(numberOfItems: 1)
    }
}
