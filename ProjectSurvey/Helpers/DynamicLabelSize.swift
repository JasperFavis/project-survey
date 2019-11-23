//
//  DynamicLabelSize.swift
//  ProjectSurvey
//
//  Created by Jasper Benedict Favis on 11/22/19.
//  Copyright © 2019 TeamOptional. All rights reserved.
//
import UIKit
import Foundation

class DynamicLabelSize {
    
    static func height(text: String?, font: UIFont, width: CGFloat) -> CGFloat {
         var currentHeight: CGFloat!
         
         let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
         label.text = text
         label.font = font
         label.numberOfLines = 0
         label.sizeToFit()
         label.lineBreakMode = .byWordWrapping
         
         currentHeight = label.frame.height
         label.removeFromSuperview()
         
         return currentHeight
     }
    
}
