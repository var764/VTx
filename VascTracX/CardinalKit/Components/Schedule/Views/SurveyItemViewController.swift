//
//  SurveyItemViewController.swift
//  CardinalKit_Example
//
//  Created by Santiago Gutierrez on 12/23/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import CareKit
import ResearchKit
import CareKitUI
import CareKitStore
import SwiftUI

// 1. Subclass a task view controller to customize the control flow and present a ResearchKit survey!
class SurveyItemViewController: OCKInstructionsTaskViewController, ORKTaskViewControllerDelegate {

    // 2. This method is called when the use taps the button!
    override func taskView(_ taskView: UIView & OCKTaskDisplayable, didCompleteEvent isComplete: Bool, at indexPath: IndexPath, sender: Any?) {

        // 2a. If the task was marked incomplete, fall back on the super class's default behavior or deleting the outcome.
        if !isComplete {
            super.taskView(taskView, didCompleteEvent: isComplete, at: indexPath, sender: sender)
            return
        }

        // 2b. If the user attempted to mark the task complete, display a ResearchKit survey.
        
        //let surveyViewController = ORKTaskViewController(task: OnboardingSurvey.onboardingSurvey, taskRun: nil)
        let surveyViewController = ORKTaskViewController(task: WIQSurvey.wiqSurvey, taskRun: nil)
        surveyViewController.delegate = self

        // 3a. Present the survey to the user
        present(surveyViewController, animated: false, completion: nil)
    }

    // 3b. This method will be called when the user completes the survey.
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        taskViewController.dismiss(animated: false, completion: nil)
        guard reason == .completed else {
            taskView.completionButton.isSelected = false
            return
        }
        // 4a. Retrieve the result from the ResearchKit survey
        
        let taskResult = taskViewController.result.results
        let identifiers = ["WIQ Endurance 1", "WIQ Endurance 2", "WIQ Endurance 3", "WIQ Endurance 4", "WIQ Endurance 5", "WIQ Endurance 6", "WIQ Endurance 7"]
        let distWeights = [1, 50, 150, 300, 600, 900, 1500]
        var wiqScore = 0

        do {
            if let json = try CK_ORKSerialization.CKTaskAsJson(result: taskViewController.result,task: taskViewController.task!)
            {
                
                let resultsArr = json["results"] as? [Any]
                let subResults = resultsArr?[1] as? [String:Any]
                let resultsNested = subResults?["results"] as? [Any]
                
                if let results = resultsNested
                {
                    for (index, elem) in results.enumerated()
                    {
                        var test = elem as? [String:Any]
                        var score = Int(test?["answer"] as? String ?? "") ?? 0
                        wiqScore += ((5 - score) * distWeights[index])
                        print(String(wiqScore))
                    }
                    var finalScore = (Double(wiqScore) / 17500) * 100
                    print(finalScore)
                    
                    do {
                        try CKSendHelper.sendToFirestoreWithUUID(json: ["wiqscore": finalScore, "date": Date().timeIntervalSinceReferenceDate], collection: "wiqscore", withIdentifier: UUID().uuidString)
                                    } catch {
                                        print("error")
                                    }
                    
                    
                    controller.appendOutcomeValue(value: finalScore, at: IndexPath(item: 0, section: 0), completion: nil)
                    
                }
                
                let gcpDelegate = CKUploadToGCPTaskViewControllerDelegate()
                gcpDelegate.taskViewController(taskViewController, didFinishWith: reason, error: error)

            }
        }
        catch {
           print("error.")
       }
    }
}

class SurveyItemViewSynchronizer: OCKInstructionsTaskViewSynchronizer {

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
        
        view.headerView.detailLabel.text = "Evaluate patient mobility difficulty."
        
        /*if let answer = firstEvent?.outcome?.values.first?.integerValue {
            view.headerView.detailLabel.text = "CardinalKit Rating: \(answer)"
        } else {
            view.headerView.detailLabel.text = "How are you liking CardinalKit?"
        } */
    }
}
