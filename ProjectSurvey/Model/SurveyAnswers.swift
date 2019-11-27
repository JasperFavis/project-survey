//
//  SurveyAnswers.swift
//  ProjectSurvey
//
//  Created by Jasper Benedict Favis on 11/22/19.
//  Copyright © 2019 TeamOptional. All rights reserved.
//

import Foundation

class SurveyAnswers {
    
    // MARK: - Properties
    
    static var submitDelegate: EnableSubmitDelegate!
    
    static var answers: [Any?] = []
    static var respondentAnswers: [String?] = [] {
        didSet {
            // Every time an answer is saved, notify SurveyViewController to check if survey
            // has been answered completely
            submitDelegate.enableSubmitButtonIfSurveyComplete()
        }
    }
    
    // MARK: - Initializers
    
    init(to questionCount: Int) {
        SurveyAnswers.answers = Array(repeatElement(nil, count: questionCount))
        SurveyAnswers.respondentAnswers = Array(repeating: nil, count: questionCount)
    }

}  // SurveyAnswers


// MARK: - PROTOCOL EnableSubmitDelegate

// Notify SurveyViewController to check if survey is completed
protocol EnableSubmitDelegate {
    func enableSubmitButtonIfSurveyComplete()
}
