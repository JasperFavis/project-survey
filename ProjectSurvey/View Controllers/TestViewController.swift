//
//  TestViewController.swift
//  ProjectSurvey
//
//  Created by Jasper Benedict Favis on 11/18/19.
//  Copyright © 2019 TeamOptional. All rights reserved.
//

import UIKit
import DLRadioButton

class TestViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //let testRadioButton = DLRadioButton()
    
    let sampleText = [
"what do you want to do on this nice hot sunny day. would you liketo go the beach and play in the cool water? would you like to go to the local ice cream shop? eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeffffffffffffffffffffffffffffffffffffffgggggggggggggggggggggghhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhiiiiiiiiiiiiiiiiiiiiii",
"this is just some sample text. nothing special. don'tpay any mind to my rambling."]
    
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            if let testCollectionView = testCollectionView {
                collectionLayout.estimatedItemSize = CGSize(width: testCollectionView.frame.width, height: 92)
            }
        }
    }
    @IBOutlet weak var testCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testCollectionView.delegate = self
        testCollectionView.dataSource = self
    }

    
    // MARK: Protocol Methods
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sampleText.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "testCell", for: indexPath) as? testCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.testLabel.text = sampleText[indexPath.row]
        cell.testView.layer.borderColor = UIColor.black.cgColor
        cell.testView.layer.borderWidth = 3.0
        cell.addButtons()
        return cell
    }
    
    
    
    
    // MARK: Functions
    

    


} // TestViewController




class testCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var answerView: UIView!
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        return layoutAttributes
    }
    
    // Programmatically add buttons
    func addButtons() {
         
         //first button
        let frame = CGRect(x: 50, y: 20, width: 262, height: 17);
        let firstRadioButton = createRadioButton(frame: frame, title: "Red Button", color: UIColor.red, currentView: answerView);
        //firstRadioButton.topAnchor.constraint(equalTo: answerView.topAnchor, constant: 50).isActive = true

        //other buttons
        let colorNames = ["Brown", "Orange", "Green", "Blue", "Purple"]
        let colors = [UIColor.brown, UIColor.orange, UIColor.green, UIColor.blue, UIColor.purple]
        var i = 0
        var otherButtons : [DLRadioButton] = []
        for color in colors {
            if i == 0 {
                let frame = CGRect(x: 50, y: 20 + firstRadioButton.frame.size.height + 13, width: 262, height: 17)
                let radioButton = createRadioButton(frame: frame, title: colorNames[i] + " Button", color: color, currentView: self.answerView)
                    otherButtons.append(radioButton)
            } else {
                let frame = CGRect(x: 50, y: 20 + firstRadioButton.frame.size.height + 13 + 30 * CGFloat(i), width: 262, height: 17)
                let radioButton = createRadioButton(frame: frame, title: colorNames[i] + " Button", color: color, currentView: self.answerView)
                otherButtons.append(radioButton)
            }

            i += 1
        }
        if otherButtons.count > 0 {
            otherButtons[otherButtons.count - 1].bottomAnchor.constraint(equalTo: answerView.bottomAnchor, constant: -20).isActive = true
        }
        // set other buttons for first radio button
        firstRadioButton.otherButtons = otherButtons;
        // set selection state programmatically
        firstRadioButton.otherButtons[1].isSelected = true;
    }


    func createRadioButton(frame : CGRect, title : String, color : UIColor, currentView: UIView) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame);
        radioButton.titleLabel!.font = UIFont.systemFont(ofSize: 14);
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
    }


} // TestCollectionViewCell
