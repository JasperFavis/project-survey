//
//  TestViewController.swift
//  ProjectSurvey
//
//  Created by Jasper Benedict Favis on 11/18/19.
//  Copyright © 2019 TeamOptional. All rights reserved.
//

import UIKit
import DLRadioButton

class TestViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var testCollectionView: UICollectionView!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    
    var sampleQuestions: [String] = []
    var sampleAnswers = [
        ["a","b","c","d"],
        ["e","f","g","h","e","f","g","h","e","f","g","h"],
["i","j","kiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii","l"],
        ["m","n","o","p"],
        ["q","r","s","sdfasdf","wefefsfs","wef","t"],
        ["u","x"],
        ["y","z","-2","-1","0","1"],
        ["2","3","4","5"],
        ["6","7","8","9"],
        ["10","11","12","13"]]
    
    
    
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testCollectionView.delegate = self
        testCollectionView.dataSource = self
        
        // fill up sampleText
        for _ in 0...9 {
            sampleQuestions.append(randomStringGenerator())
        }
        SurveyAnswers(to: sampleQuestions.count)
    }
    
    
    
    
    // MARK: - Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let font = UIFont.systemFont(ofSize: 17)
        let questionLabelHeight = DynamicLabelSize.height(text: sampleQuestions[indexPath.row], font: font, width: 380)
        
        let answerHeight = answerViewHeight(for: sampleAnswers[indexPath.row])
        
        let totalCellHeight = questionLabelHeight + answerHeight

        return CGSize(width: 400, height: totalCellHeight)
        
        //return CGSize(width: 400, height: 400)
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sampleQuestions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "testCell", for: indexPath) as? testCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.testLabel.text = sampleQuestions[indexPath.row]
        cell.testView.layer.borderColor = UIColor.black.cgColor
        cell.testView.layer.borderWidth = 3.0

        cell.questionNumber = indexPath.row
        cell.answerView.subviews.forEach({ $0.removeFromSuperview() })
        cell.addButtons(answers: sampleAnswers[indexPath.row])
        
        if let qnum = cell.questionNumber {
            if SurveyAnswers.answers[qnum] != nil {
                cell.allButtons[SurveyAnswers.answers[qnum] as! Int].isSelected = true
                print("Question: \(qnum) Answer: \(SurveyAnswers.answers[qnum] as! Int)")
            }
        }

        return cell
    }
    
    
    // MARK: - Functions
    
    func randomStringGenerator() -> String {
        let substring = "hello"
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

} // TestViewController






// MARK: - class testCollectionViewCell

class testCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var answerView: UIView!
    
    var allButtons : [DLRadioButton] = []
    var questionNumber: Int?
    var selectedButton: DLRadioButton?
    
    // Programmatically add buttons
    func addButtons(answers answerArray: [String]) {
        
        allButtons.removeAll()
         
         //first button
        let frame = CGRect(x: 50, y: 30, width: 262, height: 17);
        let firstRadioButton = createRadioButton(frame: frame, title: answerArray[0], color: UIColor.black, currentView: answerView);
        var previousHeight = DynamicLabelSize.height(text: answerArray[0], font: UIFont.systemFont(ofSize: 14), width: 245)

        //other buttons
        var otherButtons: [DLRadioButton] = []
        for i in 1..<answerArray.count {
            if i == 1 {
                let frame = CGRect(x: 50, y: 30 + previousHeight + 13, width: 262, height: 17)
                let radioButton = createRadioButton(frame: frame, title: answerArray[i], color: UIColor.black, currentView: self.answerView)
                    otherButtons.append(radioButton)
                
                previousHeight += DynamicLabelSize.height(text: answerArray[i], font: UIFont.systemFont(ofSize: 14), width: 245)
            } else {
                let frame = CGRect(x: 50, y: 30 + 13 * CGFloat(i) + previousHeight, width: 262, height: 17)
                let radioButton = createRadioButton(frame: frame, title: answerArray[i], color: UIColor.black, currentView: self.answerView)
                otherButtons.append(radioButton)
                
                previousHeight += DynamicLabelSize.height(text: answerArray[i], font: UIFont.systemFont(ofSize: 14), width: 245)
            }
        }
        // set other buttons for first radio button
        firstRadioButton.otherButtons = otherButtons
        
        allButtons.append(firstRadioButton)
        allButtons += otherButtons
    }


    func createRadioButton(frame : CGRect, title : String, color : UIColor, currentView: UIView) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame);
        radioButton.titleLabel!.font = UIFont.systemFont(ofSize: 14);
        radioButton.titleLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
        radioButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.top
        radioButton.setTitle(title, for: []);
        radioButton.setTitleColor(color, for: []);
        radioButton.iconColor = color;
        radioButton.indicatorColor = color;
        radioButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left;
        radioButton.addTarget(self, action: #selector(testCollectionViewCell.logSelectedButton), for: UIControl.Event.touchUpInside);
        currentView.addSubview(radioButton);

        return radioButton;
    }
    

    @objc @IBAction private func logSelectedButton(radioButton : DLRadioButton) {
        if (radioButton.isMultipleSelectionEnabled) {
            for button in radioButton.selectedButtons() {
                print(String(format: "%@ is selected.\n", button.titleLabel!.text!));
            }
        } else {
            print(String(format: "%@ is selected.\n", radioButton.selected()!.titleLabel!.text!));
        }
        for index in 0..<allButtons.count {
            if allButtons[index].isSelected {
                SurveyAnswers.answers[questionNumber!] = index
                break
            }
        }
    }


} // TestCollectionViewCell




//    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
//        {
//        didSet {
//            if let testCollectionView = testCollectionView {
//                collectionLayout.estimatedItemSize = CGSize(width: testCollectionView.frame.width, height: 92)
//            }
//        }
//    }

    //    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        setNeedsLayout()
//        layoutIfNeeded()
//        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
//        var frame = layoutAttributes.frame
//        frame.size.height = ceil(size.height)
//        layoutAttributes.frame = frame
//        return layoutAttributes
//    }
