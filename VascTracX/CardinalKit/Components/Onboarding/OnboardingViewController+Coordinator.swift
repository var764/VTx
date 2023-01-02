//
//  OnboardingViewController+Coordinator.swift
//  CardinalKit_Example
//
//  Created by Santiago Gutierrez on 10/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import ResearchKit
import Firebase
import CardinalKit
import FirebaseFirestore

class OnboardingViewCoordinator: NSObject, ORKTaskViewControllerDelegate {

    public func taskViewController(_ taskViewController: ORKTaskViewController, shouldPresent step: ORKStep) -> Bool {

        // Only allow users to continue the onboarding process if they consent
        if let consentStepResult = taskViewController.result.stepResult(forStepIdentifier: "ConsentReviewStep")?.results,
           let signatureResult = consentStepResult[0] as? ORKConsentSignatureResult {
            if !signatureResult.consented {
                taskViewController.dismiss(animated: false, completion: nil)
                return false
            }
        }
        
        return true
    }

    public func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        let storage = Storage.storage()
        switch reason {
        case .completed:
            UserDefaults.standard.set(true, forKey: Constants.onboardingDidComplete)
            
            if let signatureResult = taskViewController.result.stepResult(forStepIdentifier: "ConsentReviewStep")?.results?.first as? ORKConsentSignatureResult {
                
                let consentDocument = ConsentDocument()
                signatureResult.apply(to: consentDocument)

                consentDocument.makePDF { (data, error) -> Void in
                    
                    let config = CKPropertyReader(file: "CKConfiguration")
                    let consentFileName = config.read(query: "Consent File Name")
                        
                    //var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last as NSURL?
                    //docURL = docURL?.appendingPathComponent("\(consentFileName).pdf") as NSURL?
                    
                    print("Prep file name")
                    

                    do {
                        var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last as NSURL?
                        docURL = docURL?.appendingPathComponent("\(consentFileName).pdf") as NSURL?
                        let url = docURL! as URL
                        try data?.write(to: url)

                        UserDefaults.standard.set(url.path, forKey: "consentFormURL")
                        
                        print("Set file url")

                        let storageRef = storage.reference()

                        if let DocumentCollection = CKStudyUser.shared.authCollection {
                            let DocumentRef = storageRef.child("\(DocumentCollection)/\(consentFileName).pdf")
                            

                            DocumentRef.putData(data ?? Data.init(), metadata: nil) {metadata, error in
                                if let error = error {
                                    print(error.localizedDescription)
                                }
                                print ("Successful data upload.")
                            }
                            
                           // storageRef.putData(Data, metadata: nil, completion: {(metadata, error) in})

                         /*   DocumentRef.putFile(from: url, metadata: nil) { metadata, error in
                                if let error = error {
                                    print("Kenan is the GOAT")
                                    print(error)
                                    print(error.localizedDescription)
                                }
                            } */
                            print("Successfully uploaded file")
                        }
                        
                    } catch let error {

                        print(error.localizedDescription)
                    }
                }
            }
            
            print("Login successful! task: \(taskViewController.task?.identifier ?? "(no ID)")")
            
            var postOpDate = Date()
            if let results = taskViewController.result.results as? [ORKStepResult] {
                //print("\(results)")
                for stepResult : ORKStepResult in results {
                    for result in stepResult.results as! [ORKResult] {
                        
                        if let questionResult = result as? ORKDateQuestionResult
                        {
                            postOpDate = questionResult.dateAnswer ?? Date()
                            print("Post Op Date: ")
                            print(postOpDate)
                        }
                        
                    }
                    
                }
                
            }
            
            print("Post Op in Func")
            print(postOpDate)
            
            let defaults = UserDefaults.standard
            defaults.set(postOpDate, forKey: "postOperativeDate")

            do {
                if let json = try CK_ORKSerialization.CKTaskAsJson(result: taskViewController.result,task: taskViewController.task!)
                {
                    do {
                        try CKSendHelper.sendToFirestoreWithUUID(json: ["postopdate": postOpDate], collection: "PostOpDate", withIdentifier: UUID().uuidString)
                         } catch {
                                    print("error")
                                }
                    //dummy value for completion
                    //controller.appendOutcomeValue(value: 1, at: IndexPath(item: 0, section: 0), completion: nil)

                }
                
                let gcpDelegate = CKUploadToGCPTaskViewControllerDelegate()
                gcpDelegate.taskViewController(taskViewController, didFinishWith: reason, error: error)
            }
            catch {
               print("error.")
           }
            
            fallthrough
        default:
            // otherwise dismiss onboarding without proceeding.
            taskViewController.dismiss(animated: false, completion: nil)
        }
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, stepViewControllerWillAppear stepViewController: ORKStepViewController) {
        
        // MARK: - Advanced Concepts
        // Sometimes we might want some custom logic
        // to run when a step appears 🎩
        
        if stepViewController.step?.identifier == PasswordlessLoginStep.identifier {
            
            /* **************************************************************
            * When the login step appears, asking for the patient's email
            **************************************************************/
            if let _ = CKStudyUser.shared.currentUser?.email {
                // if we already have an email, go forward and continue.
                DispatchQueue.main.async {
                    stepViewController.goForward()
                }
            }
            
        } else if (stepViewController.step?.identifier == "RegistrationStep") {
            
            if let _ = CKStudyUser.shared.currentUser?.email {
                // if we already have an email, go forward and continue.
                DispatchQueue.main.async {
                    stepViewController.goForward()
                }
            }
            
        } else if (stepViewController.step?.identifier == "LoginStep") {
            
            if let _ = CKStudyUser.shared.currentUser?.email {
                // good — we have an email!
            } else {
                let alert = UIAlertController(title: nil, message: "Creating account...", preferredStyle: .alert)

                let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                loadingIndicator.hidesWhenStopped = true
                loadingIndicator.style = UIActivityIndicatorView.Style.medium
                loadingIndicator.startAnimating();

                alert.view.addSubview(loadingIndicator)
                taskViewController.present(alert, animated: false, completion: nil)
                
                let stepResult = taskViewController.result.stepResult(forStepIdentifier: "RegistrationStep")
                if let emailRes = stepResult?.results?.first as? ORKTextQuestionResult, let email = emailRes.textAnswer {
                    if let passwordRes = stepResult?.results?[1] as? ORKTextQuestionResult, let pass = passwordRes.textAnswer {
                        Auth.auth().createUser(withEmail: email, password: pass) { (res, error) in
                            DispatchQueue.main.async {
                                if error != nil {
                                    alert.dismiss(animated: false, completion: nil)
                                    if let errCode = AuthErrorCode(rawValue: error!._code) {

                                        switch errCode {
                                            default:
                                                let alert = UIAlertController(title: "Registration Error!", message: error?.localizedDescription, preferredStyle: .alert)
                                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

                                                taskViewController.present(alert, animated: false)
                                        }
                                    }
                                    
                                    stepViewController.goBackward()

                                } else {
                                    alert.dismiss(animated: false, completion: nil)
                                    print("Created user!")
                                }
                            }
                        }
                        
                    }
                }
            }
        } else if stepViewController.step?.identifier == LoginCustomWaitStep.identifier {
            
            /* **************************************************************
            * When the email verification step appears, send email in background!
            **************************************************************/
            
            let stepResult = taskViewController.result.stepResult(forStepIdentifier: PasswordlessLoginStep.identifier)
            if let emailRes = stepResult?.results?.first as? ORKTextQuestionResult, let email = emailRes.textAnswer {
                
                // if we received a valid email
                CKStudyUser.shared.sendLoginLink(email: email) { (success) in
                    // send a login link
                    guard success else {
                        // and react accordingly if we ran into an error.
                        DispatchQueue.main.async {
                            let config = CKPropertyReader(file: "CKConfiguration")
                            
                            Alerts.showInfo(title: config.read(query: "Failed Login Title"), message: config.read(query: "Failed Login Text"))
                            stepViewController.goBackward()
                        }
                        return
                    }
                    
                    CKStudyUser.shared.email = email
                }
                
            }
            
        }
        
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, viewControllerFor step: ORKStep) -> ORKStepViewController? {
        
        // MARK: - Advanced Concepts
        // Overriding the view controller of an ORKStep
        // lets us run our own code on top of what
        // ResearchKit already provides!
        switch step {
        case is CKHealthDataStep:
            // this step lets us run custom logic to ask for
            // HealthKit permissins when this step appears on screen.
            return CKHealthDataStepViewController(step: step)
        case is CKHealthRecordsStep:
            return CKHealthRecordsStepViewController(step: step)
        case is LoginCustomWaitStep:
            // run custom code to send an email for login!
            return LoginCustomWaitStepViewController(step: step)
        case is CKSignInWithAppleStep:
            // handle Sign in with Apple
            return CKSignInWithAppleStepViewController(step: step)
        case is CKMultipleSignInStep:
            return CKMultipleSignInStepViewController(step: step)
        case is CKReviewConsentDocument:
            return CKReviewConsentDocumentViewController(step: step)
        case is ORKQuestionStep:
            return ORKQuestionStepViewController(step: step)
        default:
            return nil
        }
    }
}

