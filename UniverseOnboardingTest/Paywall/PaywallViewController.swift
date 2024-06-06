//
//  PaywallViewController.swift
//  UniverseOnboardingTest
//
//  Created by Vladimir Pisarenko on 05.06.2024.
//

import UIKit
import StoreKit
import RxRelay
import RxSwift

class PaywallViewController: UIViewController {
    
    lazy var mainView: PaywallView = {
        var view = PaywallView()
        return view
    }()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    private var monthlyPriceLabel: String = "$6.99"
    
    //MARK: - SK2 manager -
    
    private var purchaseManager = PurchaseManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        Task {
            do {
                try await purchaseManager.loadProducts()
            } catch {
                print(error)
            }
        }
    }
    
    private func setupUI() {
        setupButton()
        setPriceInLabel()
    }
    
    private func setupButton() {
        let closeAction = UIAction { [weak self] action in
            guard let self else { return }
            dismiss(animated: true)
        }
        mainView.closeButton.addAction(closeAction, for: .touchUpInside)
        
        let buyAction = UIAction { [weak self] action in
            guard let self else { return }
            
            if let mainSubProduct = purchaseManager.products.first(where: { $0.id == PurchaseProductID.main.rawValue }) {
                
                Task {
                    do {
                        try await self.purchaseManager.purchase(mainSubProduct)
                    } catch {
                        print(error)
                    }
                }
            }
        }
        mainView.startButton.addAction(buyAction, for: .touchUpInside)
    }
    
    private func setPriceInLabel() {
        mainView.setupAttributedLabel(price: self.monthlyPriceLabel)
    }
    
    private func startLoading() {
        mainView.indicator.isHidden = false
        mainView.indicator.startAnimating()
    }
    
    private func stopLoading() {
        mainView.indicator.stopAnimating()
    }
}

