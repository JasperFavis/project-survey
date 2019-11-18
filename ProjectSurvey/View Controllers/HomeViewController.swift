//
//  HomeViewController.swift
//  ProjectSurvey
//
//  Created by Jasper Favis on 9/16/19.
//  Copyright © 2019 TeamOptional. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var newSurveyButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var surveyTitleLabel: UILabel!
    
    @IBOutlet weak var surveySelectionCollectionView: UICollectionView!
    
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
        Utilities.styleHollowButton(logoutButton)
        Utilities.styleFilledButtonGreen(newSurveyButton)
        
        surveySelectionCollectionView.delegate = self
        surveySelectionCollectionView.dataSource = self
        

    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width/2)
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SurveyCell", for: indexPath) as! SurveySelectionCollectionViewCell
        
        cell.setGradientBackground(colorOne: #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), colorTwo: #colorLiteral(red: 0.1490196078, green: 0.2705882353, blue: 0.3568627451, alpha: 1))
        
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
    
}
