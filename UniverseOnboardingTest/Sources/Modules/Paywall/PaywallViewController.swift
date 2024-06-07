//
//  PaywallViewController.swift
//  UniverseOnboardingTest
//
//  Created by Volodymyr Pysarenko on 05.06.2024.
//

import UIKit
import StoreKit
import RxSwift
import RxCocoa

final class PaywallViewController: UIViewController {
    
    lazy var mainView: PaywallView = {
        var view = PaywallView()
        return view
    }()
    
    private let viewModel = PaywallViewModel()
    
    private let disposeBag = DisposeBag()
    private var purchaseManager = PurchaseManager.shared
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupButton()
        setupPriceObserver()
    }
    
    private func setupButton() {
        mainView.closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.startButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                puchaseIAP()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupPriceObserver() {
        viewModel.currentPrice
            .subscribe(onNext: { [weak self] price in
                guard let self else { return }
                mainView.setupAttributedLabel(price: price)
            })
            .disposed(by: disposeBag)
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
    private func puchaseIAP() {
        guard let mainSubProduct = purchaseManager.products.first(where: { $0.id == PurchaseProductID.main.rawValue }) else { return }
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
