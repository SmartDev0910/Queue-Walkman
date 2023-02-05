//
//  Network.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/3/23.
//

import Foundation

//extension URLSession {
//    public func data(from url: URL, delegate: URLSessionTaskDelegate? = nil) async throws -> (Data, URLResponse) {
//
//    }
//}




//struct DriverLocation: Codable {
//    let id: String
//    let lat: Double
//    let long: Double
//}
//
//func sendLocationToServer(driverID: String, lat: Double, long: Double) {
//    let driverLocation = DriverLocation(id: driverID, lat: lat, long: long)
////    print("Hello World!")
////    let encoder = JSONEncoder()
////    if let data = try? encoder.encode(driverLocation) {
////        let url = URL(string: "https://yourserver.com/locations")!
////        var request = URLRequest(url: url)
////        request.httpMethod = "POST"
////        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
////        request.httpBody = data
////
////        let task = URLSession.shared.dataTask(with: request) { data, response, error in
////            if let error = error {
////                print("Error sending location to server: \(error)")
////                return
////            }
////
////            if let response = response as? HTTPURLResponse {
////                if response.statusCode != 200 {
////                    print("Error sending location to server. Status code: \(response.statusCode)")
////                    return
////                }
////            }
////
////            print("Successfully sent location to server")
////        }
////
////        task.resume()
////    }
//    // send the driver's location to the server every 10 seconds
//    Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
//        sendLocationToServer(driverID: "123", lat: 37.7749, long: 122.4194)
//    }
//}


