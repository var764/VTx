//
//  RAISurvey.swift
//  CardinalKit_Example
//
//  Created by Varun on 6/28/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import ResearchKit

struct RAISurvey {
    static let raiSurvey: ORKNavigableOrderedTask = {
        var steps = [ORKStep]()
        
        let instruction = ORKInstructionStep(identifier: "Risk Analysis Index Screening")
        instruction.title = "RAI Screening"
        instruction.text = "Evaluate patient fitness & functional capacity."
    
        steps += [instruction]
        
        //Demographics
        
        let age = ORKQuestionStep(identifier: "Age", title: "Basic Information", question: "Please enter your age", answer: ORKNumericAnswerFormat.integerAnswerFormat(withUnit: "years"))
        
        age.placeholder = "Tap to answer here."
        
        steps += [age]
        
        
        let genderChoices = [
            ORKTextChoice(text: "Male", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Female", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Other", value: 2 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        
        let genderChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: genderChoices)
        
        let gender = ORKQuestionStep(identifier: "Gender", title: "Basic Information", question: "What is your gender?", answer: genderChoiceAnswerFormat)

        steps += [gender]
        
        //Residence Question
        
        let home = ORKQuestionStep(identifier:"Home", title:"""
                                      Residence Details
                                      
                                      """, question: "Do you live in a place other than your own home?", answer: ORKBooleanAnswerFormat(yesString: "Yes", noString: "No"))
        
        steps += [home]
        
        //Alternate Home Form
        
        let altHomeChoices = [
            ORKTextChoice(text: "Nursing Home", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Skilled Nursing Facility", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Assisted Living", value: 2 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoiceOther.choice(withText: "Other", detailText: "Additional Info", value: 3 as NSCoding & NSCopying & NSObjectProtocol, exclusive: false, textViewPlaceholderText: "")
        ]
        
        let altHomeAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: altHomeChoices)
        
        let alternateHome = ORKFormItem(identifier: "AlternateHome", text: "Which best describes where you currently live?", answerFormat: altHomeAnswerFormat)
        
        
        let livingDurationChoices = [
            ORKTextChoice(text: "< 3 months", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "3 months - 1 year", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "> 1 year", value: 2 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        
        let livingDurationAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: livingDurationChoices)
        
        let livingDuration = ORKFormItem(identifier: "LivingDuration", text: "When did you begin living in the place you are currently residing", answerFormat: livingDurationAnswerFormat)
        
        
        let altHomeForm = ORKFormStep(identifier: "AltHomeForm", title: "RAI Screening",
                                      text: """
                                           Residence Details
                                           
                                           """)
        
        
        altHomeForm.formItems = [alternateHome, livingDuration]
               
        steps += [altHomeForm]
        
        
        //Medical Conditions
        
        //Kidney Issues
        
        
        let kidneyChoices = [
            ORKTextChoice(text: "Yes - Nephrologist visit was for kidney stones", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Yes - Other", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Yes - Both kidney stones and other problem", value: 2 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "No", value: 3 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        
        let kidneyAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: kidneyChoices)
        
        let kidney = ORKFormItem(identifier: "Kidney", text: "Any kidney failure, kidney not working well, or seeing a kidney doctor (nephrologist)?", answerFormat: kidneyAnswerFormat)
        
        
        //CHF
        
        
        let chf = ORKFormItem(identifier: "CHF", text: "Any history of chronic (long-term) congestive heart failure (CHF)?", answerFormat: ORKAnswerFormat.booleanAnswerFormat())
        
        
        //Shortness of breath
        
        let breath = ORKFormItem(identifier:"Breath", text: "Any shortness of breath when resting?", answerFormat: ORKAnswerFormat.booleanAnswerFormat())
        
        breath.detailText = "Do you have trouble catching your breath when resting or doing minimal activities, like walking to the bathroom?" //repl with description if needed
        
        
        //Cancer History
        
        let cancerHistory = ORKFormItem(identifier: "CancerHistory", text: "In the past five years, have you been diagnosed with or treated for cancer?", answerFormat: ORKAnswerFormat.booleanAnswerFormat())
        
        
        let medConditionsForm = ORKFormStep(identifier: "MedicalConditionsForm", title: "RAI Screening",
                                      text: """
                                           Medical Conditions
                                           
                                           """)
        
        
        medConditionsForm.formItems = [kidney, chf, breath, cancerHistory]
               
        steps += [medConditionsForm]
        
        
        //Nutrition
        
        //Weight Loss
        
        let weightLoss = ORKFormItem(identifier:"WeightLoss", text: "Have you lost 10 pounds or more weight in the past 3 months without trying?", answerFormat: ORKAnswerFormat.booleanAnswerFormat())
        
        weightLoss.detailText = "Are your clothes feeling looser than in the past?" //repl with description if needed
        
        //Appetite
        
        let appetite = ORKFormItem(identifier:"Appetite", text: "Do you have any loss of appetite?", answerFormat: ORKAnswerFormat.booleanAnswerFormat())
        
        appetite.detailText = "Do you or your family notice that you are not eating as much?" //repl with description if needed
        
        let nutritionForm = ORKFormStep(identifier: "NutritionForm", title: "RAI Screening",
                                      text: """
                                           Nutrition
                                           
                                           """)
        
        
        nutritionForm.formItems = [weightLoss, appetite]
               
        steps += [nutritionForm]
        
        //Cognitive
        
        let cognitive = ORKFormItem(identifier: "Cognitive", text: "During the last 3 months has it become difficult for you to remember things or organize your thoughts?", answerFormat: ORKAnswerFormat.booleanAnswerFormat())
        
        let cognitiveForm = ORKFormStep(identifier: "CognitiveForm", title: "RAI Screening",
                                      text: """
                                           Cognitive
                                           
                                           """)
        
        
        cognitiveForm.formItems = [cognitive]
               
        steps += [cognitiveForm]
        
        
        //Activities of Daily Living
        
        let mobilityChoices = [
            ORKTextChoice(text: "Can get around without any help", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Needs help from a cane, walker or scooter", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Needs help from others to get around the house or neighborhood", value: 2 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Needs help getting in or out of a chair", value: 3 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Totally dependent on others to get around", value: 4 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        
        let mobilityAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: mobilityChoices)
        
        let mobility = ORKFormItem(identifier: "Mobility", text: "Please select the option which best describes your mobility (ability to get around).", answerFormat: mobilityAnswerFormat)
        
        
        
        let eatingChoices = [
            ORKTextChoice(text: "Can plan and prepare own meals", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Needs help planning meals", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Needs help preparing meals", value: 2 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Needs help eating meals", value: 3 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Totally dependent on others to eat meals", value: 4 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        
        let eatingAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: eatingChoices)
        
        let eating = ORKFormItem(identifier: "Eating", text: "Please select the option which best describes your eating.", answerFormat: eatingAnswerFormat)
        
        
        
        let toiletingChoices = [
            ORKTextChoice(text: "Can use toilet without help", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Needs help getting to or from toilet", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Needs help to use toilet paper", value: 2 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Cannot use a standard toilet, with help can use bedpan/urinal", value: 3 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Totally dependent on others for toileting", value: 4 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        
        let toiletingAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: toiletingChoices)
        
        let toileting = ORKFormItem(identifier: "Toileting", text: "Please select the option which best describes your toilet use.", answerFormat: toiletingAnswerFormat)
        
        
        
        let hygeineChoices = [
            ORKTextChoice(text: "Can shower or bathe without prompt or help", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Can shower or bathe without help when prompted", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Needs help preparing the tub or shower", value: 2 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Needs some help with some elements of washing", value: 3 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Totally dependent on others to shower or bathe", value: 4 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        
        let hygeineAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: hygeineChoices)
        
        let hygeine = ORKFormItem(identifier: "Hygeine", text: "Please select the option which best describes your personal hygeine.", answerFormat: hygeineAnswerFormat)
        
        
        let activitiesForm = ORKFormStep(identifier: "ActivitiesForm", title: "RAI Screening",
                                      text: """
                                           Activities of Daily Living
                                           
                                           """)
        
        
        activitiesForm.formItems = [mobility, eating, toileting, hygeine]
               
        steps += [activitiesForm]
        
        
        let summary = ORKCompletionStep(identifier:"Summary")
        summary.title = "Thank you for completing the survey."
        summary.text = "We appreciate your input."
    
        steps += [summary]
        
        var task = ORKNavigableOrderedTask(identifier: "RAITask", steps: steps)

        
        let resultSelector: ORKResultSelector = ORKResultSelector(resultIdentifier: home.identifier)
        let predicateFalse = ORKResultPredicate.predicateForBooleanQuestionResult(with: resultSelector, expectedAnswer: false)
        let predicateTrue = ORKResultPredicate.predicateForBooleanQuestionResult(with: resultSelector, expectedAnswer: true)
        
        let navRule = ORKPredicateStepNavigationRule(resultPredicatesAndDestinationStepIdentifiers: [(predicateFalse, task.step(withIdentifier: "MedicalConditionsForm")!.identifier),
             (predicateTrue, task.step(withIdentifier: "AltHomeForm")!.identifier)]
        )
        
        //ORKPredicateSkipStepNavigationRule(resultPredicate: predicate)
        
        //task.setSkip(navRule, forStepIdentifier: upcomingProcedure.identifier)
        task.setNavigationRule(navRule, forTriggerStepIdentifier: home.identifier)
        
        
        return task
        
        
        
     /*   let form1 = ORKFormStep(identifier: "DASI1-5",
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
        
        steps += [form3] */
        
    }()
}
