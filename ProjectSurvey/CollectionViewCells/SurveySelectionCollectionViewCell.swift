//
//  SurveySelectionCollectionViewCell.swift
//  ProjectSurvey
//
//  Created by Jasper Benedict Favis on 11/17/19.
//  Copyright © 2019 TeamOptional. All rights reserved.
//

import UIKit

class SurveySelectionCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var surveyTitleLabel: UILabel!
    @IBOutlet weak var surveyContentView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    // MARK: - PROPERTIES
    
    var surveyEditDelegate: editSurveyDelegate!
    
    // MARK: - IBActions
    
    @IBAction func editButtonTapped(_ sender: Any) {
        
        surveyEditDelegate.selectedEdit(forSurvey: surveyTitleLabel.text!)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
    }
    
}

protocol editSurveyDelegate {
    func selectedEdit(forSurvey title: String)
}
