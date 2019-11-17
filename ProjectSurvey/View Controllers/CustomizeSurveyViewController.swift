//
//  CustomizeSurveyViewController.swift
//  ProjectSurvey
//
//  Created by Jasper Benedict Favis on 11/14/19.
//  Copyright © 2019 TeamOptional. All rights reserved.
//

import UIKit
import Firebase
import DLRadioButton

class CustomizeSurveyViewController: UIViewController {
    
    /********Labels********/
    @IBOutlet weak var errorLabel: UILabel!
    
    /********Textfields******/
    @IBOutlet weak var surveyTitleTextfield: UITextField!
    @IBOutlet weak var enterQuestionTextfield: UITextField!
    @IBOutlet weak var enterAnswerTextfield: UITextField!
    
    /********Buttons********/
    @IBOutlet weak var prevQuestionButton: UIButton!
    @IBOutlet weak var nextQuestionButton: UIButton!
    @IBOutlet weak var prevAnswerButton: UIButton!
    @IBOutlet weak var nextAnswerButton: UIButton!
    @IBOutlet weak var saveChangesButton: UIButton!
    @IBOutlet weak var textBoxRadioButton: DLRadioButton!
    @IBOutlet weak var multipleChoiceRadioButton: DLRadioButton!
    
    /********StackViews******/
    @IBOutlet weak var AnswerStackView: UIStackView!
    
    let db = Firestore.firestore()
    var questions: [String] = []
    var answers: [String] = []
    var questionIndex = 0
    var answerIndex = 0
    var questionsAndAnswers: [String : [String]?] = [:]
    var surveyTitleIsEmpty = true
    var surveyTitle = ""
    var surveyTitleExists = false {
        didSet {
            if !surveyTitleExists {
                if let currUID = Auth.auth().currentUser?.uid {
                    let userDocRef = db.collection("users").document(currUID)
                    let surveyDocRef = db.collection("surveys").addDocument(data: [
                        "title" : surveyTitle,
                        "questions" : questions,
                        "questionsAndanswers" : questionsAndAnswers])
                    userDocRef.setData([surveyTitle : surveyDocRef], merge: true)
                } else {
                    print("No user signed in\n")
                }
            } else {
                showError("Survey title already exists")
            }
        }
    }
    
    
    
    /**************** viewDidLoad ******************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
    }
    /*********************************************/
    
    
    /**************** IBAction ********************/
    
    @IBAction func prevQuestionClicked(_ sender: Any) {
        updateQuestionsAndAnswers(andMoveBackIf: true)
    }
    
    @IBAction func nextQuestionClicked(_ sender: Any) {
        updateQuestionsAndAnswers(andMoveBackIf: false)
    }
    
    @IBAction func prevAnswerClicked(_ sender: Any) {
        updateMultipleChoiceAnswers(andMoveBackIf: true)
    }
    
    @IBAction func nextAnswerClicked(_ sender: Any) {
        updateMultipleChoiceAnswers(andMoveBackIf: false)
    }
    
    @IBAction func textBoxClicked(_ sender: Any) {
        AnswerStackView.isHidden = true
        
        prevQuestionButton.isEnabled = true
        nextQuestionButton.isEnabled = true
        grayOutButton(for: prevQuestionButton, ifNot: prevQuestionButton.isEnabled)
        grayOutButton(for: nextQuestionButton, ifNot: nextQuestionButton.isEnabled)
    }
    
    @IBAction func multipleChoiceClicked(_ sender: Any) {
        AnswerStackView.isHidden = false
        
        answers.removeAll()
        answerIndex = 0
        if !isTextfieldEmpty(for: enterQuestionTextfield) {
            let question = enterQuestionTextfield.text!
            if let storedAnswers = questionsAndAnswers[question] {
                for answer in storedAnswers! {
                    answers.append(answer)
                }
            }
        }
        displayText(in: &enterAnswerTextfield, fromItemIn: answers, at: answerIndex, or: "Enter Answer")
        
        if answers.count < 2 {
            prevQuestionButton.isEnabled = false
            nextQuestionButton.isEnabled = false
            grayOutButton(for: prevQuestionButton, ifNot: prevQuestionButton.isEnabled)
            grayOutButton(for: nextQuestionButton, ifNot: nextQuestionButton.isEnabled)
        }
    }
    
    @IBAction func doneClicked(_ sender: Any) {
    }
    
