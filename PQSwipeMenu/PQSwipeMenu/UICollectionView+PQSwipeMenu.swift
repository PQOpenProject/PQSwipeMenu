//
//  UICollectionView.swift
//  PQSwipeMenu
//
//  Created by 盘国权 on 2018/10/14.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    static var identifier: String {
        return NSStringFromClass(self)
    }
}

extension UICollectionView {
    convenience init(frame: CGRect, collectionViewLayout: UICollectionViewFlowLayout, delegate: UICollectionViewDelegate?, dataSource: UICollectionViewDataSource?) {
        self.init(frame: frame, collectionViewLayout: collectionViewLayout)
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.delegate = delegate
        self.dataSource = dataSource
    }
}

extension UICollectionViewFlowLayout {
    convenience init(interitemSpacing: CGFloat) {
        self.init()
        self.scrollDirection = .horizontal
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = interitemSpacing
    }
}
