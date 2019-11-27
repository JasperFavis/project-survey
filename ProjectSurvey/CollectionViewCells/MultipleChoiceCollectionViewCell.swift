//
//  SurveyCollectionViewCell.swift
//  ProjectSurvey
//
//  Created by Jasper Benedict Favis on 11/19/19.
//  Copyright © 2019 TeamOptional. All rights reserved.
//

import UIKit
import DLRadioButton

class MultipleChoiceCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerView: UIView!
    
    
    // MARK: - Properties
    
    
    var radioButtons : [DLRadioButton] = []
    var questionNumber: Int?
    
    
    // MARK: - IBActions
    
    // When radio button is selected, store the selected the answer to SurveyAnswers
    @objc @IBAction private func logSelectedButton(radioButton : DLRadioButton) {
        for index in 0..<radioButtons.count {
             if radioButtons[index].isSelected {
                SurveyAnswers.answers[questionNumber!] = index
                SurveyAnswers.respondentAnswers[questionNumber!] = radioButtons[index].titleLabel!.text
                break
             }
         }
    }
    
    
    // MARK: - FUNCTIONS
    
    
    // Programmatically add buttons
    func addButtons(for answers: [String]) {
        
        // First clear answerView
        radioButtons.removeAll()
         
        // First Button
        let frame = CGRect(x: 50, y: 30, width: 262, height: 17);
        let firstRadioButton = createRadioButton(frame: frame, title: answers[0], color: UIColor.white, currentView: answerView);
        var previousHeight = DynamicLabelSize.height(text: answers[0], font: UIFont.systemFont(ofSize: 20), width: 245)

        // Other Buttons
        var otherButtons: [DLRadioButton] = []
        for i in 1..<answers.count {
            if i == 1 {
                let frame = CGRect(x: 50, y: 30 + previousHeight + 13, width: 262, height: 17)
                let radioButton = createRadioButton(frame: frame, title: answers[i], color: UIColor.white, currentView: self.answerView)
                    otherButtons.append(radioButton)
                
                previousHeight += DynamicLabelSize.height(text: answers[i], font: UIFont.systemFont(ofSize: 20), width: 245)
            } else {
                let frame = CGRect(x: 50, y: 30 + 13 * CGFloat(i) + previousHeight, width: 262, height: 17)
                let radioButton = createRadioButton(frame: frame, title: answers[i], color: UIColor.white, currentView: self.answerView)
                otherButtons.append(radioButton)
                
                previousHeight += DynamicLabelSize.height(text: answers[i], font: UIFont.systemFont(ofSize: 20), width: 245)
            }
        }
        // set other buttons for first radio button
        firstRadioButton.otherButtons = otherButtons
        
        radioButtons.append(firstRadioButton)
        radioButtons += otherButtons
    }

    func createRadioButton(frame : CGRect, title : String, color : UIColor, currentView: UIView) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame)
        radioButton.titleLabel!.font = UIFont.systemFont(ofSize: 20);
        radioButton.titleLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
        radioButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.top
        radioButton.setTitle(title, for: [])
        radioButton.setTitleColor(color, for: [])
        radioButton.iconColor = color
        radioButton.indicatorColor = color
        radioButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left;
        radioButton.addTarget(self, action: #selector(MultipleChoiceCollectionViewCell.logSelectedButton), for: UIControl.Event.touchUpInside)
        currentView.addSubview(radioButton)

        return radioButton
    }

}
