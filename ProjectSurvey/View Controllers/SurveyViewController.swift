//
//  SurveyViewController.swift
//  ProjectSurvey
//
//  Created by Jasper Benedict Favis on 11/18/19.
//  Copyright © 2019 TeamOptional. All rights reserved.
//

import UIKit
import Firebase
import DLRadioButton

class SurveyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, EnableSubmitDelegate, saveSurveyAnswersDelegate {
        
    // MARK: - IBOutlets
    
    @IBOutlet weak var surveyCollectionView: UICollectionView!
    @IBOutlet weak var surveyFlowLayout: UICollectionViewFlowLayout! {
        didSet {
            if let surveyCollectionView = surveyCollectionView {
                surveyFlowLayout.estimatedItemSize = CGSize(width: surveyCollectionView.frame.width, height: 100)
            }
        }
    }
    
    
    // MARK: - Properties
    
    let db = Firestore.firestore()
    var questions: [String] = []
    var answers: [[String]?] = []
    var surveyTitle = ""
    var surveyDocumentID = ""
    
    
    // MARK: - ViewDidLoad
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
    }
    
    
    // MARK: - IBActions
    

    
    
    // MARK: - HELPER FUNCTIONS
    
    
    func setUpElements() {
        surveyCollectionView.delegate = self
        surveyCollectionView.dataSource = self
        view.setGradientBackground(colorOne: #colorLiteral(red: 0.631372549, green: 0.8274509804, blue: 0.8980392157, alpha: 1), colorTwo: #colorLiteral(red: 0.3098039216, green: 0.4078431373, blue: 0.4431372549, alpha: 1))
        SurveyAnswers.submitDelegate = self
        SurveyAnswers(to: questions.count)
    }
    
    
    func answerViewHeight(for answers: [String]) -> CGFloat {
        var totalHeight = CGFloat(0)
        for answer in answers {
            totalHeight += DynamicLabelSize.height(text: answer, font: UIFont.systemFont(ofSize: 14), width: 245)
        }
        return totalHeight + 40 + 40 + 13 * CGFloat(answers.count)
    }
    
    // GRAY OUT BUTTON
    func grayOutButton(for button: UIButton, ifNot enabled: Bool) {
        button.alpha = (enabled) ? 1 : 0.5
    }
    
    // Testing Purposes
    func randomStringGenerator(from min: Int, to max: Int) -> String {
        let substring = "hello "
        let randomNumber = Int.random(in: min...max)
        var i = 0
        var string: String = ""
        while i < randomNumber {
            string += substring
            i += 1
        }
        return string
    }
    
    // Testing Purposes
    func randomAnswerArrayGenerator(forMultipleChoice value: Bool) -> [String]? {
        if value {
            var answers: [String] = []
            for index in 0...Int.random(in: 2...6) {
                answers.append("answer \(index)")
            }
            return answers
        } else {
            return nil
        }
    }
    
    
    // MARK: - PROTOCOL METHODS for UICollectionView
    
    // Specify size of each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Size of cell for questions and answers
        if indexPath.row > 0 && indexPath.row <= questions.count {
            
            // Calculate height of text for the question
            var answerHeight = CGFloat(1)
            let font = UIFont.systemFont(ofSize: 20)
            let questionLabelHeight = DynamicLabelSize.height(text: questions[indexPath.row - 1], font: font, width: 380)
            
            // Calculate height of answer UIView
            if let answers = answers[indexPath.row - 1] {
                // Height for multiple choice
                answerHeight = answerViewHeight(for: answers)
            } else {
                // Height for answer box
                answerHeight = 100
            }
            
            // Set height of cell to total height of question and answer
            let totalCellHeight = questionLabelHeight + answerHeight
            return CGSize(width: 400, height: totalCellHeight)
        }
        
        // Size of cell for header: survey title and back button
        if indexPath.row < 1 {
            let titleHeight = DynamicLabelSize.height(text: surveyTitle, font: UIFont.systemFont(ofSize: 30), width: 400)
            let headerHeight = 130 + titleHeight
            return CGSize(width: 400, height: headerHeight)
        }
        
        // Size of cell for footer: submit button and error UILabel
        return CGSize(width: 400, height: 300)
    }
    
    // Specify the number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // A cell for each question and 2 cells for the header and footer
        return questions.count + 1 + 1
        
    }
    
    // Display the contents of each cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Display cells for questions and answers
        if indexPath.row > 0 && indexPath.row <= questions.count {
            
            // Display multiple choice answers
            if let answers = answers[indexPath.row - 1] {
                
                guard let cell = surveyCollectionView.dequeueReusableCell(withReuseIdentifier: "multipleChoiceCell", for: indexPath) as? MultipleChoiceCollectionViewCell else {
                    return UICollectionViewCell()
                }
                
                cell.questionNumber = indexPath.row - 1
                cell.answerView.subviews.forEach({ $0.removeFromSuperview() })
                cell.questionLabel.text = "\(indexPath.row). \(questions[indexPath.row - 1])"
                cell.questionLabel.font = UIFont.italicSystemFont(ofSize: 20)
                cell.addButtons(for: answers)
                
                if let qnum = cell.questionNumber {
                    if SurveyAnswers.answers[qnum] != nil {
                        cell.radioButtons[SurveyAnswers.answers[qnum] as! Int].isSelected = true
                        print("Question: \(qnum + 1) Answer: \((SurveyAnswers.answers[qnum] as! Int) + 1)")
                    }
                }
                return cell
            }
            
            // Display fill-in-the-blank answers
            guard let cell = surveyCollectionView.dequeueReusableCell(withReuseIdentifier: "answerBoxCell", for: indexPath) as? AnswerBoxCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.questionNumber = indexPath.row - 1
            cell.addListenerToTextField()
            cell.questionLabel.text = "\(indexPath.row). \(questions[indexPath.row - 1])"
            cell.questionLabel.font = UIFont.italicSystemFont(ofSize: 20)
            
            return cell
        }
        
        // Display cell for header: survey title and back button
        if indexPath.row < 1 {
            guard let cell = surveyCollectionView.dequeueReusableCell(withReuseIdentifier: "surveyTitleCell", for: indexPath) as? SurveyTitleCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.surveyTitleLabel.text = surveyTitle
            return cell
        }
        
        // Display cell for footer: error label and submit button
        guard let cell = surveyCollectionView.dequeueReusableCell(withReuseIdentifier: "submitCell", for: indexPath) as? SubmitCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.saveAnswersDelegate = self
        
        for answers in SurveyAnswers.respondentAnswers {
            if answers == nil {
                cell.submitButton.isEnabled = false
                cell.submitButton.alpha = 0.5
                return cell
            }
        }
        cell.submitButton.isEnabled = true
        cell.submitButton.alpha = 1
        return cell
    }
    
    // MARK: - PROTOCOL METHODS for EnableSubmitDelegate
    
    // If survey completely filled, enable submit button
    func enableSubmitButtonIfSurveyComplete() {
        
        // Loop through visible cells (currently on display)
        for cell in surveyCollectionView.visibleCells {
            
            if let cell = cell as? SubmitCollectionViewCell {
                var isSurveyComplete = false

                // If an answer is missing, do not enable submit button
                for answers in SurveyAnswers.respondentAnswers {
                    if answers != nil {
                        isSurveyComplete = true
                    } else {
                        isSurveyComplete = false
                        break
                    }
                }
                cell.submitButton.alpha = (isSurveyComplete) ? 1 : 0.5
                cell.submitButton.isEnabled = (isSurveyComplete) ? true : false
            }
        }
    }
    
    
    // MARK: - PROTOCOL METHODS for saveSurveyAnswersDelegate
    
    // Upload respondent's answers to firestore
    func saveAnswersToFirestore() {
        print("protocol save to firestore")
        print("survey ID = \(surveyDocumentID)")
        
        dump(SurveyAnswers.respondentAnswers)
        
//        let surveyRef = db.collection("survyes").document(surveyDocumentID)
//        
//        surveyRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                
//            }
//        }
    }

    
} // SurveyViewController



// MARK: - EXTENSION UIView

extension UIView {
    
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
         let border = CALayer()
         border.backgroundColor = color.cgColor
         border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
         self.layer.addSublayer(border)
     }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
}
