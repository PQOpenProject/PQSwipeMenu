//
//  ViewController.swift
//  PQSwipeMenu
//
//  Created by 盘国权 on 2018/10/14.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit
import PQSwipeMenu

class ViewController: PQSwipeMenuController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuOptions.titleColor = .gray
        menuOptions.titleSelectedColor = .white
        menuOptions.lineColor = .white
        menuOptions.lineHeight = 2
        self.swipeMenuDelegate = self
    }

    @IBAction func addChildBtnPress(_ sender: Any) {
        let vc = ListViewController.laodSB()
        vc.view.backgroundColor = UIColor(hue: CGFloat(arc4random() % 100) / 100.0, saturation: 1, brightness: 1, alpha: 1)
        self.addChild(vc)
        vc.didMove(toParent: self)
    }
    
    @IBAction func jump2BtnPress(_ sender: Any) {
//        updateCurrentIndex(2)
        let vc = ListViewController.laodSB()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func removeChildBtnPress(_ sender: Any) {
        
        removeChild(index: children.count - 1)
    }
}

extension ViewController: PQSwipeMenuControllerDelegate {
    func swipeMenuTitle(_ controller: PQSwipeMenuController, index: Int, child: UIViewController) -> String? {
        return "\(index)Title: \(arc4random() % 10000)"
    }
    
    func swipeMenuSelected(_ controller: PQSwipeMenuController, index: Int, child: UIViewController) {
        print("选中", index)
    }
    
    func swipeMenuRepeatSelected(_ controller: PQSwipeMenuController, index: Int, child: UIViewController) {
        print("重复选中", index)
    }
}

