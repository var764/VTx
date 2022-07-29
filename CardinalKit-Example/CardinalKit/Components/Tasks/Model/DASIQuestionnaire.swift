//
//  DASIQuestionnaire.swift
//  CardinalKit_Example
//
//  Created by Varun on 6/28/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import ResearchKit

struct DASIQuestionnaire {
    static let dasiQuestionnaire: ORKNavigableOrderedTask = {
        var steps = [ORKStep]()
        
        let instruction = ORKInstructionStep(identifier: "Duke Activity Status Index Questionnaire")
        instruction.title = "DASI Questionnaire"
        instruction.text = "Evaluate patient fitness & functional capacity."
    
        steps += [instruction]
        
        let form1 = ORKFormStep(identifier: "DASI1-5",
                               title: """
                               DASI Questionnaire
                               """,
                               text: """
                                    Questions 1 - 5.
                                    
                                    """)
        
        let dasiChoices = [
            ORKTextChoice(text: "No", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Yes", value: 1 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        
        let answerStyle = ORKChoiceAnswerStyle.singleChoice
        
        let dasiAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: answerStyle, textChoices: dasiChoices)
        
        //Q1
        
        let q1 = ORKFormItem(identifier: "DASI-1", text: "Can you take care of yourself (eating, dressing, bathing, or using the toilet)?", answerFormat: dasiAnswerFormat)
        
        //Q2
        
        let q2 = ORKFormItem(identifier: "DASI-2", text: "Can you walk indoors, such as around your house?", answerFormat: dasiAnswerFormat)
        
        //Q3
        
        let q3 = ORKFormItem(identifier: "DASI-3", text: "Can you walk a block or two on level ground?", answerFormat: dasiAnswerFormat)
        
        //Q4
        
        let q4 = ORKFormItem(identifier: "DASI-4", text: "Can you climb a flight of stairs or walk up a hill?", answerFormat: dasiAnswerFormat)
        
        //Q5
        
        let q5 = ORKFormItem(identifier: "DASI-5", text: "Can you run a short distance?", answerFormat: dasiAnswerFormat)
        
        form1.formItems = [q1, q2, q3, q4, q5]
        
        steps += [form1]
        
        let form2 = ORKFormStep(identifier: "DASI6-9",
                                title: """
                                DASI Questionnaire
                                """,
                                text: """
                                     Questions 6 - 9:
                                     
                                     """)
        
        //Q6
        
        let q6 = ORKFormItem(identifier: "DASI-6", text: "Can you do light work around the house, such as dusting or washing dishes?", answerFormat: dasiAnswerFormat)
        
        //Q7
        
        let q7 = ORKFormItem(identifier: "DASI-7", text: "Can you do moderate work around the house, such as vacuuming, sweeping floors, or carrying in groceries?", answerFormat: dasiAnswerFormat)
        
        //Q8
        
        let q8 = ORKFormItem(identifier: "DASI-8", text: "Can you do heavy work around the house, such as scrubbing floors or lifting and moving heavy furniture?", answerFormat: dasiAnswerFormat)
        
        //Q9
        
        let q9 = ORKFormItem(identifier: "DASI-9", text: "Can you do yard work, such as raking leaves, weeding, or pushing a power mower?", answerFormat: dasiAnswerFormat)
        
        form2.formItems = [q6, q7, q8, q9]
        
        steps += [form2]
        
        let form3 = ORKFormStep(identifier: "DASI10-12",
                            title: """
                            DASI Questionnaire
                            """,
                            text: """
                                 Questions 10 - 12:
                                 
                                 """)
        
        //Q10
        
        let q10 = ORKFormItem(identifier: "DASI-10", text: "Can you have sexual relations?", answerFormat: dasiAnswerFormat)
        
        //Q11
        
        let q11 = ORKFormItem(identifier: "DASI-11", text: "Can you participate in moderate recreational activities, such as golf, bowling, dancing, doubles tennis, or throwing a baseball or football?", answerFormat: dasiAnswerFormat)
        
        //Q12
        
        let q12 = ORKFormItem(identifier: "DASI-12", text: "Can you participate in strenuous sports, such as swimming, singles tennis, football, basketball, or skiing?", answerFormat: dasiAnswerFormat)
        
        form3.formItems = [q10, q11, q12]
        
        steps += [form3]
        
        let summary = ORKCompletionStep(identifier:"Summary")
        summary.title = "Thank you for completing the survey."
        summary.text = "We appreciate your input."
    
        steps += [summary]
        
        var task = ORKNavigableOrderedTask(identifier: "DASITask", steps: steps)
        
        return task
    }()
}
