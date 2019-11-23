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
    
    
    var sampleQuestions: [String] = []
    var sampleAnswers = [
    ["a","b","c","d"],
    ["e","f","g","h","e","f","g","h","e","f","g","h"],
["i","j","kiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii","l"],
    ["m","n","o","p"],
    ["q","r","s","sdfasdf","wefefsfs","wef","t"],
    ["u","x"],
    ["y","z","-2","-1","0","1"],
    ["2","3","4","5"],
    ["6","7","8","9"],
    ["10","11","12","13"]]
    
    
    // MARK: - ViewDidLoad
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()

        // fill up sampleText
        for _ in 0...9 {
            sampleQuestions.append(randomStringGenerator())
        }
        sampleQuestions[0] = "What is your name?"
        sampleQuestions[1] = "If you were a bear, what kind of dolphin would you sleep with?"
        SurveyAnswers(to: sampleQuestions.count)
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
    
    func randomStringGenerator() -> String {
        let substring = "hello "
        let randomNumber = Int.random(in: 10...60)
        var i = 0
        var string: String = ""
        while i < randomNumber {
            string += substring
            i += 1
        }
        return string
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
        
        let font = UIFont.systemFont(ofSize: 17)
        let questionLabelHeight = DynamicLabelSize.height(text: sampleQuestions[indexPath.row], font: font, width: 380)
          
        let answerHeight = answerViewHeight(for: sampleAnswers[indexPath.row])
          
        let totalCellHeight = questionLabelHeight + answerHeight

        return CGSize(width: 400, height: totalCellHeight)
    }
    
    // Number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sampleQuestions.count
    }
    
    // Display for each cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = surveyCollectionView.dequeueReusableCell(withReuseIdentifier: "surveyCell", for: indexPath) as? SurveyCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.questionNumber = indexPath.row
        cell.answerView.subviews.forEach({ $0.removeFromSuperview() })
        cell.questionLabel.text = "\(indexPath.row + 1). \(sampleQuestions[indexPath.row])"
        cell.questionLabel.font = UIFont.italicSystemFont(ofSize: 17)
        cell.addButtons(for: sampleAnswers[indexPath.row])
        
        if let qnum = cell.questionNumber {
            if SurveyAnswers.answers[qnum] != nil {
                cell.radioButtons[SurveyAnswers.answers[qnum] as! Int].isSelected = true
                print("Question: \(qnum) Answer: \(SurveyAnswers.answers[qnum] as! Int)")
            }
        }
        
        return cell
    }

    
} // SurveyViewController
