//
//  HGL_ContainView.swift
//  HGL_PageView_Example
//
//  Created by heiguoliangle on 2017/9/11.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

protocol HGL_ContainViewDelegate : class {

    func contentChange(_ containView : HGL_ContainView,titleTag : Int)
    func contentChange(_ containView : HGL_ContainView,targtIndex : Int , progress : CGFloat)
    
}

private let kCellKey = "cellKey"

class HGL_ContainView: UIView {
    
    weak var containDelegate : HGL_ContainViewDelegate?
    fileprivate var childVc : [UIViewController]
    fileprivate var startOffset : CGFloat = 0.0
    fileprivate var isClickTitleView : Bool = false
    
    fileprivate var parentVc : UIViewController
    fileprivate lazy var collectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCellKey)
        collection.dataSource = self
        collection.isPagingEnabled = true
        collection.delegate = self
        return collection
        
    }()
    
    
    init(frame: CGRect,childVc : [UIViewController],parentVc : UIViewController ) {
        self.childVc = childVc
        self.parentVc = parentVc
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
     // MARK: - 设置UI
    func setupUI() {
        
        for child in childVc {
            parentVc.addChildViewController(child)
        }
        addSubview(collectionView)
        
        
    }
    
    
    
}

extension HGL_ContainView : UICollectionViewDataSource,UICollectionViewDelegate{
    
     // MARK: - dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVc.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellKey, for: indexPath)
//        cell.backgroundColor = UIColor.randomColor()
        
        for  subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        
        
        let child = childVc[indexPath.item]
        child.view.frame = cell.contentView.frame; cell.contentView.addSubview(child.view)
        
        
        return cell
    }
     // MARK: - UICollectionViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
   
      
        guard startOffset != scrollView.contentOffset.x else {
            return
        }
        
        var progress : CGFloat = 0
        var targtIndex : Int = 0
        let currentIndex = Int( startOffset / scrollView.bounds.size.width)
        if startOffset < scrollView.contentOffset.x {
            
            targtIndex = currentIndex + 1
            if targtIndex > currentIndex + 1 {
                targtIndex = currentIndex + 1
            }
            
            progress = (scrollView.contentOffset.x - startOffset) / scrollView.bounds.size.width
            
        }else{
            targtIndex = currentIndex - 1
            if targtIndex < 0 {
                targtIndex = 0
            }
            
            progress = (startOffset - scrollView.contentOffset.x ) / scrollView.bounds.size.width
        }
        
//      print(progress)
        
        if isClickTitleView {
            containDelegate?.contentChange(self, targtIndex: targtIndex, progress: progress)
        }
        isClickTitleView = true
    }
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        startOffset = scrollView.contentOffset.x
        
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollView.isUserInteractionEnabled = false
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentChange()
        scrollView.isUserInteractionEnabled = true
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate {
            contentChange()
        }
//        scrollView.isUserInteractionEnabled = false
        
        
    }
    
    private func contentChange () {
        let currentIndex = Int(collectionView.contentOffset.x / collectionView.bounds.size.width)
        containDelegate?.contentChange(self, titleTag: currentIndex)
    }
    
    
    
    
}

 // MARK: - titleView 代理
extension HGL_ContainView : HGL_TitleViewDelegate {
    func titleView(_ titleView: HGL_TitleView, targtIndex: Int) {
        
        isClickTitleView = false
        collectionView.scrollToItem(at:         IndexPath(item: targtIndex, section: 0), at: .left, animated: false)
    }
}
