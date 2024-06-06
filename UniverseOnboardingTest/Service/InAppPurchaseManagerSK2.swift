//
//  InAppPurchaseManagerSK2.swift
//  UniverseOnboardingTest
//
//  Created by Volodymyr Pysarenko on 06.06.2024.
//

import StoreKit

enum PurchaseProductID: String, CaseIterable {
    case main = "mainSubID"
}

enum PurchaseDisplayName: String, CaseIterable {
    case mainSub = "mainSub"
}

class PurchaseManager {
    
    static let shared = PurchaseManager()
    
    private(set) var products: [Product] = []
    private(set) var purchasedProductIDs = Set<String>()
    private var productsLoaded = false
    
    var hasUnlockedPro: Bool {
        return !self.purchasedProductIDs.isEmpty
    }
    
    private var updates: Task<Void, Never>? = nil
    
    init() {
        updates = observeTransactionUpdates()
    }
    
    deinit {
        updates?.cancel()
    }
    
    func loadProducts() async throws {
        guard !self.productsLoaded else { return }
        let productIds: [String] = PurchaseProductID.allCases.map { $0.rawValue }
        self.products = try await Product.products(for: productIds)
        self.productsLoaded = true
    }
    
    func purchase(_ product: Product) async throws -> Bool {
        let result = try await product.purchase()
        
        switch result {
        case let .success(.verified(transaction)):
            // Successful purhcase
            await transaction.finish()
            await self.updatePurchasedProducts()
            return true
        case let .success(.unverified(_, error)):
            // Successful purchase but transaction/receipt can't be verified
            // Could be a jailbroken phone
            return false
        case .pending:
            // Transaction waiting on SCA (Strong Customer Authentication) or
            // approval from Ask to Buy
            return false
        case .userCancelled:
            // ^^^
            return false
        @unknown default:
            return false
        }
    }
    
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
    }
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await verificationResult in Transaction.updates {
                await self.updatePurchasedProducts()
            }
        }
    }
}

