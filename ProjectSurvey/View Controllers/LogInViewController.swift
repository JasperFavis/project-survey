//
//  LogInViewController.swift
//  ProjectSurvey
//
//  Created by Jasper Favis on 9/16/19.
//  Copyright © 2019 TeamOptional. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        if navigationController?.popViewController(animated: true) == nil {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        // Validate the text fields
        let error = validateFields()
        
        
        if error != nil {
            // There's something wrong with the fields, show error message
            showError(error!)
        }
        else {
            // Omit spacing and newlines from the textfields
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Sign user in
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    // Couldn't sign in
                    self.showError(error!.localizedDescription)
                }
                else {
                    self.transitionToHome()
                }
            }
        }
    }
    
    func setUpElements() {
        
        view.setGradientBackground(colorOne: #colorLiteral(red: 0.9333333333, green: 0.9607843137, blue: 0.8588235294, alpha: 1), colorTwo: #colorLiteral(red: 0.3451896811, green: 0.3553423188, blue: 0.3176325218, alpha: 1))
        
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style all the elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton, with: #colorLiteral(red: 0.2343357426, green: 0.2807607482, blue: 0.2431786008, alpha: 1))
    }
    
    func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    func validateFields() -> String? {
        
        // Check that all fields are filed in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields"
        }
        
        // Check if the password is secure
        let cleanPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !Utilities.isPasswordValid(cleanPassword) {
            // Password isn't secure enough
            return "Password must contain a special character, a number and must be at least 8 characters long."
        }
        
        return nil
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }

    
    
}
