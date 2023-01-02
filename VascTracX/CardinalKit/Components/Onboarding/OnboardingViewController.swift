//
//  OnboardingViewController.swift
//  CardinalKit_Example
//
//  Created by Santiago Gutierrez on 10/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import SwiftUI
import UIKit
import ResearchKit
import CardinalKit
import Firebase

struct OnboardingViewController: UIViewControllerRepresentable {
    
    func makeCoordinator() -> OnboardingViewCoordinator {
        OnboardingViewCoordinator()
    }

    typealias UIViewControllerType = ORKTaskViewController
    
    func updateUIViewController(_ taskViewController: ORKTaskViewController, context: Context) {}
    func makeUIViewController(context: Context) -> ORKTaskViewController {

        let config = CKPropertyReader(file: "CKConfiguration")
            
        /* **************************************************************
        *  STEP (1): get user consent
        **************************************************************/
        // use the `ORKVisualConsentStep` from ResearchKit
        let consentDocument = ConsentDocument()
        let consentStep = ORKVisualConsentStep(identifier: "VisualConsentStep", document: consentDocument)
        
        /* **************************************************************
        *  STEP (2): ask user to review and sign consent document
        **************************************************************/
        // use the `ORKConsentReviewStep` from ResearchKit
        let signature = consentDocument.signatures?.first
        let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: signature, in: consentDocument)
        reviewConsentStep.text = config.read(query: "Review Consent Step Text")
        reviewConsentStep.reasonForConsent = config.read(query: "Reason for Consent Text")
        
        /* **************************************************************
        *  STEP (3): get permission to collect HealthKit data
        **************************************************************/
        // see `HealthDataStep` to configure!
        let healthDataStep = CKHealthDataStep(identifier: "Healthkit")
        
        /* **************************************************************
        *  STEP (3.5): get permission to collect HealthKit health records data
        **************************************************************/
        let healthRecordsStep = CKHealthRecordsStep(identifier: "HealthRecords")
        
      /*  let notificationsPermissionType = ORKNotificationPermissionType(
            authorizationOptions: [.alert, .badge, .sound]
        )
        
        let requestPermissionStep = ORKRequestPermissionsStep(
            identifier: "RequestNotif",
            permissionTypes: [notificationsPermissionType]
        ) */
        
        /* **************************************************************
        *  STEP (4): ask user to enter their email address for login
        **************************************************************/
        // the `LoginStep` collects and email address, and
        // the `LoginCustomWaitStep` waits for email verification.

        var loginSteps: [ORKStep]
        let signInButtons = CKMultipleSignInStep(identifier: "SignInButtons")
        
        
//        if config["Login-Sign-In-With-Apple"]["Enabled"] as? Bool == true {
//            let signInWithAppleStep = CKSignInWithAppleStep(identifier: "SignInWithApple")
//            loginSteps = [signInWithAppleStep]
//        } else if config.readBool(query: "Login-Passwordless") == true {
//            let loginStep = PasswordlessLoginStep(identifier: PasswordlessLoginStep.identifier)
//            let loginVerificationStep = LoginCustomWaitStep(identifier: LoginCustomWaitStep.identifier)
//
//            loginSteps = [loginStep, loginVerificationStep]
//        } else {
            let regexp = try! NSRegularExpression(pattern: "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}")

            let registerStep = ORKRegistrationStep(identifier: "RegistrationStep", title: "Registration", text: """
            Sign up for this study.
            
            """, passcodeValidationRegularExpression: regexp, passcodeInvalidMessage: "Your password does not meet the following criteria: minimum 8 characters with at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character", options: [])

            let loginStep = ORKLoginStep(identifier: "LoginStep", title: "Login", text: """
            Log into this study.
            
            """, loginViewControllerClass: LoginViewController.self)

            loginSteps = [signInButtons, registerStep, loginStep]
//        }
        
        /* **************************************************************
        *  STEP (5): ask the user to create a security passcode
        *  that will be required to use this app!
        **************************************************************/
        // use the `ORKPasscodeStep` from ResearchKit.
        let passcodeStep = ORKPasscodeStep(identifier: "Passcode") //NOTE: requires NSFaceIDUsageDescription in info.plist
        let type = config.read(query: "Passcode Type")
        if type == "6" {
            passcodeStep.passcodeType = .type6Digit
        } else {
            passcodeStep.passcodeType = .type4Digit
        }
        passcodeStep.text = "Create a Passcode for Sign-In (2)" //config.read(query: "Passcode Text")
        passcodeStep.title = "Create a Passcode for Sign-In (1)"
        passcodeStep.detailText = "Create a Passcode for Sign-In (3)"
        
