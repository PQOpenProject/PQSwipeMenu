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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "添加", style: .plain, target: self, action: #selector(add))
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "随机删除", style: .plain, target: self, action: #selector(deleteTitle)), UIBarButtonItem(title: "随机更新", style: .plain, target: self, action: #selector(updateItem))]
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        resetFrame {
            let titleViewFrame = CGRect(x: 0, y: navHeight, width: view.frame.width, height: menuOptions.titleHeight)
            let contentViewFrame = CGRect(x: 0, y: titleViewFrame.maxY, width: titleViewFrame.width, height: view.frame.height - titleViewFrame.maxY - tabBarHeight)
            return (titleViewFrame: titleViewFrame,
                contentViewFrame: contentViewFrame)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for _ in 0...1 {
            add()
        }
    }
    
    @objc func add() {
        let vc = ListViewController.laodSB()
        vc.view.backgroundColor = UIColor(hue: CGFloat(arc4random() % 100) / 100.0, saturation: 1, brightness: 1, alpha: 1)
        self.addChild(vc)
    }

    @objc func deleteTitle() {
        let count = children.count
        if count == 0 { return }
        let index = Int(arc4random() % UInt32(count))
        removeChild(index: index)
    }
    
    @objc func updateItem() {
        let count = children.count
        if count == 0 { return }
        let index = Int(arc4random() % UInt32(count))
        children[index].title = "我是随机更新的"
        reload(index: index)
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
        let title = child.title ?? "\(index)Title: \(arc4random() % 10000)"
        return title
    }
    
    func swipeMenuSelected(_ controller: PQSwipeMenuController, index: Int, child: UIViewController) {
        print("选中", index)
    }
    
    func swipeMenuRepeatSelected(_ controller: PQSwipeMenuController, index: Int, child: UIViewController) {
        print("重复选中", index)
    }
}

