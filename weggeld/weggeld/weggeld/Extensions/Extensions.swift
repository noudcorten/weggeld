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
    
    static func categoryColorss() -> [UIColor] {
        return [UIColor.rgb(244, 66, 66),
                UIColor.rgb(244, 157, 65),
                UIColor.rgb(244, 232, 65),
                UIColor.rgb(79, 244, 65),
                UIColor.rgb(65, 235, 244),
                UIColor.rgb(67, 65, 244),
                UIColor.rgb(178, 65, 244),
                UIColor.rgb(255, 66, 226),
                UIColor.rgb(244, 107, 173)]
    }
    
    static func categoryColors() -> [UIColor] {
        return [UIColor.rgb(244, 66, 66),
                UIColor.rgb(244, 65, 128),
                UIColor.rgb(235, 65, 244),
                UIColor.rgb(103, 65, 244),
                UIColor.rgb(65, 154, 244),
                UIColor.rgb(65, 241, 244),
                UIColor.rgb(65, 244, 184),
                UIColor.rgb(73, 244, 65),
                UIColor.rgb(190, 244, 65),
                UIColor.rgb(244, 238, 65),
                UIColor.rgb(244, 157, 65),
                UIColor.rgb(252, 126, 0),
                UIColor.rgb(224, 224, 224),
                UIColor.rgb(168, 168, 168),
                UIColor.rgb(104, 104, 104),
                UIColor.rgb(0, 0, 0)
        ]
    }
    
    static let light_pink = UIColor.rgb(244, 107, 173)
    static let dark_pink = UIColor.rgb(216, 69, 143)
    static let light_gray = UIColor.rgb(178, 174, 176)
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

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
