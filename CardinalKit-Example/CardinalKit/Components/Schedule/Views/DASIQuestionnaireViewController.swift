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
class DASIQuestionnaireViewController: OCKInstructionsTaskViewController, ORKTaskViewControllerDelegate {

    // 2. This method is called when the use taps the button!
    override func taskView(_ taskView: UIView & OCKTaskDisplayable, didCompleteEvent isComplete: Bool, at indexPath: IndexPath, sender: Any?) {

        // 2a. If the task was marked incomplete, fall back on the super class's default behavior or deleting the outcome.
        if !isComplete {
            super.taskView(taskView, didCompleteEvent: isComplete, at: indexPath, sender: sender)
            return
        }

        // 2b. If the user attempted to mark the task complete, display a ResearchKit survey.
        
        //let surveyViewController = ORKTaskViewController(task: OnboardingSurvey.onboardingSurvey, taskRun: nil)
        let dasiQViewController = ORKTaskViewController(task: DASIQuestionnaire.dasiQuestionnaire, taskRun: nil)
        dasiQViewController.delegate = self

        // 3a. Present the survey to the user
        present(dasiQViewController, animated: false, completion: nil)
    }

    // 3b. This method will be called when the user completes the survey.
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        taskViewController.dismiss(animated: false, completion: nil)
        guard reason == .completed else {
            taskView.completionButton.isSelected = false
            return
        }
        // 4a. Retrieve the result from the ResearchKit survey
        
        /*
         Q1-12: Duke Activity Status Index (DASI) = sum of “Yes” replies ________
         VO2peak= (0.43 x DASI) + 9.6
         VO2peak = ____________ml/kg/min ÷ 3.5 ml/kg/min = _________MET
         
         */
        
        let taskResult = taskViewController.result.results
        let identifiers = ["DASI-1", "DASI-2", "DASI-3", "DASI-4", "DASI-5", "DASI-6", "DASI-7", "DASI-8", "DASI-9", "DASI-10", "DASI-11", "DASI-12"]
        var dasi = 0

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
                        dasi += score
                        print(String(dasi))
                    }
                    var vo2peak = (Double(dasi) * 0.43) + 9.6
                    var vo2peakmet = (Double(vo2peak)) / 3.5
                    print(vo2peak)
                    print(vo2peakmet)
                    
                    do {
                        try CKSendHelper.sendToFirestoreWithUUID(json: ["dasi": dasi, "vo2peak_ml/kg/min": vo2peak, "vo2peak_MET": vo2peakmet, "date": Date().timeIntervalSinceReferenceDate], collection: "dasi", withIdentifier: UUID().uuidString)
                                    } catch {
                                        print("error")
                                    }
                    
                    
                    controller.appendOutcomeValue(value: dasi, at: IndexPath(item: 0, section: 0), completion: nil)
                    
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

class DASIQuestionnaireViewSynchronizer: OCKInstructionsTaskViewSynchronizer {

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
