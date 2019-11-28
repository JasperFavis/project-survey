//
//  ChartViewController.swift
//  ProjectSurvey
//
//  Created by Jasper Benedict Favis on 11/27/19.
//  Copyright © 2019 TeamOptional. All rights reserved.
//

import UIKit
import SwiftCharts

class AnalyticsViewController: UIViewController {


    // MARK: - IBOUTLETS
    
    @IBOutlet weak var chartContainer: UIView!
    

    
    // MARK: - PROPERTIES
    
    var surveyTitle: String                      = ""
    var questions: [String]                      = []
    var questionsAndanswers: [String: [String]?] = [:]
    var respondentData: [String: Any]            = [:]
    var index                                    = 0
    
    var chartView: BarsChart!
    
    // TEST DATA
    var data = [
        [20,45,87,100,12],
        [300,45,324,123,290],
        [123,45,23,123,234,98,74]
    ]
    
    
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
    
    @IBAction func newData(_ sender: Any) {
        
        index = (index + 1) % data.count
        
        clearChart()
        displayData()
    }
    
    
    // MARK: - FUNCTIONS
    
    func setupElements() {
        displayData()
        view.setGradientBackground(colorOne: #colorLiteral(red: 0.7170763175, green: 0.7592572774, blue: 0.7592572774, alpha: 1), colorTwo: #colorLiteral(red: 0.2, green: 0.2117647059, blue: 0.2117647059, alpha: 1))
    }
    
    
    func displayData() {
        
        let question = questions[index]
        
        if let multChoiceAns = questionsAndanswers[question] {
            
            let multChoiceData = respondentData[question] as! [Int]
            createChart(multChoiceData)
        } else {
            createChart(data[index])
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

}
