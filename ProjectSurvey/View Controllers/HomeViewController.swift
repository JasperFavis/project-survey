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

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MFMailComposeViewControllerDelegate, surveyOptionsDelegate, modalHandler {
    func modalDismissed() {
        retrieveSurveyTitles()
        surveySelectionCollectionView.reloadData()
    }
    
    

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
        didSet {
            if segueToEdit { self.performSegue(withIdentifier: "editSegue", sender: nil) }
        }
    }
    var respondentData: [String: Any] = [:] {
        didSet {
            if segueToAnalytics { self.performSegue(withIdentifier: "analyticsSegue", sender: nil) }
        }
    }
    var segueToEdit      = false
    var segueToAnalytics = false
    var titleToDelete    = ""
    var docID            = "" {
        didSet {
            if docID != "" {
                // Delete survey document in Firestore
                self.db.collection("surveys").document(docID).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
                removeReferenceToSurvey(survey: titleToDelete)
                retrieveSurveyTitles()
                surveySelectionCollectionView.reloadData()
            }
        }
    }

    
    let cellColors = [#colorLiteral(red: 0.5452957422, green: 0.6533260308, blue: 0.56587294, alpha: 1), #colorLiteral(red: 0.4156862745, green: 0.4980392157, blue: 0.431372549, alpha: 1), #colorLiteral(red: 0.2503311738, green: 0.2999250856, blue: 0.2597776332, alpha: 1)]

    var mail: MFMailComposeViewController?
    
    // MARK: - OVERRIDES
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        segueToEdit      = false
        segueToAnalytics = false
        
        if segue.identifier == "editSegue" {
            let customizeVC = segue.destination as! CustomizeSurveyViewController
            
            customizeVC.surveyTitle         = surveyTitle
            customizeVC.questions           = questions
            customizeVC.questionsAndAnswers = questionsAndanswers
            customizeVC.editMode            = true
            customizeVC.modalDelegate       = self
 
        }
        
        if segue.identifier == "analyticsSegue" {
            let analyticsVC = segue.destination as! AnalyticsViewController
            
            analyticsVC.surveyTitle         = surveyTitle
            analyticsVC.questions           = questions
            analyticsVC.questionsAndanswers = questionsAndanswers
            analyticsVC.respondentData      = respondentData
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
        
        //view.setGradientBackground(colorOne: #colorLiteral(red: 0.9333333333, green: 0.9607843137, blue: 0.8588235294, alpha: 1), colorTwo: #colorLiteral(red: 0.3451896811, green: 0.3553423188, blue: 0.3176325218, alpha: 1))
        
        Utilities.styleHollowButton(newSurveyButton, with: #colorLiteral(red: 0.2352941176, green: 0.2823529412, blue: 0.2431372549, alpha: 1))

        surveySelectionCollectionView.delegate   = self
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
    
    // RETRIEVE QUESTIONS AND ANSWERS
    func retrieveQuestionsAndAnswers(survey title: String) {
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
    }
    
    
    // RETRIEVE respondent data
    func retrieveRespondentData(survey title: String) {
           surveys.getDocument { (document, error) in
        if let document = document, document.exists {
           
               var survey: DocumentReference!
               survey = document.get(title) as? DocumentReference
               
               survey.getDocument { (document, error) in
                   if let document = document, document.exists {
                    
                    self.respondentData = document.get("respondentData") as! [String: Any]
                    
                   }
               }
            } else {
               print("Document doesn't exist")
            }
        }
    }

    func deleteSurvey(survey title: String) {
        
        titleToDelete = title
        surveys.getDocument { (document, error) in
            if let document = document, document.exists {
               
                var survey: DocumentReference!
                survey = document.get(title) as? DocumentReference

                self.docID = survey.documentID
                
            } else {
               print("Document doesn't exist")
            }
        }
    }
    
    func removeReferenceToSurvey(survey title: String) {
        
        surveys.updateData([
            title: FieldValue.delete(),
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func createDeleteAlert(title: String, message: String, survey: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            self.deleteSurvey(survey: survey)
        }))

        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            print("Do not delete survey")
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - PROTOCOL METHODS for UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return surveyTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SurveyCell", for: indexPath) as! SurveySelectionCollectionViewCell
        
        cell.optionsDelegate = self
        cell.backgroundColor = cellColors[indexPath.row % cellColors.count]
        //cell.setGradientBackground(colorOne: #colorLiteral(red: 0.3731940283, green: 0.3951466182, blue: 0.3951466182, alpha: 1), colorTwo: #colorLiteral(red: 0.2, green: 0.2117647059, blue: 0.2117647059, alpha: 1))
        cell.surveyTitleLabel.text = surveyTitles[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Show how the actual survey looks
        print("cell selected")
    }
    
    
    // MARK: - PROTOCOL METHODS for surveyOptionsDelegate
    
    // EDIT
    func selectedEdit(forSurvey title: String) {
        
        segueToEdit = true
        
        retrieveQuestionsAndAnswers(survey: title)
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
    
    
    // ANALYTICS
    func selectedAnalytics(forSurvey title: String) {
        
        segueToAnalytics = true
        
        retrieveQuestionsAndAnswers(survey: title)
        retrieveRespondentData(survey: title)
        
    }
    
    func selectedDelete(forSurvey title: String) {
        
        createDeleteAlert(title: "Are you sure you want to delete \"\(title)\"?", message: "", survey: title)
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
