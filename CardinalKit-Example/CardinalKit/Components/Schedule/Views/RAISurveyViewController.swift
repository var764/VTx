//
//  DASIQuestionnaireViewController.swift
//  CardinalKit_Example
//
//  Created by Varun on 6/28/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//


import Foundation
import CareKit
import ResearchKit
import CareKitUI
import CareKitStore
import SwiftUI

// 1. Subclass a task view controller to customize the control flow and present a ResearchKit survey!
class RAISurveyViewController: OCKInstructionsTaskViewController, ORKTaskViewControllerDelegate {

    // 2. This method is called when the use taps the button!
    override func taskView(_ taskView: UIView & OCKTaskDisplayable, didCompleteEvent isComplete: Bool, at indexPath: IndexPath, sender: Any?) {

        // 2a. If the task was marked incomplete, fall back on the super class's default behavior or deleting the outcome.
        if !isComplete {
            super.taskView(taskView, didCompleteEvent: isComplete, at: indexPath, sender: sender)
            return
        }

        // 2b. If the user attempted to mark the task complete, display a ResearchKit survey.
        
        //let surveyViewController = ORKTaskViewController(task: OnboardingSurvey.onboardingSurvey, taskRun: nil)
        let raiQViewController = ORKTaskViewController(task: RAISurvey.raiSurvey, taskRun: nil)
        raiQViewController.delegate = self

        // 3a. Present the survey to the user
        present(raiQViewController, animated: false, completion: nil)
    }

    // 3b. This method will be called when the user completes the survey.
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        taskViewController.dismiss(animated: false, completion: nil)
        guard reason == .completed else {
            taskView.completionButton.isSelected = false
            return
        }
        // 4a. Retrieve the result from the ResearchKit survey
        
        var dict: [String: Int] = [:]
        
        if let results = taskViewController.result.results as? [ORKStepResult] {
            //print("\(results)")
            for stepResult : ORKStepResult in results {
                for result in stepResult.results as! [ORKResult] {
                    
                    if let questionResult = result as? ORKQuestionResult
                    {
                        //print("\(questionResult.identifier), \(questionResult.answer)")
                        var answer = 0
                        if let answerArr = questionResult.answer as? NSArray {
                            answer = answerArr[0] as? Int ?? 0
                        }
                        else {
                            answer = questionResult.answer as? Int ?? 0
                        }
                        //print(answer)
                        dict[questionResult.identifier as! String] = Int(answer)
                    }
                    
                }
                
            }
            
        }
        
        for (k, v) in dict {
            print("\(k) \t \(v)")
        }
        
        var rai = 0
        
        //ADD GENDER - IF  MALE +3
        if dict["Gender"] == 0 {
            rai += 3
        }
        if dict["WeightLoss"] == 1 {
            rai += 4
        }
        if dict["Appetite"] == 1 {
            rai += 4
        }
        if dict["Kidney"]! < 3 {
            rai += 8
        }
        if dict["CHF"] == 1 {
            rai += 5
        }
        if dict["Breath"] == 1 {
            rai += 3
        }
        if dict["Home"] == 1 {
            rai += 1
        }
        
        if dict["CancerHistory"] == 1 {
            if dict["Age"]! <= 19 {
                rai += 28
            }
            else if dict["Age"]! <= 29 {
                rai += 29
            }
            else if dict["Age"]! <= 39 {
                rai += 30
            }
            else if dict["Age"]! <= 49 {
                rai += 31
            }
            else if dict["Age"]! <= 59 {
                rai += 32
            }
            else if dict["Age"]! <= 64 {
                rai += 33
            }
            else if dict["Age"]! <= 74 {
                rai += 34
            }
            else if dict["Age"]! <= 84 {
                rai += 35
            }
            else if dict["Age"]! <= 94 {
                rai += 36
            }
            else {
                rai += 37
            }
        }
        else {
            if dict["Age"]! <= 19 {
                rai += 0
            }
            else if dict["Age"]! <= 24 {
                rai += 1
            }
            else if dict["Age"]! <= 29 {
                rai += 4
            }
            else if dict["Age"]! >= 100 {
                rai += 34
            }
            else {
                var input = Float16(dict["Age"]!)
                var mod = (input - 29) / 5
                var round = ceil(mod) * 2
                rai += (Int(round) + 4)
            }
        }
        
        var adl = dict["Mobility"]! + dict["Eating"]! + dict["Toileting"]! + dict["Hygeine"]!
        
        if dict["Cognitive"] == 1 {
            if adl == 0 {
                rai += 5
            }
            else if adl <= 2 {
                rai += 6
            }
            else if adl == 3 {
                rai += 7
            }
            else if adl <= 5 {
                rai += 8
            }
            else if adl == 6 {
                rai += 9
            }
            else if adl == 7 {
                rai += 10
            }
            else if adl <= 9 {
                rai += 11
            }
            else if adl == 10 {
                rai += 12
            }
            else if adl <= 12 {
                rai += 13
            }
            else if adl == 13 {
                rai += 14
            }
            else if adl <= 15 {
                rai += 15
            }
            else {
                rai += 16
            }
        }
        else {
            if adl == 0 {
                rai += 0
            }
            else if adl == 1 {
                rai += 1
            }
            else if adl == 2 {
                rai += 2
            }
            else if adl == 3 {
                rai += 3
            }
            else if adl <= 5 {
                rai += 4
            }
            else if adl == 6 {
                rai += 5
            }
            else if adl == 7 {
                rai += 6
            }
            else if adl == 8 {
                rai += 7
            }
            else if adl == 9 {
                rai += 8
            }
            else if adl == 10 {
                rai += 9
            }
            else if adl == 11 {
                rai += 10
            }
            else if adl <= 13 {
                rai += 11
            }
            else {
                rai += (adl - 2)
            }
        }
        
        print (rai)

        do {
            if let json = try CK_ORKSerialization.CKTaskAsJson(result: taskViewController.result,task: taskViewController.task!)
            {
                    do {
                        print("RAI: " )
                        print (rai)
                        try CKSendHelper.sendToFirestoreWithUUID(json: ["rai": rai, "date": Date().timeIntervalSinceReferenceDate], collection: "rai", withIdentifier: UUID().uuidString)
                                    } catch {
                                        print("error")
                                    }
                    
                    
                    controller.appendOutcomeValue(value: rai, at: IndexPath(item: 0, section: 0), completion: nil)
                    
                }
                
                let gcpDelegate = CKUploadToGCPTaskViewControllerDelegate()
                gcpDelegate.taskViewController(taskViewController, didFinishWith: reason, error: error)

            }
        catch {
           print("error.")
       }
    }
}

class RAISurveyViewSynchronizer: OCKInstructionsTaskViewSynchronizer {

    // Customize the initial state of the view
    override func makeView() -> OCKInstructionsTaskView {
        let instructionsView = super.makeView()
        instructionsView.completionButton.label.text = "Start"
        return instructionsView
    }
    
    override func updateView(_ view: OCKInstructionsTaskView, context: OCKSynchronizationContext<OCKTaskEvents>) {
        super.updateView(view, context: context)

        // Check if an answer exists or not and set the detail label accordingly
        let element: [OCKAnyEvent]? = context.viewModel.first
        let firstEvent = element?.first
        
        view.headerView.detailLabel.text = "Evaluate patient's functional capacity."
        
        /*if let answer = firstEvent?.outcome?.values.first?.integerValue {
            view.headerView.detailLabel.text = "CardinalKit Rating: \(answer)"
        } else {
            view.headerView.detailLabel.text = "How are you liking CardinalKit?"
        } */
    }
}
