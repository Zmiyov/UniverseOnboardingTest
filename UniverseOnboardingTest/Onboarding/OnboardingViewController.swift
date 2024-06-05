//
//  OnboardingViewController.swift
//  UniverseOnboardingTest
//
//  Created by Vladimir Pisarenko on 05.06.2024.
//

import UIKit

final class OnboardingViewController: UIViewController {

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
    }
    
    private func setupUI() {
        
        continueButtonState()
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
}

extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OnboardingCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
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

        let height: CGFloat = 52
        let width: CGFloat = (collectionView.bounds.width)
        return CGSize(width: width, height: height)
    }
}
