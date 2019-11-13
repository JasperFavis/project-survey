//
//  CreateSurveyViewController.swift
//  ProjectSurvey
//
//  Created by Jasper Benedict Favis on 11/11/19.
//  Copyright © 2019 TeamOptional. All rights reserved.
//

import UIKit
import Firebase

class CreateSurveyViewController: UIViewController {

    @IBOutlet weak var surveyTitleTextField: UITextField!
    @IBOutlet weak var enterQuestionTextField: UITextField!
    @IBOutlet weak var addQuestionButton: UIButton!
    @IBOutlet weak var deleteQuestionButton: UIButton!
    @IBOutlet weak var prevQuestionButton: UIButton!
    @IBOutlet weak var nextQuestionButton: UIButton!
    @IBOutlet weak var questionNumLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var questionArray: [String] = []
    var questionIndex = 0;
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
    }
    
    // Set up custom look for buttons, labels, textfields
    func setUpElements() {
        hideError()
        
        Utilities.styleTextField(surveyTitleTextField)
        Utilities.styleTextField(enterQuestionTextField)
        Utilities.styleFilledButton(createButton)
    }

    // Saves survey information to firestore
    @IBAction func createTapped(_ sender: Any) {
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            // There's something wrong with the fields, show error message
            showError(error!)
        } else if questionArray.isEmpty {
            showError("Please fill in all fields")
        } else {
            // Create cleaned versions of the data
            let surveyTitle = surveyTitleTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create survey data object
            // let newSurvey = SurveyData(title: surveyTitle, questions: questionArray)
            
            // Save survey data to firestore under docRef (surveys->doc). Save docRef to user's document under unique survey title
            if let currUID = Auth.auth().currentUser?.uid {
                let docRef = db.collection("surveys").addDocument(data: [
                    "title" : surveyTitle,
                    "questions" : questionArray])
                db.collection("users").document(currUID).setData([surveyTitle : docRef], merge: true)
            } else {
                print("No user signed in\n")
            }
        }
    } // createTapped
    
    // Add question to questionArray then advanced to next entry
    @IBAction func AddQTapped(_ sender: Any) {
        
        // Validate the fields
        let error = validateQuestion()
        
        if error != nil {
            // There's something wrong with the fields, show error message
            showError(error!)
        }
        else {
            let question = enterQuestionTextField.text!
            if questionArray.indices.contains(questionIndex) {
                if question == questionArray[questionIndex] {
                    showError("Enter a new question")
                    return
                }
            }
            hideError()
            questionArray.insert(question, at: questionIndex)
            questionIndex += 1
            if !questionArray.indices.contains(questionIndex) {
                enterQuestionTextField.placeholder = "Enter Question"
                enterQuestionTextField.text = ""
                questionNumLabel.text = ""
            } else {
                enterQuestionTextField.text = questionArray[questionIndex]
                questionNumLabel.text = "Question \(questionIndex + 1)"
            }
        }
    }
    
    // Delete currently selected question if it exists
    @IBAction func deleteQTapped(_ sender: Any) {
        let isIndexValid = questionArray.indices.contains(questionIndex)
        if !questionArray.isEmpty && isIndexValid {
            questionArray.remove(at: questionIndex)
            if !questionArray.indices.contains(questionIndex) {
                enterQuestionTextField.placeholder = "Enter Question"
                enterQuestionTextField.text = ""
                questionNumLabel.text = ""
            } else {
                enterQuestionTextField.text = questionArray[questionIndex]
                questionNumLabel.text = "Question \(questionIndex + 1)"
            }
            hideError()
        } else {
            showError("Cannot delete")
        }
    }
    
    // Move to previous question
    @IBAction func prevQTapped(_ sender: Any) {
        if !questionArray.isEmpty && questionIndex > 0 {
            questionIndex -= 1
            enterQuestionTextField.text = questionArray[questionIndex]
            questionNumLabel.text = "Question \(questionIndex + 1)"
            hideError()
        } else {
            showError("Cannot move back")
        }
    }
    
    // Move to next question
    @IBAction func nextQTapped(_ sender: Any) {
        if !questionArray.isEmpty && questionIndex < questionArray.count {
            questionIndex += 1
            if questionArray.indices.contains(questionIndex) {
                enterQuestionTextField.text = questionArray[questionIndex]
                questionNumLabel.text = "Question \(questionIndex + 1)"
            } else {
                enterQuestionTextField.placeholder = "Enter Question"
                enterQuestionTextField.text = ""
                questionNumLabel.text = ""
            }
            hideError()
        } else {
            showError("Cannot move forward")
        }
    }
    
    // Check for blank fields
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if (surveyTitleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            
            return "Please fill in all fields."
        }
        return nil
    }
    
    // Check for blank question field
    func validateQuestion() -> String? {
        if (enterQuestionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            
            return "Please enter a question."
        }
        return nil
    }
    
    // Display error message
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    // Hide error message
    func hideError() {
        errorLabel.alpha = 0
    }
    
} // CreateSurveyViewController



// Notes
//                    // Test: Retrieving data
//                    let docRef = db.collection("users").document(currUID).collection("surveys").document("surveyone")
//                    docRef.getDocument { (document, error) in
//                        if let document = document, document.exists {
//                            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                            print("Document data: \(dataDescription)")
//                        } else {
//                            print("Document does not exist")
//                        }
//                    }
