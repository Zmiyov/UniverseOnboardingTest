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
    private var models: [OnboardingModel]?
    private var pageIndex: Int = 0
    private var selectedCellIndex: Int?
    
    lazy var mainView: OnboardingView = {
        var view = OnboardingView()
        view.onbCollectionView.dataSource = self
        view.onbCollectionView.delegate = self
        return view
    }()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    private func setupUI() {
        continueButtonState()
        setupButtonAction()
    }
    
    private func continueButtonState() {
        if selectedCellIndex != nil  {
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
        viewModel.dataArraySubject
            .subscribe(onNext: { [weak self] (onboardingModels) in
                guard let self = self else { return }
                models = onboardingModels
                updatePage()
            }, onError: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    private func updatePage() {
        if let models {
            mainView.pageNameLabel.text = models[pageIndex].question
            mainView.onbCollectionView.reloadData()
        }
    }
    
    private func openNextPage() {
        selectedCellIndex = nil
        continueButtonState()
        updatePage()
    }
    
    private func nextButtonTapped() {
        guard let models else { return }
        if models.count - 1 > pageIndex {
            pageIndex += 1
            openNextPage()
        } else if models.count - 1 == pageIndex {
            //Open Paywall
            let paywallVC = PaywallViewController()
            paywallVC.modalPresentationStyle = .overCurrentContext
            paywallVC.modalTransitionStyle = .coverVertical
            present(paywallVC, animated: true)
        } else if models.count == 0 {
            print("No models")
        }
    }
}

extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let models {
            return models[pageIndex].answers.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OnboardingCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        
        if let models {
            cell.titleLabel.text = models[pageIndex].answers[indexPath.item]
        }
        
        cell.backgroundColor = indexPath.item == selectedCellIndex ? .cellGreen : .white
        cell.titleLabel.textColor = indexPath.item == selectedCellIndex ? .white : .blackFont
        
        return cell
    }
}

extension OnboardingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCellIndex = indexPath.item
        collectionView.reloadData()
        continueButtonState()
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
