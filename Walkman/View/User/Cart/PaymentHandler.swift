//
//  PaymentHandler.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/6/23.
//

import Foundation
import PassKit

typealias PaymentCompletionHandler = (Bool) -> Void


class PaymentHandler: NSObject {
    var paymentController: PKPaymentAuthorizationController?
    var paymentSummaryItems = [PKPaymentSummaryItem]()
    var paymentStatus = PKPaymentAuthorizationStatus.failure
    var completionHandler: PaymentCompletionHandler?
    
    var deliveryCost = 5.00
    
    static let supportedNetwork: [PKPaymentNetwork] = [
        .visa,
        .masterCard
    ]
    
    func shippingMethodCalculator() -> [PKShippingMethod] {
        let today = Date()
        let calendar = Calendar.current
        
        let shippingStart = calendar.date(byAdding: .day, value: 0, to: today)
        let shippingEnd = calendar.date(byAdding: .day, value: 1, to: today)
        
        if let shippingEnd = shippingEnd, let shippingStart = shippingStart {
            let startComponents = calendar.dateComponents([.calendar, .year, .month, .day], from: shippingStart)
            let endComponents = calendar.dateComponents([.calendar, .year, .month, .day], from: shippingEnd)
            
            let shippingDelivery = PKShippingMethod(label: "Delivery", amount: NSDecimalNumber(string: "\(deliveryCost)"))
            shippingDelivery.dateComponentsRange = PKDateComponentsRange(start: startComponents, end: endComponents)
            shippingDelivery.detail = "Food sent to your address"
            shippingDelivery.identifier = "DELIVERY"
            
            return [shippingDelivery]
        }
        return []
    }
    
    func startPayment(items: [Item], total: Float64, completion: @escaping PaymentCompletionHandler) {
        completionHandler = completion
        paymentSummaryItems = []
        
        items.forEach { item in
            let item = PKPaymentSummaryItem(label: item.name, amount: NSDecimalNumber(string: "\(item.price)"), type: .final)
            paymentSummaryItems.append(item)
        }
        
        let total = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(string: "\(total + deliveryCost)"), type: .final)
        paymentSummaryItems.append(total)
        
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = paymentSummaryItems
        paymentRequest.merchantIdentifier = "merchant.io.queue.walkmanapp"
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = "US"
        paymentRequest.currencyCode = "USD"
        paymentRequest.supportedNetworks = PaymentHandler.supportedNetwork
        paymentRequest.shippingType = .delivery
        paymentRequest.shippingMethods = shippingMethodCalculator()
        paymentRequest.requiredShippingContactFields = [.name, .phoneNumber, .postalAddress]
        
        paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentController?.delegate = self
        
        print(paymentRequest)
        
        paymentController?.present(completion: { (presented: Bool) in
            if presented {
                debugPrint("Presented Payment Controller")
            } else {
                debugPrint("Failed to present Payment Controller")
            }
        })
            
    }
}

extension PaymentHandler: PKPaymentAuthorizationControllerDelegate {
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            DispatchQueue.main.async {
                if self.paymentStatus == .success {
                    if let completionHandler = self.completionHandler {
                        completionHandler(true)
                    }
                    
                } else {
                    if let completionHandler = self.completionHandler {
                        completionHandler(false)
                    }
                }
            }
        }
    }
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        let errors = [Error]()
        let status = PKPaymentAuthorizationStatus.success
        
        self.paymentStatus = status
        completion(PKPaymentAuthorizationResult(status: status, errors: errors))
    }
    
}
