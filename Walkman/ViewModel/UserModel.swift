//
//  UserModel.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/3/23.
//

import Foundation
//import Combine

class AppViewModel: ObservableObject {
    @Published var signedIn = false
    @Published var user: User?
    @Published var nearbyDrivers: [Driver]?
    var uid: String?
    @Published var isLoading: Bool = true
    
    var isSignedIn: Bool {
        return user != nil
    }
    
    struct Response: Codable {
        let success: Bool
        let user: User
    //    let user: User
    }
    
    struct DriverResponse: Codable {
        let success: Bool
        let error: String?
    }
    
    func fetchUser() async throws -> User {
        guard let url = URL(string: "http://127.0.0.1:8000/user") else { fatalError("Missing URL") }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(User.self, from: data)
    }
    
    func getUser() {
        print("DEBUG: getUser() start")
        guard let url = URL(string: "http://127.0.0.1:8000/user") else { fatalError("Missing URL") }
        
        let urlRequest = URLRequest(url: url)
        DispatchQueue.main.async {
            self.isLoading = true
        }
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                
                    do {
                        let decodedUser = try JSONDecoder().decode(User.self, from: data)
                        print("DEBUG: USER - \(decodedUser)")
                        DispatchQueue.main.async {
                            
                            self.user = decodedUser
                            self.signedIn = true
                            self.isLoading = false
                        }
                    } catch let error {
                        DispatchQueue.main.async {
                            self.isLoading = false
                        }
                        print("Error decoding: ", error)
                    
                    }
                }
        }
        
        dataTask.resume()
    }
    
    
    
    func login(email: String = "pfo@gmail.com", password: String = "abc1234") {

        // create the request
        let url = URL(string: "http://127.0.0.1:8000/user/login")!
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
//                    self.user = response.user
                    self.isLoading = false
                }

            } else {
                print("DEBUG: Failed to login")
            }
        } catch {
            print("DEBUG: failed to login \(error.localizedDescription)")
        }
    }

       
    func register(user: User) {
        
        // create the request
        let url = URL(string: "http://127.0.0.1:8000/user/register")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let jsonEncoder = JSONEncoder()
        let userData = try! jsonEncoder.encode(user)
        request.httpBody = userData
        
        // perform the request
        do {
            let data = try performRequest(request)
            
            // parse the response
            let response = try JSONDecoder().decode(Response.self, from: data)
            if response.success {
                // registration successful, navigate to home view
                DispatchQueue.main.async {
                    self.signedIn = true
                    self.user = response.user
                    
                }
                
            } else {
                print("DEBUG: Error signing in")
            }
        } catch {
            print("DEBUG: Something went wrong performing register() regquest \(error.localizedDescription)")
        }
    }
    
    func registerDriver(driver: Driver) {
        let url = URL(string: "http://127.0.0.1:8000/driver/register")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        // create the JSON payload
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        
        let driverData = try! jsonEncoder.encode(driver)

        print("DEBUG: JSONSerialization Data \(driverData)")
        request.httpBody = driverData
        print("DEBUG: Set httpBody")
        
        // perform the request
        do {
            let data = try performRequest(request)
            
            // parse the response
            print("ERROR CHECK: ")
            let response = try JSONDecoder().decode(DriverResponse.self, from: data)
            
            if response.success {
                // registration successful, navigate to home view
                DispatchQueue.main.async {
//                    self.signedIn = true
                    print("DEBUG: Successfully inserted")
                }
                
            } else {
                print("DEBUG: Error signing in")
            }
        } catch {
            print("DEBUG: Something went wrong performing registerDriver() request \(error)")
        }
    }
    
    func registerStore(store: Store) {
        let url = URL(string: "http://127.0.0.1:8000/store/register")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        // create the JSON payload
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        
        let storeData = try! jsonEncoder.encode(store)

        print("DEBUG: JSONSerialization Data \(storeData)")
        request.httpBody = storeData
        print("DEBUG: Set httpBody")
        
        // perform the request
        do {
            let data = try performRequest(request)
            
            // parse the response
            print("ERROR CHECK: ")
            let response = try JSONDecoder().decode(DriverResponse.self, from: data)
            
            if response.success {
                // registration successful, navigate to home view
                DispatchQueue.main.async {
//                    self.signedIn = true
                    print("DEBUG: Successfully inserted Store")
                }
                
            } else {
                print("DEBUG: Error signing in")
            }
        } catch {
            print("DEBUG: Something went wrong performing registerDriver() request \(error)")
        }
    }
    
    
    
//    func signOut() {
//        try? auth.signOut()
//        self.signedIn = false
//    }
    
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

