//
//  PQSwipeMenuTitleCell.swift
//  PQSwipeMenu
//
//  Created by 盘国权 on 2018/10/14.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit

class PQSwipeMenuTitleCell: UICollectionViewCell {
    var lineColor: UIColor = UIColor.clear {
        didSet {
            lineView.backgroundColor = lineColor
        }
    }
    
    var lineHeight: CGFloat = 2 {
        didSet {
            layoutViews()
        }
    }
    
    var titleLabel: UILabel = UILabel()
    var lineView: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func layoutViews() {
        let width = contentView.frame.width
        let height = contentView.frame.height
        titleLabel.frame = CGRect(x: 0, y: 0, width: width, height: height - lineHeight)
        lineView.frame = CGRect(x: 0, y: height - lineHeight, width: width, height: lineHeight)
    }
    
    private func setup() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(lineView)
    }
    
   
}
