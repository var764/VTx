//
//  SFTwelveSurvey.swift
//  CardinalKit_Example
//
//  Created by Varun on 3/3/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import ResearchKit

struct SFTwelveSurvey {
    static let sfTwelveSurvey: ORKNavigableOrderedTask = {
        var steps = [ORKStep]()
        
        let instruction = ORKInstructionStep(identifier: "SF-12 Health Questionnaire")
        instruction.title = "SF-12 Health Survey"
        instruction.text = "Evaluate impact of patient health on everyday life."
    
        steps += [instruction]
        
        let form1 = ORKFormStep(identifier: "SF1-3",
                               title: """
                               SF-12 Survey
                               """,
                               text: """
                                    Questions 1 - 3.
                                    
                                    """)
        
        //Q1
        
        let generalChoices = [
            ORKTextChoice(text: "Excellent", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Very Good", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Good", value: 2 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Fair", value: 3 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Poor", value: 4 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        
        let generalChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: generalChoices)
        
        let general = ORKFormItem(identifier: "SF-1", text: "In general, would you say your health is: ", answerFormat: generalChoiceAnswerFormat)
        
        //Section Separator
        let separator_1 = ORKFormItem.init(sectionTitle: "The following questions are about activities you might do during a typical day.")
        let separator_1_5 = ORKFormItem.init(sectionTitle: "Does your health now limit you in these activities? If so, how much?")
        
        //Q2-3
        
        let limitChoices = [
            ORKTextChoice(text: "Yes, Limited A Lot", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Yes, Limited A Little", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "No, Not Limited At All", value: 2 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        
        
        let limitChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: limitChoices)
        
        let moderateActivity = ORKFormItem(identifier: "SF-2", text: "Does your health now limit you in moderate activities, such as moving a table, pushing a vacuum cleaner, bowling, or playing golf: ", answerFormat: limitChoiceAnswerFormat)
        
        let climbingStairs = ORKFormItem(identifier: "SF-3", text: "Does your health now limit you in climbing several flights of stairs: ", answerFormat: limitChoiceAnswerFormat)
        
        form1.formItems = [general, moderateActivity, climbingStairs]
        
        steps += [form1]
        
        let form2 = ORKFormStep(identifier: "SF4-5",
                                title: """
                                SF-12 Survey
                                """,
                                text: """
                                     Questions 4 - 5:
                                     
                                     """)
        
        //Q4-7
        
        let healthAnswerFormat = ORKAnswerFormat.booleanAnswerFormat()
        
        let separator_2 = ORKFormItem.init(sectionTitle: """
        
        During the past 4 weeks have you had any of the following problems with your work or other regular activities as a result of your physical health?
            
        """)
        
        let accomplishment_1 = ORKFormItem(identifier: "SF-4", text: "Accomplished less than you would like: ", answerFormat: healthAnswerFormat)
        
        let activityRange = ORKFormItem(identifier: "SF-5", text: "Were limited in the kind of work or other activities: ", answerFormat: healthAnswerFormat)
        
        let separator_3 = ORKFormItem.init(sectionTitle: """
        
        During the past 4 weeks, were you limited in the kind of work you do or other regular activities as a result of any emotional problems (such as feeling depressed or anxious)?
            
        """)
        
        let accomplishment_2 = ORKFormItem(identifier: "SF-6", text: "Accomplished less than you would like: ", answerFormat: healthAnswerFormat)
        
        let carefulness = ORKFormItem(identifier: "SF-7", text: "Didn’t do work or other activities as carefully as usual: ", answerFormat: healthAnswerFormat)
        
        //Q8
        
        let painInterferenceChoices = [
            ORKTextChoice(text: "Not At All", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "A Little Bit", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Moderately", value: 2 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Quite A Bit", value: 3 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Extremely", value: 4 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        
        let painInterferenceChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: painInterferenceChoices)
        
        let painInterference = ORKFormItem(identifier: "SF-8", text: "During the past 4 weeks, how much did pain interfere with your normal work (including both work outside the home and housework)?", answerFormat: painInterferenceChoiceAnswerFormat)
        
        form2.formItems = [separator_2, accomplishment_1, activityRange]
        
        steps += [form2]
        
        let form3 = ORKFormStep(identifier: "SF6-8",
                            title: """
                            SF-12 Survey
                            """,
                            text: """
                                 Questions 6 - 8:
                                 
                                 """)
        form3.formItems = [separator_3, accomplishment_2, carefulness, painInterference]
        
        steps += [form3]
        
        //Q9-12
        
        let form4 = ORKFormStep(identifier: "SF9-12",
                                title: """
                                SF-12 Survey
                                """,
                                text: """
                                     Questions 9 - 12:
                                     
                                     """)
        
        let separator_4 = ORKFormItem.init(sectionTitle: """

        The next three questions are about how you feel and how things have been during the past 4 weeks. For each question, please give the one answer that comes closest to the way you have been feeling. How much of the time during the past 4 weeks:

        """)
        
        let frequencyChoices = [
            ORKTextChoice(text: "All of the Time", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Most of the Time", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "A Good Bit of the Time", value: 2 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Some of the Time", value: 3 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "A Little of the Time", value: 4 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "None of the Time", value: 5 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        
        let frequencyChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: frequencyChoices)
        
        let calmness = ORKFormItem(identifier: "SF-9", text: "Have you felt calm and peaceful?", answerFormat: frequencyChoiceAnswerFormat)
        
        let energy = ORKFormItem(identifier: "SF-10", text: "Did you have a lot of energy?", answerFormat: frequencyChoiceAnswerFormat)
        
        let downhearted = ORKFormItem(identifier: "SF-11", text: "Have you felt downhearted and blue?", answerFormat: frequencyChoiceAnswerFormat)
        
        let socialActivity = ORKFormItem(identifier: "SF-12", text: "During the past 4 weeks, how much of the time has your physical health or emotional problems interfered with your social activities (like visiting with friends, relatives, etc.)?", answerFormat: frequencyChoiceAnswerFormat)
        
        form4.formItems = [separator_4, calmness, energy, downhearted, socialActivity]
        
        steps += [form4]
        
        let summary = ORKCompletionStep(identifier:"Summary")
        summary.title = "Thank you for completing the survey."
        summary.text = "We appreciate your input."
    
        steps += [summary]
        
        var task = ORKNavigableOrderedTask(identifier: "SFTwelveTask", steps: steps)
        
        return task
    }()
}
