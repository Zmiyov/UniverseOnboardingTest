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
    
    //MARK: - SK1 -
    let bag = DisposeBag()
    var products = BehaviorRelay<[SKProduct]>(value: [])
    private var monthlyPriceLabel: String = "$6.99"
    
    //MARK: - SK2 manager -
    
    private var purchaseManager = PurchaseManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
//        addObservers()
//        fetchProducts()
        
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
            print("Close paywall")
            dismiss(animated: true)
        }
        mainView.closeButton.addAction(closeAction, for: .touchUpInside)
        
        let buyAction = UIAction { [weak self] action in
            guard let self else { return }
            print("Buy subscription")
//            purchase(product: .main)
            
            if let mainSubProduct = purchaseManager.products.first(where: { $0.displayName == PurchaseDisplayName.main.rawValue }) {
                
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

//MARK: - SK1 -
extension PaywallViewController {
    
    private func addObservers() {
        products
            .asObservable()
            .subscribe{ _ in
                let products = self.products.value
                guard let main = products
                    .first(where: {$0.productIdentifier == PurchaseProductID.main.rawValue})
                else { return }
                
                DispatchQueue.main.async {
                    let currency = main.priceLocale.currency?.identifier ?? ""
                    
                    let monthlyPrice = main.price.decimalValue
                    self.monthlyPriceLabel = "\(currency) \(monthlyPrice)"
                    self.setPriceInLabel()
                }
            }.disposed(by: bag)
    }
}

extension PaywallViewController {
    
    private func fetchProducts() {
        
        InAppPurchaseHandler.shared.fetchAvailableProducts { (products) in
            self.products.accept(products)
        }
    }
    
    private func purchase(product: PurchaseProductID) {
        guard let _product = products.value.first(where: {$0.productIdentifier == product.rawValue}) else {
            print("Product: \(product.rawValue) not found in Products Set")
            return
        }
        
        startLoading()
        
        InAppPurchaseHandler.shared.purchase(product: _product) { (message, product, transaction) in
            self.stopLoading()
            
            if let transaction = transaction, let product = product {
                print("Transaction : \(transaction)")
                print("Product: \(product.productIdentifier)")
                
                if transaction.error == nil {
                    if transaction.transactionState == .purchased {
                        let alert = UIAlertController(title: "Purchased", message: "The main subscription is purchased.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {_ in
                            self.dismiss(animated: true)
                        })
                        self.present(alert, animated: true, completion: nil)
                    } else if transaction.transactionState == .failed {
                        let alert = UIAlertController(title: "Error", message: "The main subscription is failed.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    let alert = UIAlertController(title: "Error", message: "The main subscription is failed.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
