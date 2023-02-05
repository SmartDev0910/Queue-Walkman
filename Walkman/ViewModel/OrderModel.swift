//
//  OrderModel.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/11/23.
//

import Foundation

class DriverManager: NSObject, ObservableObject, URLSessionWebSocketDelegate {
//    @Published var drivers = [Driver]()
    @Published var signedIn: Bool = false
    @Published var curDriver: Driver?
    private var nearbyDrivers = [Driver]()
    private var webSocket: URLSessionWebSocketTask?
    
    var isSignedIn: Bool {
        curDriver != nil
    }
    
    var order: Order? {
        didSet {
            print("DEBUG: Driver show pickup order animation...")
        }
    }
    
    struct Accept: Codable {
        var did: String
        var oid: String
    }
    
    override init() {
        super.init()
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let url = URL(string: "ws://127.0.0.1:8000/socket/drivers/listen")
        self.webSocket = session.webSocketTask(with: url!)
        self.webSocket?.resume()
    }
    
    struct loginResponse: Codable {
        var success: Bool
        var error: String?
        var driver: Driver
    }
    
    func loginDriver(email: String, password: String) {
        let url = URL(string: "http://127.0.0.1:8000/driver/login")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        // create the JSON payload
        let payload: [String: Any] = ["email": email, "password": password]
        let data = try! JSONSerialization.data(withJSONObject: payload, options: [])
        request.httpBody = data

        // perform the request
        do {
            let data = try performRequest(request)

            // parse the response
            let response = try JSONDecoder().decode(loginResponse.self, from: data)
            if response.success {
                // login successful
                DispatchQueue.main.async {
                    self.signedIn = true
                    print("CUR DRIVER \(response.driver)")
                    self.curDriver = response.driver
//                    self.isLoading = false
                }

            } else {
                print("DEBUG: Failed to login")
            }
        } catch {
            print("DEBUG: failed to login \(error)")
        }
    }
    
    func getNearbyDrivers(query: GeoQuery) {
        guard let url = URL(string: "http://localhost:8000/drivers-nearby") else { fatalError("Missing URL") }
//        var drivers = [Driver]()
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let jsonEncoder = JSONEncoder()
        let userData = try! jsonEncoder.encode(query)
        request.httpBody = userData
        
//        let payload: [String: Any] = [
//            "distance": query.distance,
//            "geo": ["type": "Point", "coordinates": query.geo.coordinates]
//        ]
//        let data = try! JSONSerialization.data(withJSONObject: payload, options: [])
//        request.httpBody = data
//
        do {
            let data = try performRequest(request)
            let response = try JSONDecoder().decode([Driver].self, from: data)
            DispatchQueue.main.async {
                self.nearbyDrivers = response
            }
            
        } catch {
            print("DEBUG: Failed to fetch nearby drivers \(error)")
        }
        
//        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                print("Request error: ", error)
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse else { return }
//
//            if response.statusCode == 200 {
//                guard let data = data else { return }
//                DispatchQueue.main.async {
//                    do {
//                        self.nearbyDrivers = try JSONDecoder().decode([Driver].self, from: data)
//                        print("DEBUG: Fetched Drivers nearby")
////                        self.signedIn = true
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
        
    }
    
    private func performRequest(_ request: URLRequest) throws -> Data {
        var data: Data?
        var response: URLResponse?
        var error: Error?

        let semaphore = DispatchSemaphore(value: 0)

        URLSession.shared.dataTask(with: request) {
            data = $0
            response = $1
            error = $2

            semaphore.signal()
        }
        .resume()

        _ = semaphore.wait(timeout: .distantFuture)

        if let error = error {
            throw error
        }

        return data!
    }
    
    

    func ping() {
        webSocket?.sendPing(pongReceiveHandler: { error in
            if let error = error {
                print("ERROR: Ping error: \(error)")
            }
        })
    }
    
    func close() {
        webSocket?.cancel(with: .goingAway, reason: "demo ended".data(using: .utf8))
    }
    
    func send(accepting: Data) {
        DispatchQueue.global().asyncAfter(deadline: .now()) {
//            self.send(accepting: accepting)
            self.webSocket?.send(.data(accepting), completionHandler: { error in
                if let error = error {
                    print("ERROR: Send error: \(error)")
//                    self.close()
                }
            })
        }
    }
    func receive() {
        // MARK: Observe orders as they come in... so far this is only triggered when an order transitions to Ready state
        webSocket?.receive(completionHandler: { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    let order = try? JSONDecoder().decode(Order.self, from: data)
                    // Get the location of the order
                    print("DEBUG ORDER (Driver listener): \(String(describing: order))")
                    // Make sure curDriver is a nearby driver
                    print("DEBUG DRIVER INFO: \(self?.curDriver?.location.coordinates) | \(self?.curDriver)")
                    
                    guard let coordinates = self?.curDriver?.location.coordinates else { break }
                    guard let curDriver = self?.curDriver else { break }
                    self?.getNearbyDrivers(query: GeoQuery(distance: 1609, geo: GeoJSON(coordinates: coordinates)))
                    print("TESTING AFTER GET NEARBY")
                    guard let nearby = self?.nearbyDrivers else { break }
                    
                    if nearby.contains(curDriver) {
                        print("DEBUG DRIVER: Cur Driver \(curDriver)")
                        let accepting = Accept(did: self?.curDriver?.id ?? "13232", oid: order?.id ?? "123")
                        let jsonEncoder = JSONEncoder()
                        let acceptOrderData = try! jsonEncoder.encode(accepting)
                        // This instances driver is logged in and nearby so display a prompt to accept
                        // Possibly use a Bool to flag a view in the driver main view
                        // On that accept button in that view do the self?.send() and save the driver to the order
                        
                        self?.send(accepting: acceptOrderData)
                    }
                case .string(let message):
                    print("Got String: \(message)")
                    
                @unknown default:
                    break
                }
            case .failure(let error):
                print("ERROR: Receive error: \(error)")
                self?.close()
                return
            }
            self?.receive()
        })
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("WEBSOCKET: Did Connect Driver Socket!")
        ping()
        receive()
