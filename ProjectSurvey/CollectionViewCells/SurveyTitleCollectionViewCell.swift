//
//  SurveyTitleCollectionViewCell.swift
//  ProjectSurvey
//
//  Created by Jasper Benedict Favis on 11/24/19.
//  Copyright © 2019 TeamOptional. All rights reserved.
//

import UIKit

class SurveyTitleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var surveyTitleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    
    // MARK: - IBActions
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismissTopViewController()
    }
    
    // MARK: - FUNCTIONS
    
    func dismissTopViewController() {
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            // topController should now be your topmost view controller
            topController.dismiss(animated: true, completion: nil)
        }
        
    }
}
