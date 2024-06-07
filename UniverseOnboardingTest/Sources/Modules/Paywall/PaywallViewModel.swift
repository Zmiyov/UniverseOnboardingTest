//
//  PaywallViewModel.swift
//  UniverseOnboardingTest
//
//  Created by Volodymyr Pysarenko on 07.06.2024.
//

import Foundation
import RxSwift
import RxCocoa

final class PaywallViewModel {
    
    private var purchaseManager = PurchaseManager.shared
    var currentPrice = BehaviorRelay<String>(value: "$6.99")
    
    init() {
        loadProducts()
    }
    
    private func loadProducts() {
        Task {
            do {
                try await purchaseManager.loadProducts()
                if let mainSubProduct = purchaseManager.products.first(where: { $0.id == PurchaseProductID.main.rawValue }) {
                    currentPrice.accept(mainSubProduct.displayPrice)
                }
            } catch {
                print(error)
            }
        }
    }
}
