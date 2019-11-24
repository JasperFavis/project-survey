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

class SurveyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - IBOutlets

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var surveyCollectionView: UICollectionView!
    @IBOutlet weak var surveyFlowLayout: UICollectionViewFlowLayout! {
        didSet {
            if let surveyCollectionView = surveyCollectionView {
                surveyFlowLayout.estimatedItemSize = CGSize(width: surveyCollectionView.frame.width, height: 100)
            }
        }
    }
    
    
    // MARK: - Properties
    
//    var questions: [String] = []
//    var answers: [[String]?] = []
    
    var test = ""
    
    var questions: [String] = []
    var answers: [[String]?] = [
        ["a","b","c","d"],
        ["e","f","g","h","e","f","g","h","e","f","g","h"],
    ["i","j","kiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii","l"],
        nil,
        ["q","r","s","sdfasdf","wefefsfs","wef","t"],
        ["u","x"],
        ["y","z","-2","-1","0","1"],
        nil,
        ["6","7","8","9"],
        ["10","11","12","13"]]
    // For test data structures
//    var sampleQuestions: [String] = []
//    var sampleAnswers = [
//    ["a","b","c","d"],
//    ["e","f","g","h","e","f","g","h","e","f","g","h"],
//["i","j","kiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii","l"],
//    nil,
//    ["q","r","s","sdfasdf","wefefsfs","wef","t"],
//    ["u","x"],
//    ["y","z","-2","-1","0","1"],
//    nil,
//    ["6","7","8","9"],
//    ["10","11","12","13"]]
    
    
    // MARK: - ViewDidLoad
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()

        
        for _ in 0..<questions.count {
            answers.append(randomAnswerArrayGenerator(forMultipleChoice: false))
        }
        // fill up sampleText
//        for _ in 0...9 {
//            questions.append(randomStringGenerator())
//        }
//        questions[0] = "What is your name?"
//        questions[1] = "If you were a bear, what kind of dolphin would you sleep with?"
        SurveyAnswers(to: questions.count)
    }
    
    
    // MARK: - IBActions
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Helper Functions
    
    
    func setUpElements() {
        surveyCollectionView.delegate = self
        surveyCollectionView.dataSource = self
        view.setGradientBackground(colorOne: #colorLiteral(red: 0.631372549, green: 0.8274509804, blue: 0.8980392157, alpha: 1), colorTwo: #colorLiteral(red: 0.3098039216, green: 0.4078431373, blue: 0.4431372549, alpha: 1))
    }
    
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

    func answerViewHeight(for answers: [String]) -> CGFloat {
        var totalHeight = CGFloat(0)
        for answer in answers {
            totalHeight += DynamicLabelSize.height(text: answer, font: UIFont.systemFont(ofSize: 14), width: 245)
        }
        return totalHeight + 40 + 40 + 13 * CGFloat(answers.count)
    }
    
    
    // MARK: - Protocol Methods
    
    // Size for each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var answerHeight = CGFloat(1)
        let font = UIFont.systemFont(ofSize: 17)
        let questionLabelHeight = DynamicLabelSize.height(text: questions[indexPath.row], font: font, width: 380)
        
        if let answers = answers[indexPath.row] {
            answerHeight = answerViewHeight(for: answers)
        } else {
            answerHeight = 100
        }
        let totalCellHeight = questionLabelHeight + answerHeight
        return CGSize(width: 400, height: totalCellHeight)
    }
    
    // Number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questions.count
    }
    
    // Display for each cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let answers = answers[indexPath.row] {
            // Multiple Choice
            guard let cell = surveyCollectionView.dequeueReusableCell(withReuseIdentifier: "multipleChoiceCell", for: indexPath) as? MultipleChoiceCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.questionNumber = indexPath.row
            cell.answerView.subviews.forEach({ $0.removeFromSuperview() })
            cell.questionLabel.text = "\(indexPath.row + 1). \(questions[indexPath.row])"
            cell.questionLabel.font = UIFont.italicSystemFont(ofSize: 17)
            
            //cell.addButtons(for: sampleAnswers[indexPath.row])
            cell.addButtons(for: answers)
            if let qnum = cell.questionNumber {
                if SurveyAnswers.answers[qnum] != nil {
                    cell.radioButtons[SurveyAnswers.answers[qnum] as! Int].isSelected = true
                    print("Question: \(qnum + 1) Answer: \((SurveyAnswers.answers[qnum] as! Int) + 1)")
                }
            }
            return cell
        } else {
            // Answer Box
            guard let cell = surveyCollectionView.dequeueReusableCell(withReuseIdentifier: "answerBoxCell", for: indexPath) as? AnswerBoxCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.questionLabel.text = "\(indexPath.row + 1). \(questions[indexPath.row])"
            return cell
        }
    }

    
} // SurveyViewController


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
