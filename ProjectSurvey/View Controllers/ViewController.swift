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
        
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
    }

    
}

