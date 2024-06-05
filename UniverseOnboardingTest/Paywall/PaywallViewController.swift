//
//  PaywallViewController.swift
//  UniverseOnboardingTest
//
//  Created by Vladimir Pisarenko on 05.06.2024.
//

import UIKit

class PaywallViewController: UIViewController {
    
    lazy var mainView: PaywallView = {
        var view = PaywallView()
        return view
    }()
    
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
    }
    
    private func setupButton() {
        let closeAction = UIAction { [weak self] action in
            guard let self else { return }
            print("Close paywall")
            dismiss(animated: true)
        }
        mainView.closeButton.addAction(closeAction, for: .touchUpInside)
        
        let buyAction = UIAction { action in
            print("Buy subscription")
        }
        mainView.startButton.addAction(buyAction, for: .touchUpInside)
    }
}
