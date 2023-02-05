//
//  LocationModel.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/6/23.
//
import CoreLocation
import Combine
import MapKit


enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 38.914140, longitude: -77.384850)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
}

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var location: CLLocation?
    @Published var mapLocations = [MapLocation]()
    
    @Published var drivers = [Driver]()
    var region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            authorizationStatus = .authorizedWhenInUse
            guard let coord = manager.location?.coordinate else { break }
            region = MKCoordinateRegion(center: coord, span: MapDetails.defaultSpan)
            manager.startUpdatingLocation()
            break
        case .restricted, .denied:
            authorizationStatus = .restricted
            manager.stopUpdatingLocation()
            break
        case .notDetermined:
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
            break
        default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.location = location
            //            self.MapLocations.append(MapLocation(name: "1", latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            // MARK - API for location calls, send when users location updates
            print("DEBUG: Location: \(self.location?.coordinate.longitude ?? 0.00)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("DEBUG: \(error.localizedDescription)")
    }
    
    func createGeo() -> GeoJSON {
        return GeoJSON(coordinates: [self.location?.coordinate.latitude ?? 0.00, self.location?.coordinate.longitude ?? 0.00])
    }
    
    
//    func getNearbyDrivers(query: GeoQuery) {
//        guard let url = URL(string: "http://localhost:8000/drivers-nearby") else { fatalError("Missing URL") }
//        
//        var request = URLRequest(url: url)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"
//        let payload: [String: Any] = [
//            "distance": query.distance,
//            "geo": ["type": "Point", "coordinates": query.geo.coordinates]
//        ]
//        let data = try! JSONSerialization.data(withJSONObject: payload, options: [])
//        request.httpBody = data
//        
//        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                print("Request error: ", error)
//                return
//            }
//            guard let response = response as? HTTPURLResponse else { return }
//            
//            if response.statusCode == 200 {
//                guard let data = data else { return }
//                DispatchQueue.main.async {
//                    do {
//                        let drivers = try JSONDecoder().decode([Driver].self, from: data)
//                        
//                        print("DEBUG: Drivers: \(drivers)")
//                        self.drivers = drivers
//                        self.handleDriverAnnotations(drivers: drivers)
//                        
//                    } catch let error {
//                        print("Error decoding: ", error)
//                        
//                    }
//                }
//            }
//        }
//        
//        dataTask.resume()
//    }
    
    func handleDriverAnnotations(drivers: [Driver]) {
        for driver in drivers {
            let location = MapLocation(id: driver.id ?? "", name: driver.name, latitude: driver.location.coordinates[0], longitude: driver.location.coordinates[1])
            var driverIsVisible: Bool {
                return self.mapLocations.contains(where: { annotation in
                    guard var driverAnno = annotation as? MapLocation else { return false }
                    print("DEBUG: cast driverAnno | driverAnno \(driverAnno.id) | driver \(driver.id)")
                    if driverAnno.id == driver.id {
                        print("DEBUG: Handle update driver position")
                        driverAnno.latitude = driver.location.coordinates[0]
                        driverAnno.longitude = driver.location.coordinates[1]
                        return true
                    }
                    return false
                })
            }
            
            if !driverIsVisible {
                print("DEBUG: Inserting map annotation \(location.id)")
                self.mapLocations.append(location)
            }
        }
    }
    

    
////    private func geocode() {
////        guard let location = self.location else { return }
////        geocoder.reverseGeocodeLocation(location) { (places, error) in
////            if error == nil {
////                self.placemark = places?[0]
////            } else {
////                self.placemark = nil
////            }
////        }
////    }
}

