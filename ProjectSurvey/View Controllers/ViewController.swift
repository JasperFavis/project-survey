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
    
    func setUpElements() {
        
        //view.setGradientBackground(colorOne: #colorLiteral(red: 0.6308100139, green: 0.8265786389, blue: 0.8972728646, alpha: 1), colorTwo: #colorLiteral(red: 0.1712521061, green: 0.2243993114, blue: 0.2435913577, alpha: 1))
        
        //view.setGradientBackground(colorOne: #colorLiteral(red: 0.1001027038, green: 0.2335729754, blue: 0.3114306339, alpha: 1), colorTwo: #colorLiteral(red: 0.01830938337, green: 0.04272189453, blue: 0.05696252605, alpha: 1))
        
        //view.setGradientBackground(colorOne: #colorLiteral(red: 0.2156862745, green: 0.1450980392, blue: 0.168627451, alpha: 1), colorTwo: #colorLiteral(red: 0.04913990104, green: 0.1146597691, blue: 0.1528796921, alpha: 1))
        
        //view.setGradientBackground(colorOne: #colorLiteral(red: 0.2657718909, green: 0.1152075535, blue: 0.165395666, alpha: 1), colorTwo: #colorLiteral(red: 0.04913990104, green: 0.1146597691, blue: 0.1528796921, alpha: 1))
        
        view.setGradientBackground(colorOne: #colorLiteral(red: 0.7170763175, green: 0.7592572774, blue: 0.7592572774, alpha: 1), colorTwo: #colorLiteral(red: 0.2, green: 0.2117647059, blue: 0.2117647059, alpha: 1))

        Utilities.styleHollowButton(signUpButton, with: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        Utilities.styleHollowButton(loginButton, with: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        //Utilities.styleHollowButton(takeASurvey, with: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.styleFilledButton(takeASurvey, with: #colorLiteral(red: 0.2, green: 0.2117647059, blue: 0.2117647059, alpha: 1))
    }

    
}

