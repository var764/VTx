//
//  OnboardingSurvey.swift
//  CardinalKit_Example
//
//  Created by Varun on 1/31/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import ResearchKit

struct OnboardingSurvey {
    static let onboardingSurvey: ORKNavigableOrderedTask = {
        var steps = [ORKStep]()
    
        let instruction = ORKInstructionStep(identifier: "Patient Onboarding Intro")
        instruction.title = "Patient Onboarding Survey"
        instruction.text = "Patient Onboarding"
    
        steps += [instruction]
    
        //1: DOB

        let dobAnswerFormat = ORKDateAnswerFormat.dateAnswerFormat()
        let dob = ORKFormItem(identifier: "DOB", text: "What is your date of birth?", answerFormat: dobAnswerFormat)
        
        //repeated display of question is resolved when converted to a question step
        //let dob = ORKQuestionStep(identifier: "DOB", title: nil, question: "What is your date of birth?", answer: dobAnswerFormat)
        //steps += [dob]
        
        // let dob = ORKFormItem(identifier: "DOB", text: "What is your date of birth?", detailText: "Tap to answer here", learnMoreItem: nil, showsProgress: false, answerFormat: dobAnswerFormat, tagText: "Tap 2", optional: false)

        //let test = ORKFormItem(identifier: "", text: "", detailText: "", learnMoreItem: nil, showsProgress: "", answerFormat: dobAnswerFormat, tagText: "", optional: false)
    
        //2: Gender
    
        let genderChoices = [
            ORKTextChoice(text: "Male", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Female", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Other", value: 2 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        
        let genderChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: genderChoices)
        
        let gender = ORKFormItem(identifier: "Gender", text: "What is your gender?", answerFormat: genderChoiceAnswerFormat)
        
        
        //Race/Ethnicity
        
        let ethnicityChoices = [
            ORKTextChoice(text: "American Indian or Alaska Native", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Asian", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Black or African American", value: 2 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Hispanic, Latino, or Spanish Origin", value: 3 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Middle Eastern or North African", value: 4 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Native Hawaiian or Other Pacific Islander", value: 5 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "White", value: 6 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Multiethnic", value: 7 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Prefer not to disclose", value: 8 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Other", value: 9 as NSCoding & NSCopying & NSObjectProtocol),
        ]
        
        let ethnicityChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: ethnicityChoices)
        
        let ethnicity = ORKFormItem(identifier: "Ethnicity", text: "Which best describes you?", answerFormat: ethnicityChoiceAnswerFormat)
        

        //Zip Code
        
        let zipCodeAnswerFormat = ORKAnswerFormat.textAnswerFormat(withMaximumLength: 5)
        
        let zipCode = ORKFormItem(identifier: "ZipCode", text: "What is your zip code (5 digits)?", answerFormat: zipCodeAnswerFormat)
        
        let divider = ORKFormItem.init(sectionTitle: "What is your zip code (5 digits)?")
        
        //3: Smoking Status
        
        let smokingStatusChoices = [
            ORKTextChoice(text: "Current Smoker", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Prior Smoker", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Never Smoked", value: 2 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        
        let smokingStatusAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: smokingStatusChoices)
        
        let smokingStatus = ORKFormItem(identifier: "SmokingStatus", text: "What is your smoking status?", answerFormat: smokingStatusAnswerFormat)
        
        let caregiverAnswerFormat = ORKAnswerFormat.booleanAnswerFormat(withYesString: "Yes, I have help to manage my health.", noString: "No, I manage my own health.")
        
        let caregiver = ORKFormItem(identifier: "Caregiver", text: "Do you have a caregiver?", answerFormat: caregiverAnswerFormat)
        
        let height = ORKFormItem(identifier: "Height", text: "What is your height?", answerFormat: ORKAnswerFormat.heightAnswerFormat())
        
        let divider2 = ORKFormItem.init(sectionTitle: "What is your height?")
        
        
        //ADD BMI CALC IN CONTROLLER
        let weight = ORKFormItem(identifier: "Weight", text: "What is your weight?", answerFormat: ORKAnswerFormat.weightAnswerFormat())
        
        let divider3 = ORKFormItem.init(sectionTitle: "What is your weight?")
        
        let diabetesChoices = [
            ORKTextChoice(text: "Insulin-Dependent Diabetes", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Non-insulin Dependent Diabetes", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "No", value: 2 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        let diabetesAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: diabetesChoices)
        
        let diabetes = ORKFormItem(identifier: "Diabetes", text: "Do you have diabetes?", answerFormat: diabetesAnswerFormat)
        
        let hypertensionAnswerFormat = ORKAnswerFormat.booleanAnswerFormat()
        let hypertension = ORKFormItem(identifier: "Hypertension", text: "Do you have hypertension?", answerFormat: hypertensionAnswerFormat)
        
        let heartFailureAnswerFormat = ORKAnswerFormat.booleanAnswerFormat()
        let heartFailure = ORKFormItem(identifier: "HeartFailure", text: "Do you have congestive heart failure?", answerFormat: heartFailureAnswerFormat)
        
        let cholesterolAnswerFormat = ORKAnswerFormat.booleanAnswerFormat()
        let cholesterol = ORKFormItem(identifier: "Cholesterol", text: "Do you have high cholesterol?", answerFormat: cholesterolAnswerFormat)
        
        //Form Aggregation
        
        let form = ORKFormStep(identifier: "Form", title: "Patient Onboarding",
                               text: """
                                    General Patient Info - Part 1.
                                    
                                    """)
        form.formItems = [dob, gender, ethnicity, divider, zipCode, smokingStatus, caregiver, divider2, height, divider3, weight]
        
        steps += [form]
        
     /*   let form2 = ORKFormStep(identifier: "Form2", title: "Patient Onboarding",
                                text: """
                                      General Patient Info - Part 2.
                                      """)
        
        form2.formItems = [height, divider, weight]
        steps += [form2] */
        
        let form3 = ORKFormStep(identifier: "Form2", title: "Patient Onboarding",
                                text: """
                                      Pre-Existing Conditions - Part 2.
                                      
                                      """)
        
        form3.formItems = [diabetes, hypertension, heartFailure, cholesterol]
        steps += [form3]
        
        //4: Planned Surgery Status
        
        let plannedSurgery = ORKQuestionStep(identifier:"PlannedSurgery", title:nil, question: "Do you have a planned surgery?", answer: ORKBooleanAnswerFormat(yesString: "Yes", noString: "No"))
            //ORKFormItem(identifier:"PlannedSurgery", text: "Do you have a planned surgery?", answerFormat: ORKAnswerFormat.booleanAnswerFormat())

        steps += [plannedSurgery]
        
        //5: Upcoming Procedure
        
        let procedureChoices = [
            ORKTextChoice(text: "Open / Hybrid Vascular Procedure", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Endovascular Procedure", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Open Colorectal Surgery", value: 2 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Laparoscopic Colorectal Surgery", value: 3 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Hepatectomy", value: 4 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Pancreatectomy", value: 5 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Pancreatoduodenectomy", value: 6 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoiceOther.choice(withText: "Other", detailText: "Additional Info", value: 7 as NSCoding & NSCopying & NSObjectProtocol, exclusive: false, textViewPlaceholderText: "")
        ]
        
        let upcomingProcedureAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .multipleChoice, textChoices: procedureChoices)
        
        let upcomingProcedure = ORKQuestionStep(identifier: "UpcomingProcedure", title: nil, question: "What type of procedure is being planned?", answer: upcomingProcedureAnswerFormat)
        
        steps += [upcomingProcedure]
        
        //5a: ABIs
        
        let abiAnswerFormat = ORKAnswerFormat.continuousScale(withMaximumValue: 2.00, minimumValue: 0.00, defaultValue: 1.00, maximumFractionDigits: 2, vertical: true, maximumValueDescription: "Max - 1.99, Non-compressible - 2", minimumValueDescription: "Min - 0.00")//ORKAnswerFormat.weightAnswerFormat(with: .USC, numericPrecision: .default, minimumValue: 0.00, maximumValue: 2.00, defaultValue: 1.12)//ORKAnswerFormat.decimalAnswerFormat(withUnit: "Ankle Brachial Index")
        
        let leftABI = ORKQuestionStep(identifier: "Left-ABI", title: nil, question: "Input your ABI - Left Side (Minimum 0.00 - Maximum 1.99, Enter 2 for 'Non-compressible')", answer: abiAnswerFormat)
        
        let rightABI = ORKQuestionStep(identifier: "Right-ABI", title: nil, question: "Input your ABI - Right Side (Minimum 0.00 - Maximum 1.99, Enter 2 for 'Non-compressible')", answer: abiAnswerFormat)
        
        steps += [leftABI, rightABI]
        
        //6: Medications
        
        let medChoices = [
            ORKTextChoice(text: "Aspirin", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Plavix", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Statin", value: 2 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Insulin", value: 3 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Warfarin", value: 4 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Other Blood Thinner", value: 5 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "None", value: 6 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        
        let medAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .multipleChoice, textChoices: medChoices)
        
        let medication = ORKQuestionStep(identifier: "Medication", title: nil, question: "Do you take any of the following medications?", answer: medAnswerFormat)
        
        steps += [medication]
        
        //7: Completion
        
        let summary = ORKCompletionStep(identifier:"Summary")
        summary.title = "Thank you for completing the survey."
        summary.text = "We appreciate your input."
    
        steps += [summary]
        
        
        //Configure conditional for Questions 4 & 5
        var task = ORKNavigableOrderedTask(identifier: "OnboardingTask", steps: steps)
        
        let resultSelector: ORKResultSelector = ORKResultSelector(resultIdentifier: plannedSurgery.identifier)
        let predicateFalse = ORKResultPredicate.predicateForBooleanQuestionResult(with: resultSelector, expectedAnswer: false)
        let predicateTrue = ORKResultPredicate.predicateForBooleanQuestionResult(with: resultSelector, expectedAnswer: true)
        let navRule = ORKPredicateStepNavigationRule(resultPredicatesAndDestinationStepIdentifiers: [(predicateFalse, task.step(withIdentifier: "Summary")!.identifier),
             (predicateTrue, task.step(withIdentifier: "UpcomingProcedure")!.identifier)]
        )
        
        //ORKPredicateSkipStepNavigationRule(resultPredicate: predicate)
        
        //task.setSkip(navRule, forStepIdentifier: upcomingProcedure.identifier)
        task.setNavigationRule(navRule, forTriggerStepIdentifier: plannedSurgery.identifier)
        
        
        let resultSelector2: ORKResultSelector = ORKResultSelector(resultIdentifier: upcomingProcedure.identifier)
        let predicate2a = ORKResultPredicate.predicateForChoiceQuestionResult(with: resultSelector2, expectedAnswerValue: 0 as NSCoding & NSCopying  & NSObjectProtocol)//matchingPattern: "Open / Hybrid Vascular Procedure")
        let predicate2b = ORKResultPredicate.predicateForChoiceQuestionResult(with: resultSelector2, expectedAnswerValue: 1 as NSCoding & NSCopying  & NSObjectProtocol)
        let predicate2c = ORKResultPredicate.predicateForChoiceQuestionResult(with: resultSelector2, expectedAnswerValue: 2 as NSCoding & NSCopying  & NSObjectProtocol)
        let predicate2d = ORKResultPredicate.predicateForChoiceQuestionResult(with: resultSelector2, expectedAnswerValue: 3 as NSCoding & NSCopying  & NSObjectProtocol)
        let predicate2e = ORKResultPredicate.predicateForChoiceQuestionResult(with: resultSelector2, expectedAnswerValue: 4 as NSCoding & NSCopying  & NSObjectProtocol)
        let predicate2f = ORKResultPredicate.predicateForChoiceQuestionResult(with: resultSelector2, expectedAnswerValue: 5 as NSCoding & NSCopying  & NSObjectProtocol)
        let predicate2g = ORKResultPredicate.predicateForChoiceQuestionResult(with: resultSelector2, expectedAnswerValue: 6 as NSCoding & NSCopying  & NSObjectProtocol)
        let predicate2h = ORKResultPredicate.predicateForChoiceQuestionResult(with: resultSelector2, expectedAnswerValue: 7 as NSCoding & NSCopying  & NSObjectProtocol)
        
        let navRule2 = ORKPredicateStepNavigationRule(resultPredicatesAndDestinationStepIdentifiers: [(predicate2a, task.step(withIdentifier: "Left-ABI")!.identifier),
            (predicate2b, task.step(withIdentifier: "Medication")!.identifier),
            (predicate2c, task.step(withIdentifier: "Medication")!.identifier),
            (predicate2d, task.step(withIdentifier: "Medication")!.identifier),
            (predicate2e, task.step(withIdentifier: "Medication")!.identifier),
            (predicate2f, task.step(withIdentifier: "Medication")!.identifier),
            (predicate2g, task.step(withIdentifier: "Medication")!.identifier),
            (predicate2h, task.step(withIdentifier: "Medication")!.identifier)]
        )
        
        task.setNavigationRule(navRule2, forTriggerStepIdentifier: upcomingProcedure.identifier)
        
        //ORKPredicateSkipStepNavigationRule(resultPredicate: predicate2)
        
       // task.setSkip(navRule2, forStepIdentifier: leftABI.identifier)
        
        return task
    
    }()
}
