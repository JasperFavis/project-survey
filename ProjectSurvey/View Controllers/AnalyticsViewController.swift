//
//  ChartViewController.swift
//  ProjectSurvey
//
//  Created by Jasper Benedict Favis on 11/27/19.
//  Copyright © 2019 TeamOptional. All rights reserved.
//

import UIKit
import SwiftCharts

class AnalyticsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    // MARK: - IBOUTLETS
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var chartContainer: UIView!
 
    @IBOutlet weak var textAnswersCollectionView: UICollectionView!
    
    
    // MARK: - PROPERTIES
    
    var surveyTitle: String                      = ""
    var questions: [String]                      = []
    var questionsAndanswers: [String: [String]?] = [:]
    var respondentData: [String: Any]            = [:]
    var index                                    = 0
    var numberOfAnswers                          = 0
    var textAnswers: [String]                    = []
    let cellColors                               = [#colorLiteral(red: 0.4156862745, green: 0.4980392157, blue: 0.431372549, alpha: 1), #colorLiteral(red: 0.2503311738, green: 0.2999250856, blue: 0.2597776332, alpha: 1)]
    
    var chartView: BarsChart!
    
    // TEST DATA
//    var data = [
//        [20,45,87,100,12],
//        [300,45,324,123,290],
//        [123,45,23,123,234,98,74]
//    ]
    
    
    // MARK: - OVERRIDES
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupElements()
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
    
    
    // MARK: - IBACTIONS
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func prevButtonTapped(_ sender: Any) {
        index = (index - 1 + questions.count) % questions.count
        
        clearChart()
        displayData()
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        index = (index + 1) % questions.count
        
        clearChart()
        displayData()
    }
    
    // MARK: - FUNCTIONS
    
    func setupElements() {
        displayData()
        view.setGradientBackground(colorOne: #colorLiteral(red: 0.9333333333, green: 0.9607843137, blue: 0.8588235294, alpha: 1), colorTwo: #colorLiteral(red: 0.3451896811, green: 0.3553423188, blue: 0.3176325218, alpha: 1))
        headerView.setGradientBackground(colorOne: #colorLiteral(red: 0.4156862745, green: 0.4980392157, blue: 0.431372549, alpha: 1), colorTwo: #colorLiteral(red: 0.2352941176, green: 0.2823529412, blue: 0.2431372549, alpha: 1))
        
        titleLabel.text                      = surveyTitle
        textAnswersCollectionView.delegate   = self
        textAnswersCollectionView.dataSource = self
    }
    
    
    func displayData() {
        
        let question = questions[index]
        
        questionLabel.text = "\(index + 1). \(question)"
        
        if let multChoiceAns = questionsAndanswers[question] {
            
            chartContainer.isHidden            = false
            textAnswersCollectionView.isHidden = true
            let multChoiceData = respondentData[question] as! [Int]
            createChart(multChoiceData)
        } else {
            // createChart(data[index])
            chartContainer.isHidden            = true
            textAnswers.removeAll()
            textAnswers = respondentData[question] as! [String]
            numberOfAnswers = textAnswers.count
            textAnswersCollectionView.isHidden = false
            textAnswersCollectionView.reloadData()
        }
    }

    func createChart(_ array: [Int]) {
        
        var data: [(index: String, value: Double)] = []
        
        let maxValue: Double      = Double(array.max() ?? 100)
        let numberOfLines: Double = 6
        let interval              = (maxValue < 6) ? 1 : Int(maxValue / numberOfLines)
        let maxTick: Double       = maxValue + Double(interval)
        
        for i in 0..<array.count {
            data.append(("\(i + 1)", Double(array[i])))
        }
        
        
        let chartConfig = BarsChartConfig (valsAxisConfig: ChartAxisConfig(from: 0, to: maxTick, by: Double(interval)))
        
        let frame = CGRect(x: 0, y: 0, width: self.chartContainer.frame.width, height: self.chartContainer.frame.height)
        
        let chart = BarsChart(frame: frame, chartConfig: chartConfig, xTitle: "Answers", yTitle: "Number of times selected", bars:  data, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), barWidth: 15)

        self.chartContainer.addSubview(chart.view)
        self.chartView = chart
        
    } // createChart
    
    func clearChart() {
        chartView = nil
        chartContainer.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    
    // MARK: - PROTOCOL METHODS FOR COLLECTION VIEW
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let answerheight = 25 + DynamicLabelSize.height(text: textAnswers[indexPath.row], font: UIFont.systemFont(ofSize: 20), width: textAnswersCollectionView.frame.width - 40)
        
        return CGSize(width: textAnswersCollectionView.frame.width, height: answerheight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfAnswers
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = textAnswersCollectionView.dequeueReusableCell(withReuseIdentifier: "textAnswer", for: indexPath) as! TextAnswerCollectionViewCell
        
        cell.textAnswerLabel.text = textAnswers[indexPath.row]
        cell.backgroundColor = cellColors[indexPath.row % cellColors.count]
        
        return cell
    }

} // ANALYTICS VIEW CONTROLLER
