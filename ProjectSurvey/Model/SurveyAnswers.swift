//
//  SurveyAnswers.swift
//  ProjectSurvey
//
//  Created by Jasper Benedict Favis on 11/22/19.
//  Copyright © 2019 TeamOptional. All rights reserved.
//

import Foundation

class SurveyAnswers {
    
    static var answers: [Any?] = []
    init(to questionCount: Int) {
        SurveyAnswers.answers = Array(repeatElement(nil, count: questionCount))
    }

}
