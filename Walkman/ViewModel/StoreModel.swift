//
//  StoreModel.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/4/23.
//

import Foundation

class StoreManager: ObservableObject {
    @Published var stores:[Store]?
    @Published var isLoaded: Bool = false
    @Published var loggedInStore: Store?
    @Published var signedIn: Bool = false
    
    @Published var storeOrders = [Order]()
    
    var isSignedIn: Bool {
        return loggedInStore != nil
    }
    
    struct Response: Codable {
        let success: Bool
        let store: Store
    //    let user: User
    }
    
    func loginStore(email: String = "pfo@gmail.com", password: String = "abc1234") {

        // create the request
        let url = URL(string: "http://127.0.0.1:8000/store/login")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        // create the JSON payload
        let payload: [String: Any] = [            "email": email,            "password": password        ]
        let data = try! JSONSerialization.data(withJSONObject: payload, options: [])
        request.httpBody = data

        // perform the request
        do {
            let data = try performRequest(request)

            // parse the response
            let response = try JSONDecoder().decode(Response.self, from: data)
            if response.success {
                // login successful
                DispatchQueue.main.async {
                    self.signedIn = true
                    self.loggedInStore = response.store
                    print("STORE: _ \(self.loggedInStore)")
//                    self.user = response.user
//                    self.isLoaded = false
                }

            } else {
                print("DEBUG: Failed to login")
            }
        } catch {
            print("DEBUG: failed to login \(error.localizedDescription)")
        }
    }
    
    // FetchStores gets the currently logged in store
    func fetchStore() async throws -> Store {
        guard let url = URL(string: "http://127.0.0.1:8000/store") else { fatalError("Missing URL fetchStore()") }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Store.self, from: data)
    }
    func fetchOrders() async throws -> [Order] {
        guard let url = URL(string: "http://127.0.0.1:8000/store/orders") else { fatalError("Missing URL store orders()") }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Order].self, from: data)
    }

    func fetchData() {
        
        guard let url = URL(string: "http://127.0.0.1:8000/stores") else { fatalError("link missing")}
        let urlRequest = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                
                do {
                    let stores = try JSONDecoder().decode([Store].self, from: data)
//                                            print("DEBUG: STORES _ \(stores)")
                    DispatchQueue.main.async {
                        self.stores = stores
                        self.isLoaded = true
                        print("DEBUG: STORES (SELF)")
                    }
                } catch let error {
                        print("Error decoding: ", error)
                    
                    }
            }
        }
        dataTask.resume()
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
}
