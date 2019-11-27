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
import MessageUI

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MFMailComposeViewControllerDelegate, surveyOptionsDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var newSurveyButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var surveyTitleLabel: UILabel!
    @IBOutlet weak var surveySelectionCollectionView: UICollectionView!
    
    
    // MARK: - PROPERTIES
    
    let db = Firestore.firestore()
    var surveys: DocumentReference!
    var surveyTitles: [String] = [] {
        didSet { surveySelectionCollectionView.reloadData() }
    }
    var surveyTitle: String = ""
    var questions: [String] = []
    var questionsAndanswers: [String: [String]?] = [:] {
        didSet { segueToEdit = true }
    }
    var segueToEdit = false {
        didSet { self.performSegue(withIdentifier: "editSegue", sender: nil) }
    }
    var mail: MFMailComposeViewController?
    
    // MARK: - OVERRIDES
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue" {
            let customizeVC = segue.destination as! CustomizeSurveyViewController
            
            customizeVC.surveyTitle = surveyTitle
            customizeVC.questions = questions
            customizeVC.questionsAndAnswers = questionsAndanswers
            customizeVC.editMode = true
        }
    }
    
    // MARK: - IBActions
    
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
    
    
    // MARK: - FUNCTIONS
    
    // INITIAL SETUP
    func setUpElements() {
        
        view.setGradientBackground(colorOne: #colorLiteral(red: 0.631372549, green: 0.8274509804, blue: 0.8980392157, alpha: 1), colorTwo: #colorLiteral(red: 0.3098039216, green: 0.4078431373, blue: 0.4431372549, alpha: 1))
        Utilities.styleHollowButton(logoutButton)
        Utilities.styleFilledButton(newSurveyButton)

        surveySelectionCollectionView.delegate = self
        surveySelectionCollectionView.dataSource = self
        
        retrieveSurveyTitles()
    }
    
    // RETRIEVE survey titles to display in collection view
    func retrieveSurveyTitles() {
        
        // Get user ID
        if let currUID = Auth.auth().currentUser?.uid {
            
            // Get reference to user's surveys
            let surveyTitlesDocRef = db.collection("users").document(currUID).collection("SID storage").document("Survey Titles")
            
            surveys = surveyTitlesDocRef
            
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
    
    
    // MARK: - PROTOCOL METHODS for UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return surveyTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SurveyCell", for: indexPath) as! SurveySelectionCollectionViewCell
        
        cell.optionsDelegate = self
        cell.setGradientBackground(colorOne: #colorLiteral(red: 0.3725271624, green: 0.490415505, blue: 0.5328553082, alpha: 1), colorTwo: #colorLiteral(red: 0.2439439026, green: 0.3211413401, blue: 0.3489324176, alpha: 1))
        cell.surveyTitleLabel.text = surveyTitles[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Show how the actual survey looks
        print("cell selected")
    }
    
    
    // MARK: - PROTOCOL METHODS for editSurveyDelegate
    
    // EDIT
    func selectedEdit(forSurvey title: String) {
        
        surveys.getDocument { (document, error) in
            if let document = document, document.exists {
                
                var survey: DocumentReference!
                survey = document.get(title) as? DocumentReference
                
                survey.getDocument { (document, error) in
                    if let document = document, document.exists {
                    
                        // Save survey title
                        self.surveyTitle = document.get("title") as! String
                        
                        // Save questions
                        self.questions = document.get("questions") as! [String]
                        
                        // Save questions and answers
                        self.questionsAndanswers = document.get("questionsAndanswers") as! [String: [String]?]
                    }
                }
            } else {
                print("Document doesn't exist")
            }
        }
    } // SelectedEdit
    
    // INVITE
    func selectedInvite(forSurvey title: String) {
        print("Selected Invite")
        
        // MAKE canSendMail() return true FOR SIMULATOR:
        // iPhone -> Settings -> Passwords & Accounts -> Add Account -> Add Mail Account
        // For Gmail using IMAP:
        // Incoming Mail Server: Host Name: imap.gmail.com
        // Username and password: email you're adding and corresponding password
        // Outgoing Mail Server: Host Name: smtp.gmail.com
        guard MFMailComposeViewController.canSendMail() else {
            print("Cannot send mail")
            return
        }
        
        mail = nil
        mail = MFMailComposeViewController()
        guard let mail = mail else {
            return
        }
        mail.mailComposeDelegate = self
        mail.setToRecipients(["favisjasper@gmail.com"])
        mail.setSubject("Test Message")
        mail.setMessageBody("What's up?", isHTML: false)
        
        present(mail, animated: true)
    }
    
    // MARK: - PROTOCOL METHODS for MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {

        if let _ = error {
            controller.dismiss(animated: true, completion: nil)
            return
        }

        switch result {
        case .cancelled: print("cancelled")
        case .failed: print("failed")
        case .saved: print("saved")
        case .sent: print("sent")
        default: print("default")
        }

        controller.dismiss(animated: true, completion: nil)
    }
    
    
} // HomeViewControllers




// MARK: - EXTENSION for UIView

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
