//
//  Driver.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/7/23.
//

import Foundation
import Geohash
import MapKit

struct Driver: Codable, Equatable {
    var id: String?
    var name: String
    var email: String
    var phone: String
    var password: String?
    var location: GeoJSON
    
}

class DriverAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var uid: String
    
    init(uid: String, coordinate: CLLocationCoordinate2D) {
        self.uid = uid
        self.coordinate = coordinate
    }
    
    func updateAnnotationPosition(withCoordinate coordinate:  CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

//func searchPeopleNearby(couriers: [Courier], geohash: String) -> [Courier] {
//  let geohashPrecision = 8  // Adjust this value to control the precision of the search
//  let geohashLower = geohash.prefix(geohashPrecision)
//    let geohashUpper = geohashLower.stringByIncrementingLastCharacter()
//
//  return couriers.filter { courier in
//      let courierGeohash = Geohash.encode(latitude: courier.location.latitude, longitude: courier.location.longitude, length: 10)
//    return courierGeohash >= geohashLower && courierGeohash < geohashUpper
//  }
//}
//
//extension String {
//  func stringByIncrementingLastCharacter() -> String {
//    guard let lastChar = self.last else {
//      return self
//    }
//
//    let charset = "0123456789bcdefghjkmnpqrstuvwxyz"
//    let lastCharIndex = charset.firstIndex(of: lastChar)!
//
//    if lastCharIndex < charset.index(before: charset.endIndex) {
//      // The last character can be incremented, so return a new string with the last character replaced by the next character in the charset
//      let incrementedLastChar = charset[charset.index(after: lastCharIndex)]
//        return self.dropLast().appending(incrementedLastChar)
//    } else {
//      // The last character is the last character in the charset, so it needs to be reset to the first character and a new character needs to be added at the end
//      let resetLastChar = charset.first!
//      let newLastChar = charset[charset.index(after: charset.startIndex)]
//      return self.dropLast().appending(resetLastChar).appending(newLastChar)
//    }
//  }
//}
