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
            setConstraints()
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
    
    
    private func setup() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(lineView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        setConstraints()
    }
    
    private func setConstraints() {
        #if true
        let left = NSLayoutConstraint(
            item: titleLabel,
            attribute: .left,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .left,
            multiplier: 1,
            constant: 0)
        contentView.addConstraint(left)
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel
            , attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel
            , attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0))

        contentView.addConstraint(NSLayoutConstraint(item: titleLabel
            , attribute: .bottom, relatedBy: .equal, toItem: lineView, attribute: .top, multiplier: 1, constant: 0))


        contentView.addConstraint(NSLayoutConstraint(item: lineView
            , attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: lineView
            , attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: lineView
            , attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0))

        contentView.addConstraint(NSLayoutConstraint(item: lineView
            , attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: lineHeight))



        #else
        let viewDict:[String: UIView] = ["label":titleLabel, "line": lineView]
        let metricsDict = ["space":0]
        let labelHorizontalVFL = "H:|-[label]-|"
        let labelHorizontalContaraints = NSLayoutConstraint.constraints(withVisualFormat: labelHorizontalVFL, options: NSLayoutConstraint.FormatOptions.alignAllLeft, metrics: nil, views: viewDict)
        let lineHorizontalVFL = "H:|-[line]-|"
        let lineHorizontalContaraints = NSLayoutConstraint.constraints(withVisualFormat: lineHorizontalVFL, options: NSLayoutConstraint.FormatOptions.alignAllLeft, metrics: nil, views: viewDict)
        let verticalVFL = "V:|-[label]-[line(\(lineHeight))]-|"
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: verticalVFL, options: .directionLeadingToTrailing, metrics: nil, views: viewDict)
       

       contentView.addConstraints(labelHorizontalContaraints)
        contentView.addConstraints(lineHorizontalContaraints)
        contentView.addConstraints(verticalConstraints)
    #endif
    }
    
   
}
