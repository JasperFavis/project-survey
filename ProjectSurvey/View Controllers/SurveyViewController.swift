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

class SurveyViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    
    let testRadioButton = DLRadioButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
    }
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func setUpElements() {
        view.setGradientBackground(colorOne: #colorLiteral(red: 0.631372549, green: 0.8274509804, blue: 0.8980392157, alpha: 1), colorTwo: #colorLiteral(red: 0.3098039216, green: 0.4078431373, blue: 0.4431372549, alpha: 1))
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
