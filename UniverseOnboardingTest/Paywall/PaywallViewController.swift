//
//  PaywallViewController.swift
//  UniverseOnboardingTest
//
//  Created by Volodymyr Pysarenko on 05.06.2024.
//

import UIKit
import StoreKit

final class PaywallViewController: UIViewController {
    
    lazy var mainView: PaywallView = {
        var view = PaywallView()
        return view
    }()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    private var monthlyPriceLabel: String = "$6.99" {
        didSet { setPriceInLabel(price: self.monthlyPriceLabel) }
    }
    
    //MARK: - SK2 manager -
    
    private var purchaseManager = PurchaseManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadProducts()
    }
    
    private func setupUI() {
        setupButton()
        setPriceInLabel(price: self.monthlyPriceLabel)
    }
    
    private func setupButton() {
        let closeAction = UIAction { [weak self] action in
            guard let self else { return }
            dismiss(animated: true) 
//            SceneDelegate.shared?.presentMainApp()
        }
        mainView.closeButton.addAction(closeAction, for: .touchUpInside)
        
        let buyAction = UIAction { [weak self] action in
            guard let self else { return }
            
            if let mainSubProduct = purchaseManager.products.first(where: { $0.id == PurchaseProductID.main.rawValue }) {
                
                Task {
                    do {
                        let result = try await self.purchaseManager.purchase(mainSubProduct)
                        if result {
//                            self.dismiss(animated: true) {
//                                SceneDelegate.shared?.presentMainApp()
//                            }
                            SceneDelegate.shared?.presentMainApp()
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
        mainView.startButton.addAction(buyAction, for: .touchUpInside)
    }
    
    private func setPriceInLabel(price: String) {
        mainView.setupAttributedLabel(price: price)
    }
    
    private func startLoading() {
        mainView.indicator.isHidden = false
        mainView.indicator.startAnimating()
    }
    
    private func stopLoading() {
        mainView.indicator.stopAnimating()
    }
    
    private func loadProducts(){
        Task {
            do {
                try await purchaseManager.loadProducts()
                if let mainSubProduct = purchaseManager.products.first(where: { $0.id == PurchaseProductID.main.rawValue }) {
                    self.monthlyPriceLabel = mainSubProduct.displayPrice
                }
            } catch {
                print(error)
            }
        }
    }
}
