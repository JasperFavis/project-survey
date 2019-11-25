//
//  TakeSurveyViewController.swift
//  ProjectSurvey
//
//  Created by Jasper Benedict Favis on 11/23/19.
//  Copyright © 2019 TeamOptional. All rights reserved.
//

import UIKit
import Firebase

class TakeSurveyViewController: UIViewController {

    // MARK: - IBOutlets
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var takeSurveyButton: UIButton!
    @IBOutlet weak var enterSurveyCodeTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    // MARK: - Properties
    
    let db = Firestore.firestore()
    var questions: [String] = []
    var answers: [[String]?] = [] {
        didSet {
            if answers.count == questions.count {
                exit = true
            }
        }
    }
    var surveyTitle = ""
    
    var exit = false {
        didSet {
            self.enterSurveyCodeTextField.text = ""
            self.errorLabel.alpha = 0
            self.performSegue(withIdentifier: "displaySurveySegue", sender: nil)
        }
    }

    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupElements()
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displaySurveySegue" {
            let surveyVC = segue.destination as! SurveyViewController
            
            surveyVC.questions = questions
            surveyVC.answers = answers
            surveyVC.surveyTitle = surveyTitle
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction func backButtonTapped(_ sender: Any) {
        if navigationController?.popViewController(animated: true) == nil {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func takeSurveyButtonTapped(_ sender: Any) {
        verifyCode()
        
//        if exit {
//            self.enterSurveyCodeTextField.text = ""
//            self.errorLabel.alpha = 0
//            self.performSegue(withIdentifier: "displaySurveySegue", sender: nil)
//        } else {
//            self.showError("Code is invalid")
//        }
    }
    
    
    // MARK: - Helper Functions
    
    func setupElements() {
        view.setGradientBackground(colorOne: #colorLiteral(red: 0.6308100139, green: 0.8265786389, blue: 0.8972728646, alpha: 1), colorTwo: #colorLiteral(red: 0.3112901146, green: 0.4078973915, blue: 0.4427833526, alpha: 1))
        
        errorLabel.alpha = 0
        
        Utilities.styleTextField(enterSurveyCodeTextField)
        Utilities.styleFilledButton(takeSurveyButton)
    }

    
    func verifyCode() {
        if isTextfieldEmpty(for: enterSurveyCodeTextField) {
            showError("Please enter a code")
        } else {
            let code = enterSurveyCodeTextField.text!
            let surveyCodeDocRef = db.collection("survey codes").document(code)

            surveyCodeDocRef.getDocument { (document, error) in
                if let document = document, document.exists {
//                    guard let surveyData = document.data() else {
//                        return
//                    }
                    
                    var surveyDocRef: DocumentReference!
                    surveyDocRef = document.get("survey") as? DocumentReference
            
                    surveyDocRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            
                            self.surveyTitle = document.get("title") as! String
            
                            self.questions = document.get("questions") as! [String]
                            let questionsAndanswers = document.get("questionsAndanswers") as! [String: [String]?]
            
                            for index in 0..<self.questions.count {
                                if let answers = questionsAndanswers[self.questions[index]] {
                                    self.answers.append(answers)
                                } else {
                                    self.answers.append(nil)
                                }
                            }
                        }
                    }
                    
                    //self.exit = true
                } else {
                    self.showError("Code is invalid")
                }
            }
        }
    }
    
    // Check for blank fields
    func isTextfieldEmpty(for textfield: UITextField) -> Bool {
        if (textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            return true
        }
        return false
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }

} // TakeSurveyViewController
