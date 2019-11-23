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

class SurveyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
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
    
//    let sampleText = [
//    "what do you want to do on this nice hot sunny day. would you liketo go the beach and play in the cool water? would you like to go to the local ice cream shop? eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeffffffffffffffffffffffffffffffffffffffgggggggggggggggggggggghhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhiiiiiiiiiiiiiiiiiiiiii",
//    "this is just some sample text. nothing special. don'tpay any mind to my rambling."]
    
    var sampleText: [String] = []
    
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // fill up sampleText
        for _ in 0...12 {
            sampleText.append(randomStringGenerator())
        }
        //surveyCollectionView.reloadData()

        setUpElements()
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

    
    // MARK: - Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sampleText.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = surveyCollectionView.dequeueReusableCell(withReuseIdentifier: "surveyCell", for: indexPath) as? SurveyCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.questionLabel.text = sampleText[indexPath.row]
        cell.questionLabel.backgroundColor = (indexPath.row % 2 == 0) ? #colorLiteral(red: 0.3098039216, green: 0.4078431373, blue: 0.4431372549, alpha: 1) : #colorLiteral(red: 0.3495575222, green: 0.4601769912, blue: 0.5, alpha: 1)
        cell.answerView.backgroundColor = (indexPath.row % 2 == 0) ? #colorLiteral(red: 0.3098039216, green: 0.4078431373, blue: 0.4431372549, alpha: 1) : #colorLiteral(red: 0.3495575222, green: 0.4601769912, blue: 0.5, alpha: 1)
        cell.addButtons(times: Int.random(in: 2...5))
        
        return cell
    }

} // SurveyViewController
