//
//  UIColor.swift
//  HGL_PageView_Example
//
//  Created by heiguoliangle on 2017/9/11.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
extension UIColor {
    convenience init(r: CGFloat,g : CGFloat ,b : CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    
    class func randomColor() -> UIColor {
        let random = CGFloat(arc4random_uniform(256))
        return UIColor(r: random, g: random, b: random)
        
       
        
    }
    
    
    class func getRGBColor(firstColor : UIColor,endColor : UIColor) -> (CGFloat,CGFloat,CGFloat){
        
        let fristRGB = firstColor.getRGB()
        let endRGB = endColor.getRGB()
        
        
        return (fristRGB.0 - endRGB.0,fristRGB.1 - endRGB.1,fristRGB.2 - endRGB.2)
        
    }
    
    func getRGB () -> (CGFloat,CGFloat,CGFloat){
        guard let firstCom = cgColor.components else {
            fatalError("参数错误")
        }
        
        return (firstCom[0] * 255 ,firstCom[1] * 255,firstCom[2] * 255)
        
    }
    
    
}
