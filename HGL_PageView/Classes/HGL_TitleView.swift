//
//  HGL_TitleView.swift
//  HGL_PageView_Example
//
//  Created by heiguoliangle on 2017/9/11.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

protocol HGL_TitleViewDelegate : class {
    func titleView(_ titleView : HGL_TitleView,targtIndex : Int)
}
typealias GetCurrentIndex = (Int) -> ()
public class HGL_TitleView: UIView {
    
    weak var delegate : HGL_TitleViewDelegate?
    public var titles : [String]
    public var getCurrentIndex : ((Int) -> ())?
    fileprivate var parentVC : UIViewController
    fileprivate var titleStyle : HGL_TitleViewStyle
    fileprivate var titleLables : [UILabel] = [UILabel]()
    lazy var lineView : UIView = UIView()
    public var lineW : CGFloat = 20.0
    public var lineH : CGFloat = 3.0
    
    
    
    fileprivate var currentIndex = 0 {
        didSet {
            self.getCurrentIndex!(currentIndex)
//            print("currentIndex" + "\(currentIndex)")
        }
    }
    
    
    fileprivate lazy var scrollView : UIScrollView = {
       let scroll = UIScrollView(frame: self.bounds)
        scroll.showsHorizontalScrollIndicator = false
        scroll.scrollsToTop = false
        return scroll
        
    }()
    
    init(frame: CGRect,titles : [String],titleStyle : HGL_TitleViewStyle,parentVC : UIViewController) {
        self.titles = titles
        self.parentVC = parentVC
        self.titleStyle = titleStyle
        super.init(frame: frame)
        
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

}

extension HGL_TitleView {
    // MARK: - 设置
    fileprivate func setupUI () {
        for chilren in self.subviews {
            chilren.removeFromSuperview()
        }
        addSubview(scrollView)
        
        setupLineView()
        setupTitleLabels()
        
    }
    
    
    private func setupTitleLabels() {
        
        for (i,title) in titles.enumerated() {
            
            let titleLabel = UILabel()
            let tap = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_ : )))
            titleLabel.addGestureRecognizer(tap)
            titleLabel.isUserInteractionEnabled = true
            titleLabel.textAlignment = .center
            titleLabel.text = title
            titleLabel.textColor = i == 0 ? titleStyle.selectColor :  titleStyle.normalColor
            titleLabel.font = UIFont.systemFont(ofSize: titleStyle.titleSize)
            titleLabel.tag = i

            scrollView.addSubview(titleLabel)
            titleLables.append(titleLabel)
        }
        
        setupTitleLabelAndLineFrame()
        
    }
    
    func setupLineView() {
        
    }
    private func setupTitleLabelAndLineFrame () {
        
        let count = titleLables.count
        for (i,label) in titleLables.enumerated() {
            var w : CGFloat = 0
            var h : CGFloat = bounds.height
            var x : CGFloat = 0
            var y : CGFloat = 0
            if titleStyle.isScrollEnable {

                w = (titles[i] as NSString).boundingRect(with:                 CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : label.font], context: nil).width;
                if i == 0{
                    x = titleStyle.itemMargin * 0.5
                }else{
                    x = titleLables[i - 1].frame.maxX + titleStyle.itemMargin
                }
            }else{
                w = bounds.width / CGFloat(count)
                x = w * CGFloat(i)
            }
            
            label.frame = CGRect(x: x, y: y, width: w, height: h)
        }
        
        scrollView.addSubview(lineView)
        lineView.backgroundColor = UIColor.orange
        let label = (titleLables.first)!
        let lineX = label.frame.minX + (label.frame.size.width - lineW) * 0.5
        let lineY = label.frame.maxY - lineH * 2
        lineView.frame = CGRect(x: lineX, y: lineY, width: lineW, height: lineH)
        
        scrollView.contentSize = CGSize(width: titleLables.last!.frame.maxX + titleStyle.itemMargin * 0.5, height: 0)
        
    }
}



extension HGL_TitleView {
    @objc fileprivate func titleLabelClick(_ tagGes : UITapGestureRecognizer) {
        guard let label = tagGes.view as? UILabel else {
            return;
        }

        delegate?.titleView(self, targtIndex: label.tag)
        adjustTitleLabelPosion(targtIndex: label.tag)
    }
    
    
    fileprivate func adjustTitleLabelPosion (targtIndex : Int ) {
        
        
    
        if targtIndex == currentIndex {
            return
        }
        let label = titleLables[targtIndex]
        let sourceLabel = titleLables[currentIndex]
        let labelMargin = abs(label.center.x - sourceLabel.center.x) - lineW
        let lineX = label.frame.minX + (label.frame.size.width - lineW) * 0.5
        UIView.animate(withDuration: 0.15) {
            
            self.lineView.frame.origin.x = lineX
            self.lineView.frame.size.width = self.lineW
        }
        
        
        sourceLabel.textColor = titleStyle.normalColor
        label.textColor = titleStyle.selectColor
        if  titleStyle.isScrollEnable {
        var offset = label.center.x - scrollView.bounds.size.width * 0.5
            if offset < 0 {
                offset = 0
            }
        
            if offset > scrollView.contentSize.width - scrollView.bounds.size.width {
                offset = scrollView.contentSize.width - scrollView.bounds.size.width
            }
            scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        }
        
        currentIndex =  label.tag
    }
}

extension HGL_TitleView : HGL_ContainViewDelegate{
    
    func contentChange(_ containView: HGL_ContainView, titleTag: Int) {

        adjustTitleLabelPosion(targtIndex: titleTag)
        
    }
    
    func contentChange(_ containView: HGL_ContainView, targtIndex: Int, progress: CGFloat) {
        
        print(progress)
        
      
        
        var index = targtIndex
        if index == titleLables.count{
            index = titleLables.count - 1
        }
        let targtLabel = titleLables[index]
        let sourceLabel = titleLables[currentIndex]
        print("\(index)  \(currentIndex)")
        
        var lineRect = lineView.frame
        
        let labelMargin = abs(targtLabel.center.x - sourceLabel.center.x) - lineW
        if index > currentIndex {
            if progress <= 0.5000001{
                let width : CGFloat = lineW + (lineW + labelMargin) * progress * 2
                lineRect.size.width = width
                
            }else{
                let width : CGFloat = lineW + (lineW + labelMargin) * (1 - progress ) * 2
                let lineX =  lineRect.maxX - width
                lineRect.size.width = width
                lineRect.origin.x = lineX
            }
            
        }else{
            if progress <= 0.5{
                let width : CGFloat = lineW + (lineW + labelMargin) * progress * 2
                
                let lineX =  lineRect.maxX - width
                
                lineRect.size.width = width
                lineRect.origin.x = lineX
                
            }
            
            
//            width = lineW * (1.0 - progress)
        }
        lineView.frame = lineRect
        
        let detaRGB = UIColor.getRGBColor(firstColor: titleStyle.selectColor, endColor: titleStyle.normalColor)
        let selectRGB = titleStyle.selectColor.getRGB()
        let nomalRGB = titleStyle.normalColor.getRGB()
        
        targtLabel.textColor = UIColor(r: nomalRGB.0 + detaRGB.0 * progress, g: nomalRGB.1 + detaRGB.1 * progress, b: nomalRGB.2 + detaRGB.2 * progress)
       sourceLabel.textColor = UIColor(r: selectRGB.0 - detaRGB.0 * progress, g: selectRGB.1 - detaRGB.1 * progress, b: selectRGB.2 - detaRGB.2 * progress)

    }
    
    
   
    
    
}
