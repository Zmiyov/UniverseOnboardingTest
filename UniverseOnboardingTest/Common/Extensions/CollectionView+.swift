//
//  CollectionView+.swift
//  UniverseOnboardingTest
//
//  Created by Volodymyr Pysarenko on 05.06.2024.
//

import UIKit

extension UICollectionReusableView {
    static var reuseIdentifier: String { String(describing: self) }
}

extension UICollectionView {

    func register(_ cellClass: UICollectionViewCell.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T ?? T()
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: cellClass.reuseIdentifier, for: indexPath) as? T ?? T()
    }
}
