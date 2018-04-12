//
//  ViewController.swift
//  HGL_PageView
//
//  Created by heiguoliangle on 09/11/2017.
//  Copyright (c) 2017 heiguoliangle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var pageView : HGL_PageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        let titles = ["游戏","娱jjjjjj乐","美女","颜色值","赛格","颜色值"]
//        let titles = ["游戏","娱乐","美女","颜色值"]
        var childs = [UIViewController]()
        let titleStyel = HGL_TitleViewStyle()
        titleStyel.titleViewHeight = 50
        titleStyel.titleSize = 14
//        titleStyel.isScrollEnable = true
        titleStyel.isScrollEnable = false
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.white
//            vc.view.frame = CGRect(x: 0, y: 0, width: 375, height: 400)
            childs.append(vc)
            
        }
        let frame = CGRect(x: 0, y: 84, width: view.bounds.size.width, height: view.bounds.size.height - 64 - 100)
        pageView = HGL_PageView(frame:frame , titles: titles, titleStyle: titleStyel, childVCs: childs, parentVC: self)
        self.view.addSubview(pageView)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let titles = ["游戏","娱乐","美女","颜色值"]
        var childs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            //            vc.view.frame = CGRect(x: 0, y: 0, width: 375, height: 400)
            childs.append(vc)
        }
        pageView.titles = titles
        pageView.childVCs = childs
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

