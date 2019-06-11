//
//  Extensions.swift
//  WegGeld
//
//  Created by Noud on 6/11/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static let outlineStrokeColor = UIColor.rgb(244, 107, 173)
    static let pullsatingFillColor = UIColor.rgb(216, 69, 143)
    static let trackStrokeColor = UIColor.rgb(178, 174, 176)
//    static let pullsatingFillColor = UIColor.rgb(255, 165, 210)
}
