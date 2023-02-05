//
//  AddressView.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/12/23.
//

import SwiftUI

struct AddressView: View {
    @State var street = ""
    @State var suite = ""
    @State var zip = ""
    @State var state = ""
    
    init(street: String = "", suite: String = "", zip: String = "", state: String = "VA") {
        self.street = street
        self.suite = suite
        self.zip = zip
        self.state = state
    }
    
    var body: some View {
        VStack {
            Text("Address")
                .font(.title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            TextField("Street", text: $street)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            //                .textFieldStyle(.roundedBorder)
                .padding(.leading)
                .padding(.trailing)
            //                        .padding(.top)
                .textFieldStyle(CustomOutlinedTextField(icon: Image(systemName: "house"), iconShowing: false))
            
            HStack {
                TextField("Suite", text: $suite)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                //                .textFieldStyle(.roundedBorder)
                    .padding(.leading)
                    .textFieldStyle(CustomOutlinedTextField(icon: Image(systemName: "house"), iconShowing: false))
                
                TextField("Zip", text: $zip)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                //                .textFieldStyle(.roundedBorder)
                    .textFieldStyle(CustomOutlinedTextField(icon: Image(systemName: "house"), iconShowing: false))
                //                            .frame(width: 100)
                TextField("State", text: $state)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .multilineTextAlignment(.center)
                //                .textFieldStyle(.roundedBorder)
                    .padding(.trailing)
                    .textFieldStyle(CustomOutlinedTextField(icon: Image(systemName: "house"), iconShowing: false))
                //                            .frame(width: 100)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView()
    }
}
