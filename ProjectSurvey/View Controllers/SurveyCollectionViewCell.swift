//
//  SurveyCollectionViewCell.swift
//  ProjectSurvey
//
//  Created by Jasper Benedict Favis on 11/19/19.
//  Copyright © 2019 TeamOptional. All rights reserved.
//

import UIKit
import DLRadioButton

class SurveyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerView: UIView!
    
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        return layoutAttributes
    }
    
    // Programmatically add buttons
    func addButtons(times numOfButtons: Int) {
         
         // First button
        let frame = CGRect(x: 50, y: 20, width: 262, height: 17);
        let firstRadioButton = createRadioButton(frame: frame, title: "Radio Button 0", color: UIColor.white, currentView: answerView);


        // Other buttons
        var i = 0
        var otherButtons : [DLRadioButton] = []
        while i < numOfButtons {
            if i == 0 {
                let frame = CGRect(x: 50, y: 20 + firstRadioButton.frame.size.height + 13, width: 262, height: 17)
                let radioButton = createRadioButton(frame: frame, title: "Radio Button \(i + 1)", color: UIColor.white, currentView: self.answerView)
                otherButtons.append(radioButton)
            } else {
                let frame = CGRect(x: 50, y: 20 + firstRadioButton.frame.size.height + 13 + 30 * CGFloat(i), width: 262, height: 17)
                let radioButton = createRadioButton(frame: frame, title: "Radio Button \(i + 1)", color: UIColor.white, currentView: self.answerView)
                otherButtons.append(radioButton)
            }
            
            i += 1
        }
        

        // set other buttons for first radio button
        firstRadioButton.otherButtons = otherButtons;
    }


    func createRadioButton(frame : CGRect, title : String, color : UIColor, currentView: UIView) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame);
        radioButton.titleLabel!.font = UIFont.systemFont(ofSize: 14);
        radioButton.setTitle(title, for: []);
        radioButton.setTitleColor(color, for: []);
        radioButton.iconColor = color;
        radioButton.indicatorColor = color;
        radioButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left;
        radioButton.addTarget(self, action: #selector(SurveyCollectionViewCell.logSelectedButton), for: UIControl.Event.touchUpInside);
        currentView.addSubview(radioButton);

        return radioButton;
    }

    @objc @IBAction private func logSelectedButton(radioButton : DLRadioButton) {
        if (radioButton.isMultipleSelectionEnabled) {
            for button in radioButton.selectedButtons() {
                print(String(format: "%@ is selected.\n", button.titleLabel!.text!));
            }
        } else {
            print(String(format: "%@ is selected.\n", radioButton.selected()!.titleLabel!.text!));
        }
    }

}
