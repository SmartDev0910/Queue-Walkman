//
//  Store.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/4/23.
//

import Foundation

struct Store: Codable {
    var id: String?
    var name: String
    var owner: String
    var phone: String
    var email: String
    var location: GeoJSON
    var address: Address?
    let inventory: [Item]?
}
