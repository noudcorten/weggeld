//
//  Extensions.swift
//  WegGeld
//
//  Created by Noud on 6/11/19.
//  Copyright © 2019 Noud. All rights reserved.
//

import UIKit

/* Extension for UIColor which adds a list of colors used for category-coloring
 and creates some static colors used for the app UI. */
extension UIColor {
    // Creates color based on given inputs for r(ed), g(reen) and b(lue).
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    // List of UIColors which is used for the category coloring.
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
    
    // Static colors which are used in the app UI.
    static let light_pink = UIColor.rgb(244, 107, 173)
    static let dark_pink = UIColor.rgb(216, 69, 143)
    static let light_gray = UIColor.rgb(178, 174, 176)
}

/* Extension for the UIViewController which adds a TapGestureRecognizer which
 is used to make the keyboard go away when the user touches anywhere on the
 screen. */
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

/* Extension of String which is used to add more functionality to a string */
extension String {
    // Turns the string into a lowercased string with only the first letter
    // uppercased.
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    // Checks if the string is an integer.
    func isInt() -> Bool {
        if let _ = Int(self) {
            return true
        }
        return false
    }
    
    // Checks if the string is a float.
    func isFloat() -> Bool {
        if let _ = Float(self) {
            let dotString = "."
            if self.contains(dotString) {
                // Input is float with a maximum of two decimals
                if self.components(separatedBy: dotString)[1].count <= 2 {
                    return true
                }
            }
        }
        return false
    }
}

/* Extension of DateFormatter which adds extra functionality for representing
 the date in different formats. */
extension DateFormatter {
    /// DateFormatter which returns the format '01/01/2019'.
    static let dueDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    /// DateFormatter which returns the format '01'.
    static let getMonthNumber: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M"
        return formatter
    }()
    
    /// DateFormatter which returns the format '2019'.
    static let getYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    /// DateFormatter which returns the format '01/2019'.
    static let getMonthYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yyyy"
        return formatter
    }()
    
    /// DateFormatter which returns the format '01-01-2019 12:00'.
    static let correctFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "CEST")
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        return formatter
    }()
}
