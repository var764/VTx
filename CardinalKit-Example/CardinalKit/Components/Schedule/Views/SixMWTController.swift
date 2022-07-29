//
//  SixMWTController.swift
//  CardinalKit_Example
//
//  Created by Varun on 3/10/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import CareKit
import ResearchKit
import CareKitUI
import CareKitStore
import SwiftUI

// 1. Subclass a task view controller to customize the control flow and present a ResearchKit survey!
class SixMWTActiveViewController: OCKInstructionsTaskViewController, ORKTaskViewControllerDelegate {

    // 2. This method is called when the use taps the button!
    override func taskView(_ taskView: UIView & OCKTaskDisplayable, didCompleteEvent isComplete: Bool, at indexPath: IndexPath, sender: Any?) {

        // 2a. If the task was marked incomplete, fall back on the super class's default behavior or deleting the outcome.
        if !isComplete {
            super.taskView(taskView, didCompleteEvent: isComplete, at: indexPath, sender: sender)
            return
        }

        // 2b. If the user attempted to mark the task complete, display a ResearchKit survey.
        
        //let surveyViewController = ORKTaskViewController(task: OnboardingSurvey.onboardingSurvey, taskRun: nil)
        let surveyViewController = ORKTaskViewController(task: SixMWT.sixMWTTask, taskRun: nil)
        surveyViewController.delegate = self

        // 3a. Present the survey to the user
        present(surveyViewController, animated: false, completion: nil)
    }

    // 3b. This method will be called when the user completes the survey.
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {

        guard reason == .completed else {
            taskView.completionButton.isSelected = false
            return
        }
        
        taskViewController.dismiss(animated: false, completion: nil)
        
        // 4a. Retrieve the result from the ResearchKit survey

       controller.appendOutcomeValue(value: 1, at: IndexPath(item: 0, section: 0), completion: nil)
                
       let gcpDelegate = CKUploadToGCPTaskViewControllerDelegate()
        gcpDelegate.taskViewController(taskViewController, didFinishWith: reason, error: error)

    }
}

class SixMWTActiveViewSynchronizer: OCKInstructionsTaskViewSynchronizer {

    // Customize the initial state of the view
    override func makeView() -> OCKInstructionsTaskView {
        let instructionsView = super.makeView()
        instructionsView.completionButton.label.text = "Start"
        return instructionsView
    }
    
    override func updateView(_ view: OCKInstructionsTaskView, context: OCKSynchronizationContext<OCKTaskEvents>) {
        super.updateView(view, context: context)

        // Check if an answer exists or not and set the detail label accordingly
       /* let element: [OCKAnyEvent]? = context.viewModel.first
        let firstEvent = element?.first
        
        view.headerView.detailLabel.text = "Evaluates Patient's Walking Ability." */
    }
}
