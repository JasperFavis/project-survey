//
//  LogInViewController.swift
//  ProjectSurvey
//
//  Created by Jasper Favis on 9/16/19.
//  Copyright © 2019 TeamOptional. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func loginTapped(_ sender: Any) {
    }
    
    func setUpElements() {
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style all the elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleFilledButton(loginButton)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
