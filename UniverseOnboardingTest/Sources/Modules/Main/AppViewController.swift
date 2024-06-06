//
//  ViewController.swift
//  UniverseOnboardingTest
//
//  Created by Volodymyr Pysarenko on 05.06.2024.
//

import UIKit

final class AppViewController: UIViewController {
    
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
    }
    
    private func checkInApp() {
        let unsubscribedImage = UIImage(systemName: "multiply.square")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        let subscribedImage = UIImage(systemName: "checkmark.square")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        
        if isSubscribed {
            mainView.imageView.image = subscribedImage
            mainView.label.text = MainAppScreenTxt.subscribed
        } else {
            mainView.imageView.image = unsubscribedImage
            mainView.label.text = MainAppScreenTxt.unSubscribed
        }
    }
}

