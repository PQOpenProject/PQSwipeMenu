//
//  CGRect.swift
//  PQSwipeMenu
//
//  Created by 盘国权 on 2018/10/14.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit

extension CGRect {
    init(height: CGFloat) {
        self.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height)
    }
}
