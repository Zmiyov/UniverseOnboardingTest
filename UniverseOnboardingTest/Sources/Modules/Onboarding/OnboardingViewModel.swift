//
//  OnboardingViewModel.swift
//  UniverseOnboardingTest
//
//  Created by Volodymyr Pysarenko on 07.06.2024.
//

import Foundation
import RxSwift
import RxCocoa

final class OnboardingViewModel {
    
    private let disposeBag = DisposeBag()
    private let networkService = NetworkService.shared
    
    var pageIndex: Int = 0 {
        didSet {
            fetchCurrentPageData(index: pageIndex)
        }
    }
    var selectedCellIndex: Int?
    
    var dataArray = [OnboardingModel]()
    var currentPageData = BehaviorRelay<OnboardingModel?>(value: nil)
    var currentAnswers = BehaviorRelay<[String]>(value: [])
    
    init() {
        fetchData()
    }
    
    private func fetchData() {
        networkService.fetchData(from: Endpoints.onboarding.rawValue)
            .subscribe(onNext: { [weak self] (onboardingModels: OnboardingModelContainer) in
                guard let self else { return }
                dataArray = onboardingModels.items
                fetchCurrentPageData(index: pageIndex)
            }, onError: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchCurrentPageData(index: Int) {
        currentPageData.accept(dataArray[index])
        currentAnswers.accept(dataArray[index].answers)
    }
}
