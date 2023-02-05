//
//  CartManager.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/3/23.
//

import Foundation
import Combine

class CartManager: ObservableObject {
    @Published var items = [Item]()
//    @Published var orders: [OrderDisplay] = []
    @Published var total: Float64 = 0
    @Published var taxes: Float64 = 0
    var deliveryFee: Float64 = 5.00
    
    let paymentHandler = PaymentHandler()
    @Published var paymentSuccess: Bool = false
    
    struct Response: Codable {
        let success: Bool
        let error: String?
        //    let user: User
    }
    
    func addToCart(item: Item) {
        //        self.paymentSuccess = false
        if self.items.count >= 1 {
            var count = 0
            for itm in self.items {
                if item.id == itm.id {
                    print("DEBUG: Item duplicate")
                    self.items[count].quantity += 1
                    self.total += item.price
                    print("TEST: TOTAL - \(self.total) | quantity - \(self.items[count].quantity)")
                    self.taxes = self.total * 0.025
                    
                    return
                }
                count += 1
            }
        }
        self.items.append(item)
        print("ADD ITEMS: \(self.items)")
        self.taxes = self.total * 0.025
        self.total += item.price
        print("DEBUG: \(self.total) | \(self.items.count)")
    }
    
    func increaseQuantity(item: Item) {
        for it in self.items.indices {
            if self.items[it].id == item.id {
                self.items[it].quantity += 1
                self.total += item.price
                return
            }
        }
    }
    
    func decreaseQuantity(item: Item) {
        for it in self.items.indices {
            if self.items[it].id == item.id {
                if self.items[it].quantity == 1 {
                    print("DEBUG QUANTITY is 1: \(item)")
                    self.items = self.items.filter{ $0.id != item.id }
                    self.total -= item.price
                    return
                }
                
                self.items[it].quantity -= 1
                self.total -= item.price
                self.taxes = self.total * 0.025
                return
            }
            print("DEBUG ITEMS: \(it)")
            print("DEBUG QUANTITY: \(item)")
        }
    }
    
    func removeFromCart(item: Item) {
        items = items.filter{ $0.id != item.id }
        total -= item.price * Double(item.quantity)
        
    }
    
    func getTotal() -> Int {
        return items.count
    }
    
    func pay(order: Order) {
        paymentHandler.startPayment(items: items, total: total) { success in
            if success {
                self.paymentSuccess = success
                self.createOrder(order: order)
                self.items = []
                self.total = 0
            }
        }
    }
    
    func createOrder(order: Order) {
        if self.paymentSuccess {
            guard let url = URL(string: "http://localhost:8000/order/insert") else { fatalError("DEBUG: Missing Order Insert URL")}
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            let jsonEncoder = JSONEncoder()
//            jsonEncoder.outputFormatting = .prettyPrinted
            // FIXME: Encoding different data type now, fix this in backend
            let orderData = try! jsonEncoder.encode(order)

            print("DEBUG: JSONSerialization Data \(orderData)")
            request.httpBody = orderData
            print("DEBUG: Set httpBody")
            // perform the request
            do {
                let data = try performRequest(request)
                
                // parse the response
                let response = try JSONDecoder().decode(Response.self, from: data)
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
                print("DEBUG: Something went wrong performing createOrder() regquest \(error.localizedDescription)")
            }
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

}
