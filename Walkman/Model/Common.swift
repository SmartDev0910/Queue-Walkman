//
//  Common.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/3/23.
//

import Foundation
import MapKit

struct Address: Codable, Hashable {
    var street: String
    var suite: String
    var state: String
    var city: String
    var country: String = "US"
    var zip: String
//    var geo: Geo
    
//    struct Geo: Decodable {
//        var lat: String
//        var lng: String
//    }
}

struct GeoJSON: Codable, Hashable {
    var type: String = "Point"
    var coordinates: [Float64]
//    var lat: String
//    var lng: String
}

struct GeoQuery: Codable {
    var distance: Int
    var geo: GeoJSON
}

struct AnnotatedDriver: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct Order: Codable, Identifiable {
    var id: String?
    
    var sid: String
    var sname: String?
    var sphone: String?
    var source: GeoJSON?
    
    var uid: String
    var uname: String?
    var uphone: String?
    var destination: GeoJSON?
    
    var created: String?
    var completed: String?
    var status: Int
    var items: [Item]
    var total: Float64
    var did: String? // driver id
}

struct OrderArgs: Codable {
    var sid: String
    var uid: String
    var status: Bool
    var total: Float64
    var items: [Item]
}

struct OrderDisplay: Codable, Identifiable {
    var id: String
    var store: Store
    var status: Int
    var created: String
    var total: Float64
    var items: [Item]
    var driver: String
}

struct Item: Codable, Identifiable {
    let id: String
    var sid: String
    var name: String
    var price: Float64
    var description: String
    var quantity: Int
}
