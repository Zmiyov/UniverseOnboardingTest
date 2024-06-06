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
    
    private var purchaseManager = PurchaseManager.shared
    private var monthlyPriceLabel: String = "$6.99" {
        didSet { setPriceInLabel(price: self.monthlyPriceLabel) }
    }
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
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
        }
        mainView.closeButton.addAction(closeAction, for: .touchUpInside)
        
        let buyAction = UIAction { [weak self] action in
            guard let self else { return }
            if let mainSubProduct = purchaseManager.products.first(where: { $0.id == PurchaseProductID.main.rawValue }) {
                Task {
                    do {
                        let result = try await self.purchaseManager.purchase(mainSubProduct)
                        if result {
                            self.showApp()
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
    
    private func showApp() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as? SceneDelegate,
              let window = sceneDelegate.window else { return }
        
        let appVC = AppViewController()
        let navigationController = UINavigationController(rootViewController: appVC)
        navigationController.isNavigationBarHidden = true
        window.rootViewController = navigationController
        
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.3
        UIView.transition(with: window, duration: duration, options: options, animations: {})
    }
}

extension PaywallViewController {
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
