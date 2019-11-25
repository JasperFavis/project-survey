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
    
    // MARK: - IBOutlets
    
    /********Labels********/
    @IBOutlet weak var errorLabel: UILabel!
    
    /********Textfields******/
    @IBOutlet weak var surveyTitleTextfield: UITextField!
    @IBOutlet weak var enterQuestionTextfield: UITextField!
    @IBOutlet weak var enterAnswerTextfield: UITextField!
    
    /********Buttons********/
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var prevQuestionButton: UIButton!
    @IBOutlet weak var nextQuestionButton: UIButton!
    @IBOutlet weak var prevAnswerButton: UIButton!
    @IBOutlet weak var nextAnswerButton: UIButton!
    @IBOutlet weak var saveChangesButton: UIButton!
    @IBOutlet weak var textBoxRadioButton: DLRadioButton!
    @IBOutlet weak var multipleChoiceRadioButton: DLRadioButton!
    
    /********StackViews******/
    @IBOutlet weak var AnswerStackView: UIStackView!
    
    // MARK: - Properties
    
    let db = Firestore.firestore()
    var questions: [String] = []
    var answers: [String] = []
    var questionsAndAnswers: [String : [String]?] = [:]
    var respondentData: [String: Any] = [:]
    var questionIndex = 0
    var answerIndex = 0
    var surveyTitleIsEmpty = true
    var overwrite = false
    var surveyTitle = ""
    var surveyTitleExists = false {
        didSet {
            if !surveyTitleExists {
                
                // Get current user ID if it exists
                if let currUID = Auth.auth().currentUser?.uid {
                    
                    // Go to user's collection (SID storage) and get reference to
                    // document (Survey Titles) which holds references to all their surveys
                    let userSIDstorageRef = db.collection("users").document(currUID).collection("SID storage").document("Survey Titles")
                    
                    // Add a document for the new survey information in Surveys
                    let surveyDocRef = db.collection("surveys").addDocument(data: [
                        "title" : surveyTitle,
                        "questions" : questions,
                        "questionsAndanswers" : questionsAndAnswers])
                    
                    // Store reference to survey in user's document (Survey Titles)
                    userSIDstorageRef.setData([surveyTitle : surveyDocRef], merge: true)
                    
                    // Store reference to document (Survey Titles) in user's document
                    let userInfoRef = db.collection("users").document(currUID)
                    userInfoRef.setData(["SIDstorageRef" : userSIDstorageRef], merge: true)
                    
                } else {
                    print("No user signed in\n")
                }
            } else {
                
                // PROMPT: Survey exists, would you like to overwrite?
                createAlert(title: "\"\(surveyTitle)\" already exists.", message: "Would you like to overwrite?")
            }
        }
    }
    
    
    // MARK: - viewDidLoad
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
    }
    
    
    // MARK: - IBActions
    
    // BACK BUTTON
    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // QUESTION: PREV BUTTON - save or delete question
    @IBAction func prevQuestionClicked(_ sender: Any) {
        updateQuestionsAndAnswers(andMoveBackIf: true)
    }
    
    // QUESTION: NEXT BUTTON - save or delete question
    @IBAction func nextQuestionClicked(_ sender: Any) {
        updateQuestionsAndAnswers(andMoveBackIf: false)
    }
    
    // ANSWER: PREV BUTTON - save or delete answer
    @IBAction func prevAnswerClicked(_ sender: Any) {
        updateMultipleChoiceAnswers(andMoveBackIf: true)
    }
    
    // ANSWER: NEXT BUTTON - save or delete answer
    @IBAction func nextAnswerClicked(_ sender: Any) {
        updateMultipleChoiceAnswers(andMoveBackIf: false)
    }
    
    // TEXTBOX RADIO BUTTON - when selected hides multiple choice entry box
    @IBAction func textBoxClicked(_ sender: Any) {
        AnswerStackView.isHidden = true
        
        prevQuestionButton.isEnabled = true
        nextQuestionButton.isEnabled = true
        grayOutButton(for: prevQuestionButton, ifNot: prevQuestionButton.isEnabled)
        grayOutButton(for: nextQuestionButton, ifNot: nextQuestionButton.isEnabled)
    }
    
    // MULTIPLE CHOICE RADIO BUTTON - when selected reveals multiple choice entry box
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
    
    // SAVE CHANGES - Save survey information to firestore and create data structure for respondent data
    @IBAction func saveChangesClicked(_ sender: Any) {
        
        // Create cleaned versions of the data
        surveyTitle = surveyTitleTextfield.text!

        // Save survey data to firestore under reference docRef (surveys->doc).
        // Save docRef to user's document under unique survey title
        if let currUID = Auth.auth().currentUser?.uid {
            
            let userDocRef = db.collection("users").document(currUID).collection("SID storage").document("Survey Titles")
            
            userDocRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let userDocData = document.data().map(String.init(describing:)) ?? "nil"
                    self.surveyTitleExists = (userDocData.contains(self.surveyTitle)) ? true : false
                } else {
                    print("document doesn't exist")
                    self.surveyTitleExists = false
                }
            }
        } else {
            print("No user signed in\n")
        }

    } // SaveChangesClicked
    
    
    
    // MARK: - FUNCTIONS
    
    // SETUP - Execute any intial setup
    func setUpElements() {
        view.setGradientBackground(colorOne: #colorLiteral(red: 0.4577064103, green: 0.7679830195, blue: 0.7317840817, alpha: 1), colorTwo: #colorLiteral(red: 0.1992263278, green: 0.3564087471, blue: 0.3380707983, alpha: 1))
        
        textBoxRadioButton.isSelected = true
        disableSaveButtonIfSurveyPartiallyFilled()
        hideStackView()
        hideError()
        AnswerStackView.addBackgroundColor(color: #colorLiteral(red: 0.1755965177, green: 0.2536111532, blue: 0.2846746575, alpha: 1))
        surveyTitleTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        Utilities.styleTextField(surveyTitleTextfield)
        Utilities.styleTextField(enterQuestionTextfield)
        Utilities.styleTextField(enterAnswerTextfield)
    }
    
    // ADD OR DELETE questions and answers from data structures
    func updateQuestionsAndAnswers(andMoveBackIf prevIsSelected: Bool) {
        
        var didDelete = false
        
        if isTextfieldEmpty(for: enterQuestionTextfield) {
            // DELETE question and answer from dictionary and array
            if isItemStored(at: questionIndex, for: questions) {
                removeQandA()
                didDelete = true
            }
        } else {
            // ADD question and answer to dictionary and array
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
        
        // Keep SaveChangesButton disabled when survey info is insufficient
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
    
    
    // ADD OR DELETE multiple choice answers from data structure
    func updateMultipleChoiceAnswers(andMoveBackIf prevIsSelected: Bool) {
        
        var didDelete = false
               
        if isTextfieldEmpty(for: enterAnswerTextfield) {
            // DELETE
            if isItemStored(at: answerIndex, for: answers) {
                answers.remove(at: answerIndex)
                didDelete = true
            }
        } else {
           // ADD
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
    
    // QUESTION - enable/disable left/right buttons
    func enableQuestionButtons(if value: Bool) {
        prevQuestionButton.isEnabled = value
        nextQuestionButton.isEnabled = value
    }
    
    // ANSWER - enable/disable left/right buttons
    func enableAnswerButtons(if value: Bool) {
        prevAnswerButton.isEnabled = value
        nextAnswerButton.isEnabled = value
    }
    
    // SAVE CHANGES - enable/disable
    func disableSaveButtonIfSurveyPartiallyFilled() {
        saveChangesButton.isEnabled = (questions.isEmpty || surveyTitleIsEmpty) ? false : true
        grayOutButton(for: saveChangesButton, ifNot: saveChangesButton.isEnabled)
    }
    
    // QUESTION - enable/disable and gray out left/right buttons
    func disableQuestionPrevAndNext(on value: Bool) {
        prevQuestionButton.isEnabled = value
        nextQuestionButton.isEnabled = value
        grayOutButton(for: prevQuestionButton, ifNot: value)
        grayOutButton(for: nextQuestionButton, ifNot: value)
    }
    
    // CHECK SURVEY TITLE FIELD - set flag indicating survey title has been given or not
    @objc func textFieldDidChange() {
        surveyTitleIsEmpty = (surveyTitleTextfield.text == "") ? true : false
        disableSaveButtonIfSurveyPartiallyFilled()
    }
    
    // ADD - question to array and both question and answer(s) to dictionary
    func addQandA(for question: String) {
        questions.insert(question, at: questionIndex)
        if textBoxRadioButton.isSelected {
            questionsAndAnswers[questions[questionIndex]] = nil
        } else {
            questionsAndAnswers[questions[questionIndex]] = answers
        }
    }
    
    // REMOVE - question and answer(s) from dictionary then remove question from array
    func removeQandA() {
        questionsAndAnswers.removeValue(forKey: questions[questionIndex])
        questions.remove(at: questionIndex)
    }
    
    // MOVE TO PREV
    func moveToPreviousItem(startingAt index: inout Int, in array: [String]) {
        if !array.isEmpty && index > 0 {
            index -= 1
            hideError()
        } else {
            showError("Cannot move back")
        }
    }
    
    // MOVE TO NEXT
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
    
    //  ALERT - Display pop-up that asks user if they would like to overwrite
    // previously saved survey
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print("Alert: Yes")
            
            // Get current user ID if it exists
            if let currUID = Auth.auth().currentUser?.uid {
               
               // Go to user's collection (SID storage) and get reference to
               // document (Survey Titles) which holds references to all their surveys
                let userSIDstorageRef = self.db.collection("users").document(currUID).collection("SID storage").document("Survey Titles")
               
                // Use the surveyTitle to get its survey so you can save
                // new information to it
                userSIDstorageRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        
                        // Get document ID for the current survey
                        var tempRef: DocumentReference!
                        tempRef = document.get(self.surveyTitle) as? DocumentReference
                        let docID = tempRef.documentID
                        
                        // Set new data for the survey
                        self.db.collection("surveys").document(docID).setData([
                             "title" : self.surveyTitle,
                             "questions" : self.questions,
                             "questionsAndanswers" : self.questionsAndAnswers],
                            merge: false)
                    }
                }
               
            } else {
               print("No user signed in\n")
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print("Alert: No")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

} /**** CustomizeSurveyViewController ****/



// MARK: - EXTENSION UIStackView

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
