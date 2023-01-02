//
//  WIQSurvey.swift
//  CardinalKit_Example
//
//  Created by Varun on 2/20/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import ResearchKit

struct WIQSurvey {
    static let wiqSurvey: ORKNavigableOrderedTask = {
        var steps = [ORKStep]()
    
        let instruction = ORKInstructionStep(identifier: "WIQ")
        instruction.title = "Walking Impairment Questionnaire"
        instruction.text = "Patient Mobility Assessment"
        
        steps += [instruction]
    
        //1: wiq form

        let wiqChoices = [
            ORKTextChoice(text: "No Difficulty", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Slight Difficulty", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Some Difficulty", value: 2 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Much Difficulty", value: 3 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Unable to Do", value: 4 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        
        let answerStyle = ORKChoiceAnswerStyle.singleChoice
        
        let wiqAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: answerStyle, textChoices: wiqChoices)
        
        //Q1:
        let wiq1 = ORKFormItem(identifier: "WIQ Endurance 1", text: "Walk indoors, such as around your home?", answerFormat: wiqAnswerFormat)
        
        //Q2:
        
        let wiq2 = ORKFormItem(identifier: "WIQ Endurance 2", text: "Walk 50 feet?", answerFormat: wiqAnswerFormat)
        
        //Q3:
        
        let wiq3 = ORKFormItem(identifier: "WIQ Endurance 3", text: "Walk 150 feet? (1/2 block)?", answerFormat: wiqAnswerFormat)
        
        //Q4:
        
        let wiq4 = ORKFormItem(identifier: "WIQ Endurance 4", text: "Walk 300 feet? 1 block?", answerFormat: wiqAnswerFormat)
        
        //Q5:
        
        let wiq5 = ORKFormItem(identifier: "WIQ Endurance 5", text: "Walk 600 feet? 2 blocks?", answerFormat: wiqAnswerFormat)
        
        //Q6:
        
        let wiq6 = ORKFormItem(identifier: "WIQ Endurance 6", text: "Walk 900 feet? 3 blocks?", answerFormat: wiqAnswerFormat)
        
        //Q7:
        
        let wiq7 = ORKFormItem(identifier: "WIQ Endurance 7", text: "Walk 1500 feet? 5 blocks?", answerFormat: wiqAnswerFormat)
        
        //Form Aggregation
        
        let form = ORKFormStep(identifier: "WIQForm",
                               title: "Walking Impairment Questionnaire",
                               text: """
                                    How difficult was it for you to:
                                    
                                    """)
        form.formItems = [wiq1, wiq2, wiq3, wiq4, wiq5, wiq6, wiq7]
        steps += [form]

        //6: Completion
        
        let summary = ORKCompletionStep(identifier:"Summary")
        summary.title = "Thank you for completing the survey."
        summary.text = "We appreciate your input."
        steps += [summary]
        
        var task = ORKNavigableOrderedTask(identifier: "WIQTask", steps: steps)
        
        return task
    
    }()
}

//add WIQ Score calc//
/*
 SCORING SCHEMA FOR WIQ Endurance / Walking Questionnaire (second set of questions)
 Remove the answer, “didn’t do for other reasons”
 For “No difficulty” give weight of 5
 For “slight difficulty” give weight of 4
 For “some difficulty” give weight of 3
 For “much difficulty” give weight of 2
 For “unable to do” give weight of 1

 -> for the first question, “Walk indoors such as around your home” provide a score of “5” to “1”
 -> for the remaining questions multiply the weight from the answer by the distance being queried.
 -> add all these multiplied results for all distances up and divide by the maximum possible number (17,500), multiply by 100 to give you a “percent” result.
 */


/*
    let taskResult = taskViewController.result.results
    let identifiers = ["WIQ Endurance 1", "WIQ Endurance 2", "WIQ Endurance 3", "WIQ Endurance 4", "WIQ Endurance 5", "WIQ Endurance 6", "WIQ Endurance 7"]
    let distWeights = [1, 50, 150, 300, 600, 900, 1500]
    var wiqScore = 0
    for stepResults in taskResult! as! [ORKStepResult]
    {
        for result in stepResults.results!
        {
            if identifiers.contains(result.identifier) {
                let index = identifiers.firstIndex(of: result.identifier)
                wiqScore += ((5 - Int(result)) * distWeights[index!])
            }

        }
    }
    wiqScore = (wiqScore/17500) * 100
} */