//        send()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("WEBSOCKER: Did close connection with reason")
    }
}


class OrderManager: NSObject, ObservableObject, URLSessionWebSocketDelegate {
    @Published var orders = [Order]()
    @Published var isLoaded: Bool = false

    private var webSocket: URLSessionWebSocketTask?
    
    override init() {
        super.init()
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let url = URL(string: "ws://127.0.0.1:8000/socket/order/listen")
        self.webSocket = session.webSocketTask(with: url!)
        self.webSocket?.resume()
    }
    
    struct Response: Codable {
        let success: Bool
        let error: String?
        //    let user: User
    }
    struct OrderResponse: Codable {
        let success: Bool
        let error: String?
        let order: Order
    }
    
    
    
    func fetchOrders(uid: String) async throws -> [Order] {
        guard let url = URL(string: "http://127.0.0.1:8000/orders/\(uid)") else { fatalError("Missing URL") }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Order].self, from: data)
    }
    
    func resolveLocalOrders(order: Order) {
        for oin in orders.indices {
            if order.id == orders[oin].id {
                print("DEBUG: Orders status changed from \(orders[oin].status) to \(order.status)")
                DispatchQueue.main.async {
                    self.orders[oin].status = order.status
                    print("ORDER MANAGER: Modified - \(order)")
                }
                
            } else {
                DispatchQueue.main.async {
                    self.orders.append(order)
                    print("ORDER MANAGER: Added - \(order)")
                }
                
            }
        }
    }
    
    func updateStatus(orderId: String, newStatus: Int)  {
        guard let url = URL(string: "http://127.0.0.1:8000/order/\(orderId)/\(newStatus)") else { fatalError("Missing URL or Parameters") }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        // perform the request
        do {
            let data = try performRequest(request)
            // parse the response
            let response = try JSONDecoder().decode(OrderResponse.self, from: data)
            print("TEST2")
            if response.success {
                // registration successful, navigate to home view
                DispatchQueue.main.async {
                    print("DEBUG STATUS: \(response.order)")
                    let jsonEncoder = JSONEncoder()
                    let orderData = try! jsonEncoder.encode(response.order)
                    
                    self.send(order: orderData)
                }
                
            } else {
                print("DEBUG: Error signing in")
            }
        } catch {
            print("DEBUG: Something went wrong performing updateStatus() regquest \(error)")
        }
        
    }
    
    private func performRequest(_ request: URLRequest) throws -> Data {
        var data: Data?
        var response: URLResponse?
        var error: Error?

        let semaphore = DispatchSemaphore(value: 0)

        URLSession.shared.dataTask(with: request) {
            data = $0
            response = $1
            error = $2

            semaphore.signal()
        }
        .resume()

        _ = semaphore.wait(timeout: .distantFuture)

        if let error = error {
            throw error
        }

        return data!
    }
    
    
    func ping() {
        webSocket?.sendPing(pongReceiveHandler: { error in
            if let error = error {
                print("ERROR: Ping error: \(error)")
            }
        })
    }
    
    func close() {
        webSocket?.cancel(with: .goingAway, reason: "demo ended".data(using: .utf8))
    }
    
    func send(order: Data) {
        DispatchQueue.global().asyncAfter(deadline: .now()) {
//            self.send(order: order)
            self.webSocket?.send(.data(order), completionHandler: { error in
                if let error = error {
                    print("ERROR: Send error: \(error)")
//                    self.close()
                }
            })
        }
    }
    func receive() {
        webSocket?.receive(completionHandler: { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    let order = try? JSONDecoder().decode(Order.self, from: data)
//                    print("DEBUG: Order Added _ \(order)")
                    print("DEBUG THIS IS RECEIVING ORDER Handler \(order?.id)")
                    DispatchQueue.main.async {
//                        self?.orders.append(order!)
                        self?.resolveLocalOrders(order: order!)
                    }
                    
                case .string(let message):
                    print("Got String: \(message)")
//                    DispatchQueue.main.async {
//                        let data = message.data(using: .utf8)!
//                        do {
//                            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
//                                print(jsonArray)
//                            } else {
//                                print("bad json")
//                            }
//                        } catch let error as NSError {
//                            print(error)
//                        }
//                    }
                    
                @unknown default:
                    break
                }
            case .failure(let error):
                print("ERROR: Receive error: \(error)")
                self?.close()
                return
            }
            self?.receive()
        })
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("WEBSOCKET: Did Connect Order socket!")
        ping()
        receive()
        ping()
//        send()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("WEBSOCKER: Did close connection with reason")
    }

}

extension Array {
    func contains<T>(_ object: T) -> Bool where T: Equatable {
        !self.filter { $0 as? T == object }.isEmpty
    }
}
