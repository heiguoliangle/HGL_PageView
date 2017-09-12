//
//  ViewController.swift
//  HGL_PageView
//
//  Created by heiguoliangle on 09/11/2017.
//  Copyright (c) 2017 heiguoliangle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        let titles = ["游戏","娱乐","美女","颜色值","帅哥","🚴","飞机","赛格"]
//                let titles = ["游戏","娱乐","美女","颜色值"]
        var childs = [UIViewController]()
        let titleStyel = HGL_TitleViewStyle()
        titleStyel.titleViewHeight = 50
        titleStyel.titleSize = 14
        titleStyel.isScrollEnable = true
//        titleStyel.isScrollEnable = false
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            childs.append(vc)
            
        }
        let frame = CGRect(x: 0, y: 64, width: view.bounds.size.width, height: view.bounds.size.height - 64)
        let pageView = HGL_PageView(frame:frame , titles: titles, titleStyle: titleStyel, childVCs: childs, parentVC: self)
        self.view.addSubview(pageView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

