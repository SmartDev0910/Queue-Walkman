//
//  User.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/3/23.
//

import Foundation

struct User: Codable {
    var id: String?
    var name: String
    var email: String
    var address: [Address]?
    var password: String?
    var location: GeoJSON
    var phone: String
//    let accountType: Int
//    let orders: [Order]
//    init(dictionary: [String: Any]) {
//        self.name = dictionary["name"] as? String ?? ""
//        self.email = dictionary["email"] as? String ?? ""
//        self.phone = dictionary["phone"] as? String ?? ""
//        self.accountType = dictionary["accountType"] as? Int ?? 0
//    }
}


