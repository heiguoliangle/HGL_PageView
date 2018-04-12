


//
//  HGL_PageView.swift
//  HGL_PageView_Example
//
//  Created by heiguoliangle on 2017/9/11.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

public protocol HGL_PageViewDelegate : class {
    func pageViewGetIndex(_ pageView : HGL_PageView,targtIndex : Int)
}

public class HGL_PageView: UIView {
    
    public weak var pageViewDelegate : HGL_PageViewDelegate?
    public var titles : [String] {
        didSet{
            setupTitleView()
        }
    }
    public var childVCs : [UIViewController] {
        didSet {
            setupContainView()
        }
    }
    public var currentIndex : Int = 0 {
        didSet {
            pageViewDelegate?.pageViewGetIndex(self, targtIndex: currentIndex)
        }
    }
    fileprivate var parentVC : UIViewController
    fileprivate var titleStyle : HGL_TitleViewStyle
    fileprivate var titleView : HGL_TitleView!
    fileprivate var containView : HGL_ContainView!
    
    public init(frame: CGRect,titles:[String],titleStyle : HGL_TitleViewStyle,childVCs:[UIViewController],parentVC:UIViewController) {
        self.titles = titles
        self.childVCs = childVCs
        self.titleStyle = titleStyle
        self.parentVC = parentVC
        super.init(frame: frame)
        setupUI()
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置UI
extension HGL_PageView{
    fileprivate func setupUI(){
        setupTitleView()
        setupContainView()
    }
    
    fileprivate func setupTitleView(){
        for chilren in self.subviews {
            if chilren is HGL_TitleView {
                chilren.removeFromSuperview()
            }
        }
        
        let frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: titleStyle.titleViewHeight)
        titleView = HGL_TitleView(frame: frame, titles: titles, titleStyle: titleStyle, parentVC: parentVC)
        addSubview(titleView)
        titleView.backgroundColor = titleStyle.titleViewNormalColor
        titleView.getCurrentIndex = { index in
            self.currentIndex = index
        }
        
        let lineView = UIView()
        lineView.frame = CGRect(x: 0, y: titleStyle.titleViewHeight - 0.4, width: bounds.size.width, height: 0.3)
        lineView.backgroundColor = UIColor(0x333333)
        addSubview(lineView)
        
    }
    

    
    fileprivate func setupContainView(){
        for chilren in self.subviews {
            if chilren is HGL_ContainView {
                chilren.removeFromSuperview()
            }
        }
        
        let frame = CGRect(x: 0, y: titleView.frame.size.height, width: bounds.width, height: bounds.height - titleView.frame.size.height)
        containView = HGL_ContainView(frame: frame, childVc: childVCs, parentVc: parentVC)
        addSubview(containView)
        containView.backgroundColor = titleStyle.containViewNormalColor
        titleView.delegate = containView
        containView.containDelegate = titleView
        
    }
}

extension UIColor {
    convenience init(_ hex:Int, _ alpha:CGFloat = 1){
        self.init(red: CGFloat(((hex & 0xFF0000) >> 16))/255.0, green: CGFloat(((hex & 0xFF00) >> 8))/255.0, blue: CGFloat(((hex & 0xFF)))/255.0, alpha: alpha)
    }
}
