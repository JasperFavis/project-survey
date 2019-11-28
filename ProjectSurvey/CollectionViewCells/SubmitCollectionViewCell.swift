//
//  SubmitCollectionViewCell.swift
//  ProjectSurvey
//
//  Created by Jasper Benedict Favis on 11/24/19.
//  Copyright © 2019 TeamOptional. All rights reserved.
//

import UIKit

class SubmitCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - Properties
    
    var saveAnswersDelegate: saveSurveyAnswersDelegate!
    
    
    // MARK: - IBActions

    @IBAction func submitButtonTapped(_ sender: Any) {
        
        saveAnswersDelegate.confirmSave()
        //dismissTopViewController()
    }
    
    
    // MARK: - Helper Functions
    

    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    

    
    
} // SubmitCollectionViewCell

// MARK: - PROTOCOL

protocol saveSurveyAnswersDelegate {
    func confirmSave()
}
