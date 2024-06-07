//
//  OnboardingViewModel.swift
//  UniverseOnboardingTest
//
//  Created by Volodymyr Pysarenko on 07.06.2024.
//

import Foundation
import RxSwift

final class OnboardingViewModel {
    
    private let disposeBag = DisposeBag()
    private let networkService = NetworkService.shared
    
    var dataArraySubject = BehaviorSubject<[OnboardingModel]>(value: [])
    
    init() {
        fetchData()
    }
    
    private func fetchData() {
        networkService.fetchData(from: Endpoints.onboarding.rawValue)
            .subscribe(onNext: { [weak self] (onboardingModels: OnboardingModelContainer) in
                guard let self = self else { return }
                dataArraySubject = BehaviorSubject(value: onboardingModels.items)
            }, onError: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
