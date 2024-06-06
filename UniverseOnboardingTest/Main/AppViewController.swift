//
//  ViewController.swift
//  UniverseOnboardingTest
//
//  Created by Volodymyr Pysarenko on 05.06.2024.
//

import UIKit

class AppViewController: UIViewController {
    
    lazy var mainView: AppMainView = {
        var view = AppMainView()
        return view
    }()
    
    var isSubscribed: Bool {
        PurchaseManager.shared.hasUnlockedPro
    }
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        checkInApp()
        showPaywall(animated: false)
        setupButton()
    }

    private func showPaywall(animated: Bool) {
        guard !isSubscribed else { return }
        let paywallVC = PaywallViewController()
        paywallVC.modalPresentationStyle = .overCurrentContext
        paywallVC.modalTransitionStyle = .coverVertical
        present(paywallVC, animated: animated)
    }
    
    private func checkInApp() {
        let unsubscribedImage = UIImage(systemName: "multiply.square")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        let subscribedImage = UIImage(systemName: "checkmark.square")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        
        if isSubscribed {
            mainView.imageView.image = subscribedImage
        } else {
            mainView.imageView.image = unsubscribedImage
        }
    }
    
    private func setupButton() {
        let subButtonAction = UIAction { [weak self] act in
            guard let self else { return }
            showPaywall(animated: true)
        }
        mainView.subButton.addAction(subButtonAction, for: .touchUpInside)
    }
}