        let postOpDateAnswerFormat = ORKAnswerFormat.dateAnswerFormat()
        let postOpDate = ORKQuestionStep(identifier:"PostOpDate", title: " Patient Onboarding", question: "If you have an upcoming surgery planned (choose today's date if you do not): When does your post-discharge period begin? If this info is not available, what date is your surgery scheduled for?", answer: postOpDateAnswerFormat)
        
        /* **************************************************************
        *  STEP (6): inform the user that they are done with sign-up!
        **************************************************************/
        // use the `ORKCompletionStep` from ResearchKit
        let completionStep = ORKCompletionStep(identifier: "CompletionStep")
        completionStep.title = config.read(query: "Completion Step Title")
        completionStep.text = config.read(query: "Completion Step Text")
        
    /*    let optSurvey: ORKNavigableOrderedTask = {
            var steps = [ORKStep]()
            let optStep = ORKFormStep(identifier: "OptStep")
            let opt1 = ORKFormItem(identifier: "Opt1", text: "May we contact you about future studies that may be of interest to you?", answerFormat: ORKAnswerFormat.booleanAnswerFormat())
            let opt2 = ORKFormItem(identifier: "Opt2", text: "Are you participating in any other research studies?", answerFormat: ORKAnswerFormat.booleanAnswerFormat())
            optStep.formItems = [opt1, opt2]
            
            var task = ORKNavigableOrderedTask(identifier: "OnboardingTask", steps: steps)
            
            return task
        
        }() */
        
        /* **************************************************************
        * finally, CREATE an array with the steps to show the user
        **************************************************************/
        
        // given intro steps that the user should review and consent to
        let introSteps: [ORKStep] = [consentStep, reviewConsentStep]
        
        // and steps regarding login / security
        let emailVerificationSteps = loginSteps + [passcodeStep, healthDataStep, healthRecordsStep, postOpDate, completionStep]
        
        // guide the user through ALL steps
        let fullSteps = introSteps + emailVerificationSteps //+ [optStep]
        
        // unless they have already gotten as far as to enter an email address
        var stepsToUse = fullSteps
        if CKStudyUser.shared.email != nil {
            stepsToUse = emailVerificationSteps
        }
        
        /* **************************************************************
        * and SHOW the user these steps!
        **************************************************************/
        // create a task with each step
//        let orderedTask = ORKOrderedTask(identifier: "StudyOnboardingTask", steps: stepsToUse)
        
        
      //  let test = OnboardingSurvey.onboardingSurvey
      //  let os = test.steps
      //  stepsToUse = fullSteps + os
        
        let navigableTask = ORKNavigableOrderedTask(identifier: "StudyOnboardingTask", steps: stepsToUse)
        
        let resultSelector = ORKResultSelector(resultIdentifier: "SignInButtons")
        let booleanAnswerType = ORKResultPredicate.predicateForBooleanQuestionResult(with: resultSelector, expectedAnswer: true)
        let predicateRule = ORKPredicateStepNavigationRule(resultPredicates: [booleanAnswerType],
                                                           destinationStepIdentifiers: ["RegistrationStep"],
                                                           defaultStepIdentifier: "Passcode",
                                                           validateArrays: true)
        navigableTask.setNavigationRule(predicateRule, forTriggerStepIdentifier: "SignInButtons")
        
        
        //let surveyViewController = ORKTaskViewController(task: WIQSurvey.wiqSurvey, taskRun: nil)
        //surveyViewController.delegate = self

        // 3a. Present the survey to the user
        //surveyViewController.present(surveyViewController, animated: false, completion: nil)
        
        
        // wrap that task on a view controller
        let taskViewController = ORKTaskViewController(task: navigableTask, taskRun: nil)
        taskViewController.delegate = context.coordinator // enables `ORKTaskViewControllerDelegate` below
        // & present the VC!
        return taskViewController
    }
}
