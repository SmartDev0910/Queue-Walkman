//
//  PriceView.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/12/23.
//

import SwiftUI

struct PriceView: View {
    @State var label: String = ""
    @State var price: Float64 = 0.00
    
    var body: some View {
        HStack(alignment: .bottom) {
            Text("\(self.label)")
                .font(self.label == "Total" ? .headline : .subheadline)
                .foregroundColor(self.label == "Total" ? .primary : .secondary)
            Spacer()
            Text("$\(self.price, specifier: "%.2f")")
                .font(self.label == "Total" ? .headline : .subheadline)
                .foregroundColor(self.label == "Total" ? .primary : .secondary)
                
        }
        .padding(.bottom, 4)
    }
}

struct PriceView_Previews: PreviewProvider {
    static var previews: some View {
        PriceView()
    }
}