/*import ResearchKit
import Firebase
import CardinalKit

class OnboardingViewCoordinator: NSObject, ORKTaskViewControllerDelegate {
    
    public func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        let storage = Storage.storage()
        switch reason {
        case .completed:
            // if we completed the onboarding task view controller, go to study.
            // performSegue(withIdentifier: "unwindToStudy", sender: nil)
            
            // TODO: where to go next?
            // trigger "Studies UI"
            UserDefaults.standard.set(true, forKey: Constants.onboardingDidComplete)
            NotificationCenter.default.post(name: NSNotification.Name(Constants.onboardingDidComplete), object: true)
            
            if let signatureResult = taskViewController.result.stepResult(forStepIdentifier: "ConsentReviewStep")?.results?.first as? ORKConsentSignatureResult {
                
                let consentDocument = ConsentDocument()
                signatureResult.apply(to: consentDocument)

                consentDocument.makePDF { (data, error) -> Void in
                    
                    let config = CKPropertyReader(file: "CKConfiguration")
                        
                    var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last as NSURL?
                    docURL = docURL?.appendingPathComponent("\(config.read(query: "Consent File Name")).pdf") as NSURL?
                    

                    do {
                        let url = docURL! as URL
                        try data?.write(to: url)
                        
                        UserDefaults.standard.set(url.path, forKey: "consentFormURL")
                        
                        let storageRef = storage.reference()
                        
                        if let DocumentCollection = CKStudyUser.shared.authCollection {
                            let DocumentRef = storageRef.child("\(DocumentCollection)/Consent.pdf")
                            
                            // Upload the file to the path "images/rivers.jpg"
                            DocumentRef.putFile(from: url, metadata: nil) { metadata, error in
                              guard let metadata = metadata else {
                                // Uh-oh, an error occurred!
                                return
                              }
                              // Metadata contains file metadata such as size, content-type.
//                              let size = metadata.size
                              // You can also access to download URL after upload.
                                DocumentRef.downloadURL { (url, error) in
                                guard let downloadURL = url else {
                                  // Uh-oh, an error occurred!
                                  return
                                }
                              }
                            }
                        }
                        
                        
                        

                    } catch let error {

                        print(error.localizedDescription)
                    }
                }
            }
            
            
            print("Login successful! task: \(taskViewController.task?.identifier ?? "(no ID)")")
            
            fallthrough
        default:
            // otherwise dismiss onboarding without proceeding.
            taskViewController.dismiss(animated: false, completion: nil)
        }
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, stepViewControllerWillAppear stepViewController: ORKStepViewController) {
        
        // MARK: - Advanced Concepts
        // Sometimes we might want some custom logic
        // to run when a step appears 🎩
        
        if stepViewController.step?.identifier == PasswordlessLoginStep.identifier {
            
            /* **************************************************************
            * When the login step appears, asking for the patient's email
            **************************************************************/
            if let _ = CKStudyUser.shared.currentUser?.email {
                // if we already have an email, go forward and continue.
                DispatchQueue.main.async {
                    stepViewController.goForward()
                }
            }
            
        } else if (stepViewController.step?.identifier == "RegistrationStep") {
            
            if let _ = CKStudyUser.shared.currentUser?.email {
                // if we already have an email, go forward and continue.
                DispatchQueue.main.async {
                    stepViewController.goForward()
                }
            }
            
        } else if (stepViewController.step?.identifier == "LoginStep") {
            
            if let _ = CKStudyUser.shared.currentUser?.email {
                // good — we have an email!
            } else {
                let alert = UIAlertController(title: nil, message: "Creating account...", preferredStyle: .alert)

                let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                loadingIndicator.hidesWhenStopped = true
                loadingIndicator.style = UIActivityIndicatorView.Style.medium
                loadingIndicator.startAnimating();

                alert.view.addSubview(loadingIndicator)
                taskViewController.present(alert, animated: false, completion: nil)
                
                let stepResult = taskViewController.result.stepResult(forStepIdentifier: "RegistrationStep")
                if let emailRes = stepResult?.results?.first as? ORKTextQuestionResult, let email = emailRes.textAnswer {
                    if let passwordRes = stepResult?.results?[1] as? ORKTextQuestionResult, let pass = passwordRes.textAnswer {
                        Auth.auth().createUser(withEmail: email, password: pass) { (res, error) in
                            DispatchQueue.main.async {
                                if error != nil {
                                    alert.dismiss(animated: false, completion: nil)
                                    if let errCode = AuthErrorCode(rawValue: error!._code) {

                                        switch errCode {
                                            default:
                                                let alert = UIAlertController(title: "Registration Error!", message: error?.localizedDescription, preferredStyle: .alert)
                                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

                                                taskViewController.present(alert, animated: false)
                                        }
                                    }
                                    
                                    stepViewController.goBackward()

                                } else {
                                    alert.dismiss(animated: false, completion: nil)
                                    print("Created user!")
                                }
                            }
                        }
                        
                    }
                }
            }
        } else if stepViewController.step?.identifier == LoginCustomWaitStep.identifier {
            
            /* **************************************************************
            * When the email verification step appears, send email in background!
            **************************************************************/
            
            let stepResult = taskViewController.result.stepResult(forStepIdentifier: PasswordlessLoginStep.identifier)
            if let emailRes = stepResult?.results?.first as? ORKTextQuestionResult, let email = emailRes.textAnswer {
                
                // if we received a valid email
                CKStudyUser.shared.sendLoginLink(email: email) { (success) in
                    // send a login link
                    guard success else {
                        // and react accordingly if we ran into an error.
                        DispatchQueue.main.async {
                            let config = CKPropertyReader(file: "CKConfiguration")
                            
                            Alerts.showInfo(title: config.read(query: "Failed Login Title"), message: config.read(query: "Failed Login Text"))
                            stepViewController.goBackward()
                        }
                        return
                    }
                    
                    CKStudyUser.shared.email = email
                }
                
            }
            
        }
        
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, viewControllerFor step: ORKStep) -> ORKStepViewController? {
        
        // MARK: - Advanced Concepts
        // Overriding the view controller of an ORKStep
        // lets us run our own code on top of what
        // ResearchKit already provides!

        switch step {
        case is CKHealthDataStep:
            // this step lets us run custom logic to ask for
            // HealthKit permissins when this step appears on screen.
            return CKHealthDataStepViewController(step: step)
        case is CKHealthRecordsStep:
            return CKHealthRecordsStepViewController(step: step)
        case is LoginCustomWaitStep:
            // run custom code to send an email for login!
            return LoginCustomWaitStepViewController(step: step)
        case is CKSignInWithAppleStep:
            // handle Sign in with Apple
            return CKSignInWithAppleStepViewController(step: step)
        case is CKMultipleSignInStep:
            return CKMultipleSignInStepViewController(step: step)
        case is CKReviewConsentDocument:
            return CKReviewConsentDocumentViewController(step: step)
        default:
            return nil
        }
    }
} */
