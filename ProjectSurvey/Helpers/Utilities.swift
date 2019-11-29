//
//  Utilities.swift
//  customauth
//
//  Created by Christopher Ching on 2019-05-09.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Remove border on text field
        textfield.borderStyle = .bezel
        textfield.backgroundColor = UIColor.white
    }
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        //button.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        button.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.2705882353, blue: 0.3568627451, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleFilledButton(_ button:UIButton, with customColor: UIColor) {
        
        // Filled rounded corner style
        button.backgroundColor = customColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleFilledButtonGreen(_ button:UIButton) {
        
        // Filled rounded corner style
        //button.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        button.backgroundColor = #colorLiteral(red: 0.158965535, green: 0.2482096646, blue: 0.2318429742, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton, with color: UIColor) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = color.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func styleRectHollowButton(_ button:UIButton, with color: UIColor) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = color.cgColor
        button.tintColor = UIColor.black
    }
    
    static func styleHollowButtonBlue(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = #colorLiteral(red: 0.1490196078, green: 0.2705882353, blue: 0.3568627451, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func styleButtonWithBlackBorder(_ button:UIButton,_ color: UIColor) {
        
        button.backgroundColor = color
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func cleanText(field: UITextField!) -> String{
        return field.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    static func cleanTextCheck(field: UITextField!) -> Bool{
        return field.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
    }
    
}
