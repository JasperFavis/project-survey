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
    var surveyDocumentID = ""
    
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
            surveyVC.surveyDocumentID = surveyDocumentID
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
    }
    
    
    // MARK: - Helper Functions
    
    func setupElements() {
        view.setGradientBackground(colorOne: #colorLiteral(red: 0.9333333333, green: 0.9607843137, blue: 0.8588235294, alpha: 1), colorTwo: #colorLiteral(red: 0.3451896811, green: 0.3553423188, blue: 0.3176325218, alpha: 1))
        
        
        errorLabel.alpha = 0
        
        Utilities.styleTextField(enterSurveyCodeTextField)
        Utilities.styleRectHollowButton(takeSurveyButton, with: #colorLiteral(red: 0.2343357426, green: 0.2807607482, blue: 0.2431786008, alpha: 1))
    }

    // VERIFY - survey code
    func verifyCode() {
        
        if isTextfieldEmpty(for: enterSurveyCodeTextField) {
            showMessage("Please enter a code")
        } else {
            let code = enterSurveyCodeTextField.text!
            let surveyCodeDocRef = db.collection("survey codes").document(code)

            // Check if survey code is valid
            surveyCodeDocRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    
                    var surveyDocRef: DocumentReference!
                    surveyDocRef = document.get("survey") as? DocumentReference
                    
                    // Save survey ID
                    self.surveyDocumentID = surveyDocRef.documentID
            
                    surveyDocRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            
                            // Save survey title
                            self.surveyTitle = document.get("title") as! String
                            
                            // Save survey questions
                            self.questions = document.get("questions") as! [String]
                            let questionsAndanswers = document.get("questionsAndanswers") as! [String: [String]?]
                            
                            // Save survey answers
                            for index in 0..<self.questions.count {
                                if let answers = questionsAndanswers[self.questions[index]] {
                                    self.answers.append(answers)
                                } else {
                                    self.answers.append(nil)
                                }
                            }
                        }
                    }
                } else {
                    self.showMessage("Code is invalid")
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
    
    func showMessage(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }

} // TakeSurveyViewController
