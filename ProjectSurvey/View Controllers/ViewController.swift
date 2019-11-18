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
    
    func setUpElements() {
        
        view.setGradientBackground(colorOne: #colorLiteral(red: 0.6308100139, green: 0.8265786389, blue: 0.8972728646, alpha: 1), colorTwo: #colorLiteral(red: 0.3112901146, green: 0.4078973915, blue: 0.4427833526, alpha: 1))
        
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
    }

    
}

