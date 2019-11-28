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
    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    // MARK: - PROPERTIES
    
    var optionsDelegate: surveyOptionsDelegate!
    
    // MARK: - IBActions
    
    @IBAction func analyticsButtonTapped(_ sender: Any) {
        optionsDelegate.selectedAnalytics(forSurvey: surveyTitleLabel.text!)
    }
    
    @IBAction func inviteButtonTapped(_ sender: Any) {
        optionsDelegate.selectedInvite(forSurvey: surveyTitleLabel.text!)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        
        optionsDelegate.selectedEdit(forSurvey: surveyTitleLabel.text!)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
    }
    
}

protocol surveyOptionsDelegate {
    func selectedEdit(forSurvey title: String)
    func selectedInvite(forSurvey title: String)
    func selectedAnalytics(forSurvey title: String)
}
