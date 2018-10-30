//
//  PQSwipeMenuController.swift
//  PQSwipeMenu
//
//  Created by 盘国权 on 2018/10/14.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit

public extension UIViewController {
    public var navHeight: CGFloat {
        let statusHeight = UIApplication.shared.statusBarFrame.height
        let navHeight = navigationController?.navigationBar.frame.height ?? 0
        return statusHeight + navHeight
    }
    
    public var tabBarHeight: CGFloat  {
        return tabBarController?.tabBar.frame.height ?? 0
    }
}

@objc public protocol PQSwipeMenuControllerDelegate: NSObjectProtocol {
    @objc func swipeMenuTitle(_ controller: PQSwipeMenuController, index: Int, child: UIViewController) -> String?
    @objc optional func swipeMenuSelected(_ controller: PQSwipeMenuController, index: Int, child: UIViewController)
    @objc optional func swipeMenuRepeatSelected(_ controller: PQSwipeMenuController, index: Int, child: UIViewController)
}

open class PQSwipeMenuController: UIViewController {
    
    public struct PQSwipeMenuOptions {
        /// default white
        public var titleColor: UIColor
        /// default orange
        public var titleSelectedColor: UIColor
        /// default systemFont(ofSize: 15)
        public var titleFont: UIFont
        /// center
        public var titleAlignment: NSTextAlignment
        /// title view height default 40
        public var titleHeight: CGFloat
        /// title spacing default 0
        public var titleSpacing: CGFloat
        /// line color default white
        public var lineColor: UIColor
        /// line height 2
        public var lineHeight: CGFloat
        
        
        public static func `default`() -> PQSwipeMenuOptions {
            return PQSwipeMenuOptions(titleColor: .white, titleSelectedColor: .orange, titleFont: UIFont.systemFont(ofSize: 15), titleAlignment: .center, titleHeight: 40, titleSpacing: 10, lineColor: .white, lineHeight: 2)
        }
    }

    // MARK: - public perproty
    /// 选中项
    open private(set) var currentIndex: Int = 0
    /// 代理
    public weak var swipeMenuDelegate: PQSwipeMenuControllerDelegate?
    /// options
    public var menuOptions = PQSwipeMenuOptions.default()
    /// default nil
    public var titleViewBackgroundColor: UIColor? {
        didSet {
            titleCollectionView.backgroundColor = titleViewBackgroundColor
        }
    }
    /// default nil
    public var contentViewBackgroundColor: UIColor? {
        didSet {
            contentCollectionView.backgroundColor = titleViewBackgroundColor
        }
    }
    
    // MARK: - system method
    override open func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
//    open override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        if titleCollectionView.frame == .zero {
//            let statusHeight = UIApplication.shared.statusBarFrame.height
//            let navHeight = navigationController?.navigationBar.frame.height ?? 0
//            let offsetY = statusHeight + navHeight
//            let width = view.frame.width
//            let height = view.frame.height
//            titleCollectionView.frame = CGRect(x: 0, y: offsetY, width: width, height: menuOptions.titleHeight)
//            let tabBarHeight = tabBarController?.view.frame.height ?? 0
//            let contentCollectionViewHeight = height - titleCollectionView.frame.maxY - tabBarHeight
//            contentCollectionView.frame = CGRect(x: 0, y: offsetY + menuOptions.titleHeight, width: width, height: contentCollectionViewHeight)
//        }
//    }
    
    // MARK: - private perproty
    private var titleCollectionView: UICollectionView!
    private var contentCollectionView: UICollectionView!
    private var lastCurrentIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    private var titleWidths: [IndexPath: CGSize] = [:]

}

// MARK: - public method
public extension PQSwipeMenuController {
    public func resetFrame(_ closure: () -> (titleViewFrame : CGRect, contentViewFrame: CGRect)) {
        let frames = closure()
        titleCollectionView.frame = frames.titleViewFrame
        contentCollectionView.frame = frames.contentViewFrame
    }
    
    public func updateCurrentIndex(_ index: Int) {
        currentIndex = index
        let currentIndexPath = IndexPath(item: currentIndex, section: 0)
        collectionView(titleCollectionView, didSelectItemAt: currentIndexPath)
    }
    
    public func reload() {
        titleCollectionView.reloadData()
        contentCollectionView.reloadData()
    }
    
    public func reload(index: Int) {
        if index < children.count && index >= 0 {
            let indexPath = IndexPath(item: index, section: 0)
            titleWidths.removeValue(forKey: indexPath)
            titleCollectionView.reloadItems(at: [indexPath])
            contentCollectionView.reloadItems(at: [indexPath])
        } else {
            print("Subscript out of range 下标不在范围内")
        }
    }
    
    public func removeChild(index: Int) {
        
        if index < children.count && index >= 0 {
            children[index].removeFromParent()
            let indexPath = IndexPath(item: index, section: 0)
            titleCollectionView.deleteItems(at: [indexPath])
            contentCollectionView.deleteItems(at: [indexPath])
            calculationCurrentIndex()
            //表示删除的是当前选中项
            if (indexPath.item - 1) == currentIndex {
                let currentIndexPath = IndexPath(item: currentIndex, section: 0)
                titleCollectionView.reloadItems(at: [currentIndexPath])
                lastCurrentIndexPath = currentIndexPath
            }
            
        } else {
            print("Subscript out of range 下标不在范围内")
        }
    }
    
    @discardableResult public func removeChild(_ childController: UIViewController) -> Bool {
        if let index = children.firstIndex(where: { $0 == childController }) {
            removeChild(index: index)
            return true
        } else {
            return false
        }
    }
    
    public func updateTitle(index: Int) {
        reload(index: index)
    }
    
