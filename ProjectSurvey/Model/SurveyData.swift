//
//  SurveyData.swift
//  ProjectSurvey
//
//  Created by Jasper Benedict Favis on 11/12/19.
//  Copyright © 2019 TeamOptional. All rights reserved.
//

import Foundation

struct SurveyData {
    var title: String
    var questions: [String] = []
    
    init(title t: String, questions q: [String]) {
        title = t
        questions = q
    }
}
