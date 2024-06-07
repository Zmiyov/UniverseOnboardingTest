//
//  AppMainViewModel.swift
//  UniverseOnboardingTest
//
//  Created by Volodymyr Pysarenko on 07.06.2024.
//

import Foundation

final class AppMainViewModel {
    var isSubscribed: Bool {
        PurchaseManager.shared.hasUnlockedPro
    }
}
