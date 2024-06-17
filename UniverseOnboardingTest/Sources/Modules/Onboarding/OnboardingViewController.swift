//
//  OnboardingViewController.swift
//  UniverseOnboardingTest
//
//  Created by Volodymyr Pysarenko on 05.06.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class OnboardingViewController: UIViewController {
    
    private enum Constants {
        static let cellHeight: CGFloat = 52
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel = OnboardingViewModel()
    
    lazy var mainView: OnboardingView = {
        var view = OnboardingView()
        return view
    }()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupUI()
        setupButtonAction()
        configureCollectionView()
    }
    
    private func setupUI() {
        updateButtonState()
        setupInitialButtonState()
    }
    
    private func setupInitialButtonState() {
        viewModel.selectedCellIndex.onNext(nil)
    }
    
    private func updateButtonState() {
        viewModel.selectedCellIndex
            .subscribe (onNext: { [weak self] index in
                guard let self else { return }
                mainView.continueButton.backgroundColor = index != nil ? .buttonBlack : .white
                mainView.continueButton.setTitleColor(index != nil ? .white : .inactiveGray, for: .normal)
                mainView.continueButton.isEnabled = index != nil
            })
            .disposed(by: disposeBag)
    }
    
    private func setupButtonAction() {
        mainView.continueButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                nextButtonTapped()
            })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        viewModel.currentPageData
            .subscribe(onNext: { [weak self] (onboardingModels) in
                guard let self = self else { return }
                mainView.pageNameLabel.text = onboardingModels?.question
            }, onError: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    private func nextButtonTapped() {
        guard let currentPageIndex = viewModel.pageIndex.value else { return }
        let maxNumberOfPages = viewModel.dataArray.count - 1
        
        if maxNumberOfPages > currentPageIndex {
            viewModel.pageIndex.accept(currentPageIndex + 1)
            viewModel.selectedCellIndex.onNext(nil)
        } else if maxNumberOfPages == currentPageIndex {
            let paywallVC = PaywallViewController()
            paywallVC.modalPresentationStyle = .overCurrentContext
            paywallVC.modalTransitionStyle = .coverVertical
            present(paywallVC, animated: true)
        } else if viewModel.dataArray.count == 0 {
            print("No models")
        }
    }
}

extension OnboardingViewController {
    func configureCollectionView() {
        
        mainView.onbCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.currentAnswers
            .bind(to: mainView.onbCollectionView.rx.items(cellIdentifier: "OnboardingCollectionViewCell", cellType: OnboardingCollectionViewCell.self)) { index, element, cell in
                cell.titleLabel.text = element.text
                cell.backgroundColor = element.isSelected ? .cellGreen : .white
                cell.titleLabel.textColor = element.isSelected ? .white : .blackFont
            }
            .disposed(by: disposeBag)
        
        mainView.onbCollectionView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.selectedCellIndex)
            .disposed(by: disposeBag)
    }
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height: CGFloat = Constants.cellHeight
        let width: CGFloat = (collectionView.bounds.width)
        return CGSize(width: width, height: height)
    }
}
