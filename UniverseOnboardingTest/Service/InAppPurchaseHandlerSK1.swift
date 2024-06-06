//
//  InAppPurchaseHandler.swift
//  UniverseOnboardingTest
//
//  Created by Vladimir Pisarenko on 06.06.2024.
//

import StoreKit

enum InAppPurchaseMessages: String {
    case purchased = "You payment has been successfully processed."
    case failed = "Failed to process the payment."
}

enum PurchaseProductID: String, CaseIterable {
    case main = "mainSub"
}

class InAppPurchaseHandler: NSObject {
    static let shared = InAppPurchaseHandler()
    
    fileprivate var productIds = PurchaseProductID.allCases.map(\.rawValue)
    fileprivate var productID = ""
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var productToPurchase: SKProduct?
    fileprivate var fetchProductcompletion: (([SKProduct]) -> Void)?
    fileprivate var purchaseProductcompletion: ((String, SKProduct?, SKPaymentTransaction?)->Void)?
    
    private func canMakePurchases() -> Bool {
        SKPaymentQueue.canMakePayments()
    }
}

extension InAppPurchaseHandler {
    func purchase(product: SKProduct, completion: @escaping ((String, SKProduct?, SKPaymentTransaction?)->Void)) {
        purchaseProductcompletion = completion
        productToPurchase = product
        
        if canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            productID = product.productIdentifier
        } else {
            completion("In app purchases are disabled", nil, nil)
        }
    }
    
    func fetchAvailableProducts(completion: @escaping (([SKProduct]) -> Void)){
        fetchProductcompletion = completion
        
        if productIds.isEmpty {
            fatalError("Product Ids are not found")
        } else {
            productsRequest = SKProductsRequest(productIdentifiers: Set(productIds))
            productsRequest.delegate = self
            productsRequest.start()
        }
    }
}

extension InAppPurchaseHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    func productsRequest (_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count > 0, let completion = fetchProductcompletion {
            completion(response.products)
        } else {
            print("Invalid Product Identifiers: \(response.invalidProductIdentifiers)")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .failed:
                print("Product purchase failed")
                SKPaymentQueue.default().finishTransaction(transaction)
                
                if let completion = purchaseProductcompletion {
                    completion(InAppPurchaseMessages.failed.rawValue, nil, nil)
                }
                break
            case .purchased:
                print("Product purchase done")
                SKPaymentQueue.default().finishTransaction(transaction)
                
                if let completion = purchaseProductcompletion {
                    completion(InAppPurchaseMessages.purchased.rawValue, productToPurchase, transaction)
                }
                break
            default:
                print(transaction.error?.localizedDescription ?? "Something went wrong")
                break
            }
        }
    }
}