    override open func addChild(_ childController: UIViewController) {
        super.addChild(childController)
        childController.didMove(toParent: self)
        let indexPath = IndexPath(item: children.count - 1, section: 0)
        titleCollectionView.insertItems(at: [indexPath])
        contentCollectionView.insertItems(at: [indexPath])
        
//        reload()
        
        currentIndex = children.count - 1
        let currentIndexPath = IndexPath(item: currentIndex, section: 0)
        // 选中最后一项
        collectionView(titleCollectionView, didSelectItemAt: currentIndexPath)
        
    }
}

// MARK: - private method
extension PQSwipeMenuController {
    private func setup() {
        titleCollectionView = UICollectionView(
            frame: CGRect(height: menuOptions.titleHeight),
            collectionViewLayout: UICollectionViewFlowLayout(interitemSpacing: menuOptions.titleSpacing),
            delegate: self,
            dataSource: self)
        titleCollectionView.register(PQSwipeMenuTitleCell.self, forCellWithReuseIdentifier: PQSwipeMenuTitleCell.identifier)
        contentCollectionView = UICollectionView(
            frame: CGRect(x: 0, y: menuOptions.titleHeight, width: view.frame.width, height: view.frame.height - menuOptions.titleHeight),
            collectionViewLayout: UICollectionViewFlowLayout(interitemSpacing: 0),
            delegate: self,
            dataSource: self)
        contentCollectionView.register(PQSwipeMenuContentCell.self, forCellWithReuseIdentifier: PQSwipeMenuContentCell.identifier)
        contentCollectionView.isPagingEnabled = true
        
        view.addSubview(titleCollectionView)
        view.addSubview(contentCollectionView)
        
        titleCollectionView.backgroundColor = .clear
        contentCollectionView.backgroundColor = .clear
    }
    
    private func calculationCurrentIndex() {
        currentIndex = (currentIndex == children.count) ? currentIndex - 1 : currentIndex
        currentIndex = (currentIndex < 0) ? 0 : currentIndex
    }
}

extension PQSwipeMenuController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return children.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case titleCollectionView:
            return titleCollectionCell(cellForItemAt: indexPath)
        case contentCollectionView:
            return contentCollectionCell(cellForItemAt: indexPath)
        default:
            fatalError("collectionView is not titleCollectionView or contentCollectionView")
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == titleCollectionView {
            
            if lastCurrentIndexPath == indexPath {
                swipeMenuDelegate?.swipeMenuRepeatSelected?(self, index: indexPath.item, child: children[indexPath.item])
                return
            }
            
            let indexPaths = [lastCurrentIndexPath, indexPath]
            contentCollectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.left, animated: false)
            currentIndex = indexPath.item
            titleCollectionView.reloadItems(at: indexPaths)
            lastCurrentIndexPath = indexPath
            
            titleCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            
            swipeMenuDelegate?.swipeMenuSelected?(self, index: indexPath.item, child: children[indexPath.item])
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case titleCollectionView:
            return titleCollectionCellSize(cellForItemAt: indexPath)
        case contentCollectionView:
            return contentCollectionCellSize(cellForItemAt: indexPath)
        default:
            fatalError("collectionView is not titleCollectionView or contentCollectionView")
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch scrollView {
        case contentCollectionView:
            let pageIndex = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
            if pageIndex == currentIndex {
                return
            }
            calculationCurrentIndex()
            let indexPath = IndexPath(item: pageIndex, section: 0)
            collectionView(titleCollectionView, didSelectItemAt: indexPath)
        default:
            break
        }
    }
    
    // MARK: - setup cell
    private func titleCollectionCell(cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = titleCollectionView.dequeueReusableCell(withReuseIdentifier: PQSwipeMenuTitleCell.identifier, for: indexPath) as! PQSwipeMenuTitleCell
        let title = swipeMenuDelegate?.swipeMenuTitle(self, index: indexPath.item, child: children[indexPath.item])
        cell.titleLabel.text = title
        let isCurrent = (self.currentIndex == indexPath.item)
        cell.titleLabel.textColor =  isCurrent ? menuOptions.titleSelectedColor : menuOptions.titleColor
        cell.titleLabel.font = menuOptions.titleFont
        cell.titleLabel.textAlignment = menuOptions.titleAlignment
        cell.lineColor = isCurrent ? menuOptions.lineColor : UIColor.clear
        cell.lineHeight = menuOptions.lineHeight
        return cell
    }
    
    private func contentCollectionCell(cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = contentCollectionView.dequeueReusableCell(withReuseIdentifier: PQSwipeMenuContentCell.identifier, for: indexPath) as! PQSwipeMenuContentCell
        let controller = children[indexPath.item]
        controller.view.frame = cell.contentView.bounds
        cell.contentView.subviews.forEach {
            $0.removeFromSuperview()
        }
//        if cell.contentView.subviews.count == 1 {
            cell.contentView.addSubview(controller.view)
//        }
        print("content subviews count:", cell.contentView.subviews.count)
        return cell
    }
    
    private func titleCollectionCellSize(cellForItemAt indexPath: IndexPath) -> CGSize {
        
//        if let size = titleWidths[indexPath] {
//            return size
//        }
        
        let title = swipeMenuDelegate?.swipeMenuTitle(self, index: indexPath.item, child: children[indexPath.item])
        if let title = title {
            let bound = (title as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : menuOptions.titleFont], context: nil)
            let size = CGSize(width: bound.width + 20, height: menuOptions.titleHeight)
            titleWidths[indexPath] = size
            return size
        }
        return CGSize(width: menuOptions.titleSpacing, height: menuOptions.titleHeight)
    }
    
    private func contentCollectionCellSize(cellForItemAt indexPath: IndexPath) -> CGSize {
        return contentCollectionView.frame.size
    }
}
