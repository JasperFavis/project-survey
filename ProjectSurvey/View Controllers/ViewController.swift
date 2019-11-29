//
//  ViewController.swift
//  ProjectSurvey
//
//  Created by Jasper Favis on 9/16/19.
//  Copyright © 2019 TeamOptional. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpElements()
    }

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var takeASurvey: UIButton!
    @IBOutlet weak var logoView: UIView!
    
    func setUpElements() {
        
        view.setGradientBackground(colorOne: #colorLiteral(red: 0.9333333333, green: 0.9607843137, blue: 0.8588235294, alpha: 1), colorTwo: #colorLiteral(red: 0.3451896811, green: 0.3553423188, blue: 0.3176325218, alpha: 1))
        logoView.setGradientBackground(colorOne: #colorLiteral(red: 0.4156862745, green: 0.4980392157, blue: 0.431372549, alpha: 1), colorTwo: #colorLiteral(red: 0.2352941176, green: 0.2823529412, blue: 0.2431372549, alpha: 1))
        
        
        //view.setGradientBackground(colorOne: #colorLiteral(red: 0.7170763175, green: 0.7592572774, blue: 0.7592572774, alpha: 1), colorTwo: #colorLiteral(red: 0.2, green: 0.2117647059, blue: 0.2117647059, alpha: 1))

        Utilities.styleHollowButton(signUpButton, with: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        Utilities.styleHollowButton(loginButton, with: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        //Utilities.styleHollowButton(takeASurvey, with: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.styleFilledButton(takeASurvey, with: #colorLiteral(red: 0.2343357426, green: 0.2807607482, blue: 0.2431786008, alpha: 1))
    }

    
}

