//
//  OnboardingModel.swift
//  UniverseOnboardingTest
//
//  Created by Vladimir Pisarenko on 05.06.2024.
//

import Foundation

struct OnboardingModelContainer: Codable {
    let items: [OnboardingModel]
}

struct OnboardingModel: Codable {
    let id: Int
    let question: String
    let answers: [String]
}
