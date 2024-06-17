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
    
    var pageIndex = BehaviorRelay<Int?>(value: nil)
    var selectedCellIndex = PublishSubject<Int?>()
    
    var dataArray = [OnboardingModel]()
    var currentPageData = BehaviorRelay<OnboardingModel?>(value: nil)
    var currentAnswers = BehaviorRelay<[Answer]>(value: [])
    
    init() {
        fetchData()
        fetchCurrentPageData()
        updateSelectedAnswer()
    }
    
    private func fetchData() {
        networkService.fetchData(from: Endpoints.onboarding.rawValue)
            .subscribe(onNext: { [weak self] (onboardingModels: OnboardingModelContainer) in
                guard let self else { return }
                dataArray = onboardingModels.items
                pageIndex.accept(0)
            }, onError: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchCurrentPageData() {
        pageIndex
            .subscribe(onNext: { [weak self] index in
                guard let self else { return }
                guard let index else { return }
                currentPageData.accept(dataArray[index])
                let stringAnswers = dataArray[index].answers
                let answersModelArray = stringAnswers.map{ Answer(text: $0) }
                currentAnswers.accept(answersModelArray)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateSelectedAnswer() {
        selectedCellIndex
            .subscribe(onNext: { [weak self] index in
                guard let self else { return }
                guard let index else { return }
                var currentAnswers = self.currentAnswers.value
                currentAnswers[index].isSelected = true
                self.currentAnswers.accept(currentAnswers)
            })
            .disposed(by: disposeBag)
    }
}