    // Save survey information to firestore
    @IBAction func saveChangesClicked(_ sender: Any) {
        
        // Create cleaned versions of the data
        surveyTitle = surveyTitleTextfield.text!

        // Save survey data to firestore under docRef (surveys->doc). Save docRef to user's document under unique survey title
        if let currUID = Auth.auth().currentUser?.uid {
            let userDocRef = db.collection("users").document(currUID)
            userDocRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let userDocData = document.data().map(String.init(describing:)) ?? "nil"
                    self.surveyTitleExists = (userDocData.contains(self.surveyTitle)) ? true : false
                }
            }
        } else {
            print("No user signed in\n")
        }

    } // SaveChangesClicked
    
    
    
    /**************** Functions ******************/
    
    // Set up custom look for buttons, labels, textfields
    func setUpElements() {
        textBoxRadioButton.isSelected = true
        disableSaveButtonIfSurveyPartiallyFilled()
        hideStackView()
        hideError()
        AnswerStackView.addBackgroundColor(color: #colorLiteral(red: 0.7357930223, green: 0.4392925942, blue: 0.3062928082, alpha: 1))
        surveyTitleTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        Utilities.styleTextField(surveyTitleTextfield)
        Utilities.styleTextField(enterQuestionTextfield)
        Utilities.styleTextField(enterAnswerTextfield)
    }
    
    // Store questions and answers to data structures
    func updateQuestionsAndAnswers(andMoveBackIf prevIsSelected: Bool) {
        
        var didDelete = false
        
        // Add or delete question
        if isTextfieldEmpty(for: enterQuestionTextfield) {
            // Delete
            if isItemStored(at: questionIndex, for: questions) {
                removeQandA()
                didDelete = true
            }
        } else {
            // Add
            let question = enterQuestionTextfield.text!
            if isItemStored(at: questionIndex, for: questions) {
                if question != questions[questionIndex] {
                    addQandA(for: question)
                } else if multipleChoiceRadioButton.isSelected && questionsAndAnswers[question] == nil {
                    questionsAndAnswers[question] = answers
                } else if textBoxRadioButton.isSelected && questionsAndAnswers[question] != nil {
                    questionsAndAnswers[question] = nil
                }
            } else {
                addQandA(for: question)
            }
        }
        
        // Keep SaveChangesButton disabled when
        disableSaveButtonIfSurveyPartiallyFilled()
        
        // Increment or decrement questionIndex or do nothing
        if prevIsSelected {
            moveToPreviousItem(startingAt: &questionIndex, in: questions)
        } else {
            if !didDelete {
                moveToNextItem(startingAt: &questionIndex, in: questions)
            }
        }

        // If question exists at current index, display in textfield
        displayText(in: &enterQuestionTextfield, fromItemIn: questions, at: questionIndex, or: "Enter Question")
        
        // Display multiple choice answers for current question if it exists
        populateEnterAnswer()
        
        if multipleChoiceRadioButton.isSelected {
            if answers.count < 2 {
                prevQuestionButton.isEnabled = false
                nextQuestionButton.isEnabled = false
                grayOutButton(for: prevQuestionButton, ifNot: prevQuestionButton.isEnabled)
                grayOutButton(for: nextQuestionButton, ifNot: nextQuestionButton.isEnabled)
            }
        }
        
    } // updateQuestionsAndAnswers
    
    func updateMultipleChoiceAnswers(andMoveBackIf prevIsSelected: Bool) {
        
        var didDelete = false
               
        // Add or delete answer
        if isTextfieldEmpty(for: enterAnswerTextfield) {
           // Delete
            if isItemStored(at: answerIndex, for: answers) {
                answers.remove(at: answerIndex)
                didDelete = true
            }
        } else {
           // Add
           let answer = enterAnswerTextfield.text!
           if isItemStored(at: answerIndex, for: answers) {
                if answer != answers[answerIndex] {
                    answers.insert(answer, at: answerIndex)
                }
           } else {
                answers.insert(answer, at: answerIndex)
            }
        }
        
        if answers.count > 1 {
            prevQuestionButton.isEnabled = true
            nextQuestionButton.isEnabled = true
            grayOutButton(for: prevQuestionButton, ifNot: prevQuestionButton.isEnabled)
            grayOutButton(for: nextQuestionButton, ifNot: nextQuestionButton.isEnabled)
        }

        // Increment or decrement answerIndex or do nothing
        if prevIsSelected {
           moveToPreviousItem(startingAt: &answerIndex, in: answers)
        } else {
           if !didDelete {
               moveToNextItem(startingAt: &answerIndex, in: answers)
           }
        }

        // If answer exists at current index, display in textfield
        displayText(in: &enterAnswerTextfield, fromItemIn: answers, at: answerIndex, or: "Enter Answer")
    }
    
    func enableQuestionButtons(if value: Bool) {
        prevQuestionButton.isEnabled = value
        nextQuestionButton.isEnabled = value
    }
    
    func enableAnswerButtons(if value: Bool) {
        prevAnswerButton.isEnabled = value
        nextAnswerButton.isEnabled = value
    }
    
    func disableSaveButtonIfSurveyPartiallyFilled() {
        saveChangesButton.isEnabled = (questions.isEmpty || surveyTitleIsEmpty) ? false : true
        grayOutButton(for: saveChangesButton, ifNot: saveChangesButton.isEnabled)
    }
    
    func disableQuestionPrevAndNext(on value: Bool) {
        prevQuestionButton.isEnabled = value
        nextQuestionButton.isEnabled = value
        grayOutButton(for: prevQuestionButton, ifNot: value)
        grayOutButton(for: nextQuestionButton, ifNot: value)
    }
    
    @objc func textFieldDidChange() {
        surveyTitleIsEmpty = (surveyTitleTextfield.text == "") ? true : false
        disableSaveButtonIfSurveyPartiallyFilled()
    }
    
    // Add questions and answers to dictionary
    func addQandA(for question: String) {
        questions.insert(question, at: questionIndex)
        if textBoxRadioButton.isSelected {
            questionsAndAnswers[questions[questionIndex]] = nil
        } else {
            questionsAndAnswers[questions[questionIndex]] = answers
        }
    }
    
    func removeQandA() {
        questionsAndAnswers.removeValue(forKey: questions[questionIndex])
        questions.remove(at: questionIndex)
    }
    
    func moveToPreviousItem(startingAt index: inout Int, in array: [String]) {
        if !array.isEmpty && index > 0 {
            index -= 1
            hideError()
        } else {
            showError("Cannot move back")
        }
    }
    
    func moveToNextItem(startingAt index: inout Int, in array: [String]) {
        if !array.isEmpty && index < array.count {
            index += 1
            hideError()
        } else {
            showError("Cannot move forward")
        }
    }
    
    func populateEnterAnswer() {
        // Display multiple choice answers for current question if it exists
        answers.removeAll()
        answerIndex = 0
        if !isTextfieldEmpty(for: enterQuestionTextfield) {
            let question = enterQuestionTextfield.text!
            if let storedAnswers = questionsAndAnswers[question] {
                textBoxRadioButton.isSelected = false
                multipleChoiceRadioButton.isSelected = true
                for answer in storedAnswers! {
                    answers.append(answer)
                }
            } else {
                textBoxRadioButton.isSelected = true
                multipleChoiceRadioButton.isSelected = false
            }
        }
        displayText(in: &enterAnswerTextfield, fromItemIn: answers, at: answerIndex, or: "Enter Answer")
        AnswerStackView.isHidden = textBoxRadioButton.isSelected
    }
    
    func displayText(in textfield: inout UITextField, fromItemIn array: [String], at index: Int, or placeholder: String) {
        if array.indices.contains(index) {
            textfield.text = array[index]
        } else {
            textfield.text = ""
            textfield.placeholder = placeholder
        }
    }
    
    // Check if array element exists at given index
    func isItemStored(at index: Int, for array: [String]) -> Bool {
        if array.indices.contains(index) {
            return true
        }
        return false
    }
    
    // Check for blank fields
    func isTextfieldEmpty(for textfield: UITextField) -> Bool {
        if (textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            return true
        }
        return false
    }
    
    // Check for blank fields
    func validateFields(for field: UITextField) -> String? {
        
        // Check that all fields are filled in
        if (field.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            
            return "Please fill in all fields."
        }
        return nil
    }
    
    func hideStackView() {
        if !AnswerStackView.isHidden {
            AnswerStackView.isHidden = true
        }
    }
    
    func grayOutButton(for button: UIButton, ifNot enabled: Bool) {
        button.alpha = (enabled) ? 1 : 0.5
    }
    
    // Show error message
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    // Hide error message
    func hideError() {
        errorLabel.alpha = 0
    }

} /**** CustomizeSurveyViewController ****/



// Allow custom features for UIStackView elements
extension UIStackView {
    func addBackgroundColor(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.layer.cornerRadius = 10
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
