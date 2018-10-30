//
//  PQSwipeMenuContentCell.swift
//  PQSwipeMenu
//
//  Created by 盘国权 on 2018/10/14.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit

class PQSwipeMenuContentCell: UICollectionViewCell {
    var contraintView: UIView = UIView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        contraintView.backgroundColor = UIColor.red
    }
    
    private func setup() {
        return
        contentView.addSubview(contraintView)
        contraintView.translatesAutoresizingMaskIntoConstraints = false
        setConstraints()
        
    }
    
    private func setConstraints() {
        contentView.addConstraint(NSLayoutConstraint(item: contraintView
            , attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: contraintView
            , attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: contraintView
            , attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: contraintView
            , attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0))
    }
}
