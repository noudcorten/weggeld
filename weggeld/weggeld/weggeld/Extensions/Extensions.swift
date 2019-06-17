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
    
    static func chartColors() -> [UIColor] {
        return [UIColor.rgb(255,127,80),
            UIColor.rgb(255,99,71),
            UIColor.rgb(255,165,0),
            UIColor.rgb(144,238,144),
            UIColor.rgb(0,128,128),
            UIColor.rgb(100,149,237),
            UIColor.rgb(65,105,225),
            UIColor.rgb(147,112,219),
            UIColor.rgb(219,112,147),
            UIColor.rgb(255,192,203),
            UIColor.rgb(244,164,96)]
    }
    
    static func categoryColors() -> [UIColor] {
        return [UIColor.rgb(244, 66, 66),
        UIColor.rgb(244, 157, 65),
        UIColor.rgb(244, 232, 65),
        UIColor.rgb(79, 244, 65),
        UIColor.rgb(65, 235, 244),
        UIColor.rgb(67, 65, 244),
        UIColor.rgb(178, 65, 244),
        UIColor.rgb(255, 66, 226)]
    }
    
    static let outlineStrokeColor = UIColor.rgb(244, 107, 173)
    static let pullsatingFillColor = UIColor.rgb(216, 69, 143)
    static let trackStrokeColor = UIColor.rgb(178, 174, 176)
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
