//
//  Order.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/3/23.
//

import Foundation

struct Business: Identifiable, Decodable {
    var id: Int
    var name: String
    var catchPhrase: String
    var address: Address
}
