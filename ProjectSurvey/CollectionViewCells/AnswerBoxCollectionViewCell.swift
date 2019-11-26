//
//  AnswerBoxCollectionViewCell.swift
//  ProjectSurvey
//
//  Created by Jasper Benedict Favis on 11/22/19.
//  Copyright © 2019 TeamOptional. All rights reserved.
//

import UIKit

class AnswerBoxCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var enterAnswerTextField: UITextField!
    
    
    // MARK: - PROPERTIES
    
    var questionNumber: Int?
    
    // MARK: - FUNCTIONS
    
    // CALL BACK for answer text field
    @objc func textFieldDidChange() {
        
        if let questionNumber = questionNumber {
            if let answer = enterAnswerTextField.text {
                SurveyAnswers.respondentAnswers[questionNumber] = answer
            }
        }
    }
    
    func addListenerToTextField() {
        enterAnswerTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
}
