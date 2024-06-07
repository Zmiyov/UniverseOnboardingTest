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
        configureCollectionView()
    }
    
    private func setupUI() {
        continueButtonState()
        setupButtonAction()
    }
    
    private func continueButtonState() {
        if viewModel.selectedCellIndex != nil  {
            mainView.continueButton.backgroundColor = .buttonBlack
            mainView.continueButton.setTitleColor(.white, for: .normal)
        } else {
            mainView.continueButton.backgroundColor = .white
            mainView.continueButton.setTitleColor(.inactiveGray, for: .normal)
        }
    }
    
    private func setupButtonAction() {
        mainView.continueButton.rx.tap
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
    
    private func openNextPage() {
        viewModel.selectedCellIndex = nil
        continueButtonState()
    }
    
    private func nextButtonTapped() {
        if viewModel.dataArray.count - 1 > viewModel.pageIndex {
            viewModel.pageIndex += 1
            openNextPage()
        } else if viewModel.dataArray.count - 1 == viewModel.pageIndex {
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
            .bind(to: mainView.onbCollectionView.rx.items(cellIdentifier: "OnboardingCollectionViewCell", cellType: OnboardingCollectionViewCell.self)) { [weak self] index, element, cell in
                guard let self else { return }
                cell.titleLabel.text = element
                cell.backgroundColor = index == viewModel.selectedCellIndex ? .cellGreen : .white
                cell.titleLabel.textColor = index == viewModel.selectedCellIndex ? .white : .blackFont
            }
            .disposed(by: disposeBag)
        
        mainView.onbCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self else { return }
                viewModel.selectedCellIndex = indexPath.row
                mainView.onbCollectionView.reloadData()
                continueButtonState()
            })
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
