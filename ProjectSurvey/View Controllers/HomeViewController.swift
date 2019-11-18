//
//  HomeViewController.swift
//  ProjectSurvey
//
//  Created by Jasper Favis on 9/16/19.
//  Copyright © 2019 TeamOptional. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var newSurveyButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var surveyTitleLabel: UILabel!
    
    @IBOutlet weak var surveySelectionCollectionView: UICollectionView!
    
    let db = Firestore.firestore()
    var surveyTitles: [String] = [] {
        didSet {
            if !surveyTitles.isEmpty {
                for item in surveyTitles {
                    print(item)
                }
            }
            surveySelectionCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
    }
    
    
    @IBAction func logoutTapped(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let signUpLogin = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.signUpLoginViewController) as? ViewController
        
        view.window?.rootViewController = signUpLogin
        view.window?.makeKeyAndVisible()
    }
    
    
    func setUpElements() {
        
        view.setGradientBackground(colorOne: #colorLiteral(red: 0.631372549, green: 0.8274509804, blue: 0.8980392157, alpha: 1), colorTwo: #colorLiteral(red: 0.3098039216, green: 0.4078431373, blue: 0.4431372549, alpha: 1))
        Utilities.styleHollowButton(logoutButton)
        Utilities.styleFilledButton(newSurveyButton)

        
        surveySelectionCollectionView.delegate = self
        surveySelectionCollectionView.dataSource = self
        
        // test
        retrieveSurveyTitles()
    }
    
    
    func retrieveSurveyTitles() {
        
        if let currUID = Auth.auth().currentUser?.uid {
            let surveyTitlesDocRef = db.collection("users").document(currUID).collection("SID storage").document("Survey Titles")
            surveyTitlesDocRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    guard let surveyTitlesDict = document.data() else {
                        return
                    }
                    self.surveyTitles = Array(surveyTitlesDict.keys)
                } else {
                    print("document doesn't exist")
                }
            }
        } else {
            print("No user signed in\n")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return surveyTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SurveyCell", for: indexPath) as! SurveySelectionCollectionViewCell
        
        cell.setGradientBackground(colorOne: #colorLiteral(red: 0.3725271624, green: 0.490415505, blue: 0.5328553082, alpha: 1), colorTwo: #colorLiteral(red: 0.2439439026, green: 0.3211413401, blue: 0.3489324176, alpha: 1))
        cell.surveyTitleLabel.text = surveyTitles[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell selected")
    }
    
} // HomeViewControllers


extension UIView {
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setHorizontalGradient(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
