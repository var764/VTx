//
//  CKCareKitManager+Sample.swift
//  CardinalKit_Example
//
//  Created by Santiago Gutierrez on 12/21/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import CareKit
import CareKitStore
import Contacts
import UIKit
import FirebaseFirestore

internal extension OCKStore {

    fileprivate func insertDocuments(documents: [DocumentSnapshot]?, collection: String, authCollection: String?,lastUpdateDate: Date?,onCompletion: @escaping (Error?)->Void){
        guard let documents = documents,
             documents.count>0 else {
           onCompletion(nil)
           return
       }
        
        let group = DispatchGroup()
        for document in documents{
            group.enter()
            CKSendHelper.getFromFirestore(authCollection:authCollection, collection: collection, identifier: document.documentID) {(document, error) in
                do{
                    guard let document = document,
                          let payload = document.data(),
                          let id = payload["id"] as? String else {
                              group.leave()
                        return
                    }
                    var itemSchedule:OCKSchedule? = nil
                    var update = true
                    if lastUpdateDate != nil,
                       let updateTimeServer = payload["updateTime"] as? Timestamp,
                       updateTimeServer.dateValue()<lastUpdateDate!{
                        update = false
                    }
                    
                    if update,
                        let schedule = payload["scheduleElements"] as? [[String:Any]]
                    {
                        var scheduleElements=[OCKScheduleElement]()
                        for element in schedule{
                            var startDate = Date()
                            var endDate:Date?=nil
                            var intervalDate = DateComponents(day:2)
                            var durationElement:OCKScheduleElement.Duration = .allDay
                            if let startStamp = element["startTime"] as? Timestamp{
                                startDate = startStamp.dateValue()
                            }
                            if let endStamp = element["endTime"] as? Timestamp{
                                endDate = endStamp.dateValue()
                            }
                            
                            if let interval = element["interval"] as? [String:Any]{
                                var day = 1
                                if let dayInterval = interval["day"] as? Int{
                                    day = dayInterval
                                }
                                var seconds = 1
                                if let secondsInterval = interval["seconds"] as? Int{
                                    seconds = secondsInterval
                                }
                                intervalDate =
                                    DateComponents(
                                        timeZone: interval["timeZone"] as? TimeZone,
                                        year: interval["year"] as? Int,
                                        month: interval["month"] as? Int,
                                        day: day,
                                        hour: interval["hour"] as? Int,
                                        minute: interval["minute"] as? Int,
                                        second: seconds,
                                        weekday: interval["weekday"] as? Int,
                                        weekdayOrdinal: interval["weekdayOrdinal"] as? Int,
                                        weekOfMonth: interval["weekOfMonth"] as? Int,
                                        weekOfYear: interval["weekOfYear"] as? Int,
                                        yearForWeekOfYear: interval["yearForWeekOfYear"] as? Int)
                            }
                            if let duration = element["duration"] as? [String:Any]{
                                if let allDay = duration["allDay"] as? Bool,
                                   allDay{
                                    durationElement = .allDay
                                }
                                if let seconds = duration["seconds"] as? Double{
                                    durationElement = .seconds(seconds)
                                }
                                if let hours = duration["hours"] as? Double{
                                    durationElement = .hours(hours)
                                }
                                if let minutes = duration["minutes"] as? Double{
                                    durationElement = .minutes(minutes)
                                }
                            }
                            var targetValue:[OCKOutcomeValue] = [OCKOutcomeValue]()
                            if let targetValues = element["targetValues"] as? [[String:Any]]{
                                for target in targetValues{
                                    if let identifier = target["groupIdentifier"] as? String{
                                        var come = OCKOutcomeValue(false, units: nil)
                                            come.groupIdentifier=identifier
                                        targetValue.append(come)
                                    }
                                }
                            }
                            scheduleElements.append(OCKScheduleElement(start: startDate, end: endDate, interval: intervalDate, text: element["text"] as? String, targetValues: targetValue, duration: durationElement))
                        }
                        if scheduleElements.count>0{
                            itemSchedule = OCKSchedule(composing: scheduleElements)
                        }
                    }
                    if let itemSchedule = itemSchedule{
                        var uuid:UUID? = nil
                        if let _uuid = payload["uuid"] as? String{
                            uuid=UUID(uuidString: _uuid)
                        }
                        var task = OCKTask(id: id, title: payload["title"] as? String, carePlanUUID: uuid, schedule: itemSchedule)
                        if let impactsAdherence = payload["impactsAdherence"] as? Bool{
                            task.impactsAdherence = impactsAdherence
                        }
                        task.instructions = payload["instructions"] as? String

                        // This fixes an issue where if cloud surveys were all in the future,
                        // they would not show up
                        // It does open up all surveys (even future) for completion
                        // TODO: make a way for the future surveys to be visible but not fillable
                        task.effectiveDate = Date()

                        // get if task exist?
                        self.fetchTask(withID: id) { result in
                            switch result {
                                case .failure(_): do {
                                    self.addTask(task)
                                }
                            case .success(_):do {
                                self.updateTask(task)
                                }
                            }

                            group.leave()
                        }
                    }
                    else{
                        group.leave()
                    }
                    
                }
            }
        }
        group.notify(queue: .main, execute: {
            onCompletion(nil)
        })
    }
    // Adds tasks and contacts into the store
    func populateSampleData(lastUpdateDate: Date?,completion:@escaping () -> Void) {
        
        let collection: String = "carekit-store/v2/tasks"
        // Download Tasks By Study
        
        guard  let studyCollection = CKStudyUser.shared.studyCollection else {
            return
        }
        // Get tasks on study
        CKSendHelper.getFromFirestore(authCollection: studyCollection,collection: collection, onCompletion: { (documents,error) in
            self.insertDocuments(documents: documents, collection: collection, authCollection: studyCollection,lastUpdateDate:lastUpdateDate){
                (Error) in
                CKSendHelper.getFromFirestore(collection: collection, onCompletion: { (documents,error) in
                    self.insertDocuments(documents: documents, collection: collection, authCollection: nil,lastUpdateDate:lastUpdateDate){
                        (Error) in
                        self.createContacts()
                        completion()
                    }
                })
            }
        })
        
        //Add WIQ Survey
        let morning = Calendar.current.startOfDay(for: Date())
        let end = Calendar.current.date(byAdding: .day, value: 120, to: Date())
        
        let defaults = UserDefaults.standard
        var postOpGoal = 0
        var postOpDate_ = Date()
        guard let authCollection =  CKStudyUser.shared.authCollection else { return }
        let db = Firestore.firestore()
        let collectionRef = db.collection(authCollection + "PostOpDate")
        postOpGoal = defaults.integer(forKey: "postopdate")

        collectionRef.limit(to: 5).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let payload = document.data()["payload"] as? [String : Any]  // cast payload to dic
                    let date_ = payload!["postopdate"] as! Timestamp
                    postOpDate_ = Date(timeIntervalSince1970: TimeInterval(date_.seconds))
                    
                    print("Post Op Date in CK: ")
                    print(postOpDate_)
                }
                let defaults = UserDefaults.standard
                defaults.set(postOpDate_ as! Date,forKey: "postOperativeDate")
                //defaults.synchronize()
            
            }
            
        print("Test completed.")
        }
        
      //  let defaults = UserDefaults.standard
        var postOperativeDate = defaults.object(forKey: "postOperativeDate") as! Date// ?? Date()
        
        print("Final operative date")
        print(postOperativeDate)
        
        let onboardingScheduleElem = OCKScheduleElement(start: morning, end: end, interval: DateComponents(day:365))
        let onboardingSurveySchedule = OCKSchedule(composing: [onboardingScheduleElem])
        var onboardingSurveyTask = OCKTask(id: "OnboardingTask", title: "Onboarding Survey", carePlanUUID: nil, schedule: onboardingSurveySchedule)
        onboardingSurveyTask.impactsAdherence = true
        onboardingSurveyTask.instructions = "Patient Onboarding Survey - Initial Info Intake."
        
        let wiq30Start = Calendar.current.date(byAdding: .day, value: 30, to: postOperativeDate as! Date)
        let wiq30ScheduleElem = OCKScheduleElement(start: wiq30Start!, end: nil, interval: DateComponents(day: 365))
        
        let wiq0ScheduleElem = OCKScheduleElement(start: morning, end: nil, interval: DateComponents(day:365))
        
        let wiq0SurveySchedule = OCKSchedule(composing: [wiq0ScheduleElem, wiq30ScheduleElem])
        var wiq0SurveyTask = OCKTask(id: "WIQTask", title: "WIQ Survey", carePlanUUID: nil, schedule: wiq0SurveySchedule)
        wiq0SurveyTask.impactsAdherence = true
        wiq0SurveyTask.instructions = "Walking Impairment Questionnaire"
        
        
        let rai0ScheduleElem = OCKScheduleElement(start: morning, end: nil, interval: DateComponents(day: 365))
        
        
        let rai30Start = Calendar.current.date(byAdding: .day, value: 30, to: postOperativeDate as! Date)
        let rai30ScheduleElem = OCKScheduleElement(start: rai30Start!, end: nil, interval: DateComponents(day: 365))
        
        let rai0Schedule = OCKSchedule(composing: [rai0ScheduleElem, rai30ScheduleElem])
        var rai0SurveyTask = OCKTask(id: "RAITask", title: "Risk Analysis Index Survey", carePlanUUID: nil, schedule: rai0Schedule)
        rai0SurveyTask.impactsAdherence = true
        rai0SurveyTask.instructions = "Evaluate Patient Functional Capacity."
        
     /*   let rai30Start = Calendar.current.date(byAdding: .day, value: 30, to: postOpDate_)
        let rai30ScheduleElem = OCKScheduleElement(start: rai30Start!, end: nil, interval: DateComponents(day: 365))
        let rai30Schedule = OCKSchedule(composing: [rai30ScheduleElem])
        var rai30SurveyTask = OCKTask(id: "RAITask", title: "Risk Analysis Index Survey", carePlanUUID: nil, schedule: rai30Schedule)
        rai30SurveyTask.impactsAdherence = true
        rai30SurveyTask.instructions = "Evaluate Patient Functional Capacity." */

        
        let smwt0ScheduleElem = OCKScheduleElement(start: morning, end: end, interval: DateComponents(day:365))
        
        let smwt30Start = Calendar.current.date(byAdding: .day, value: 30, to: postOperativeDate as! Date)
        let smwt30ScheduleElem = OCKScheduleElement(start: smwt30Start!, end: end, interval: DateComponents(day: 365))
        
        let smwt60Start = Calendar.current.date(byAdding: .day, value: 60, to: postOperativeDate as! Date)
        let smwt60ScheduleElem = OCKScheduleElement(start: smwt60Start!, end: end, interval: DateComponents(day: 365))
        
        let smwt0ActiveSchedule = OCKSchedule(composing: [smwt0ScheduleElem, smwt30ScheduleElem, smwt60ScheduleElem])
        var smwt0ActiveTask = OCKTask(id: "6MWT", title: "6 Minute Walking Test", carePlanUUID: nil, schedule: smwt0ActiveSchedule)
        smwt0ActiveTask.impactsAdherence = true
        smwt0ActiveTask.instructions = "Evaluate Patient's Exercise Capacity."
        
      //  let demo = OCKTask(id:"6MWT", title: "6 Minute Walking Test", carePlanUUID: nil, schedule: smwt0ActiveSchedule)
      //  let test = OCKEvent(task: demo, outcome: nil, scheduleEvent: OCKScheduleEvent(start: smwt30Start!, end: end!, element: smwt30ScheduleElem, occurrence: 1))
        
       /* let smwt30Start = Calendar.current.date(byAdding: .day, value: 30, to: postOpDate_)
        let smwt30ScheduleElem = OCKScheduleElement(start: smwt30Start!, end: end, interval: DateComponents(day: 365))
        let smwt30ActiveSchedule = OCKSchedule(composing: [smwt30ScheduleElem])
        var smwt30ActiveTask = OCKTask(id: "6MWT", title: "6 Minute Walking Test", carePlanUUID: nil, schedule: smwt30ActiveSchedule)
        smwt30ActiveTask.impactsAdherence = true
        smwt30ActiveTask.instructions = "Evaluate Patient's Exercise Capacity." */
        
        
       /* let smwt60Start = Calendar.current.date(byAdding: .day, value: 60, to: postOpDate_)
        let smwt60ScheduleElem = OCKScheduleElement(start: smwt60Start!, end: end, interval: DateComponents(day: 365))
        let smwt60ActiveSchedule = OCKSchedule(composing: [smwt60ScheduleElem])
        var smwt60ActiveTask = OCKTask(id: "6MWT", title: "6 Minute Walking Test", carePlanUUID: nil, schedule: smwt60ActiveSchedule)
        smwt60ActiveTask.impactsAdherence = true
        smwt60ActiveTask.instructions = "Evaluate Patient's Exercise Capacity." */
        
        addTasks([onboardingSurveyTask, wiq0SurveyTask, rai0SurveyTask, smwt0ActiveTask], callbackQueue: .main, completion: nil)
        
        //reset onboarding every year
        /*let wiqScheduleElem = OCKScheduleElement(start: morning, end: nil, interval: DateComponents(day:7))
        
        let wiqSurveySchedule = OCKSchedule(composing: [wiqScheduleElem])
        var wiqSurveyTask = OCKTask(id: "WIQTask", title: "WIQ Survey", carePlanUUID: nil, schedule: wiqSurveySchedule) //"OnboardingTask", "Onboarding Survey"
        wiqSurveyTask.impactsAdherence = true
        wiqSurveyTask.instructions = "Walking Impairment Questionnaire" */
        //"Complete the onboarding survey."
        
        //Add Onboarding Survey
        
       /* let onboardingScheduleElem = OCKScheduleElement(start: morning, end: nil, interval: DateComponents(day:365))
        
        let onboardingSurveySchedule = OCKSchedule(composing: [onboardingScheduleElem])
        var onboardingSurveyTask = OCKTask(id: "OnboardingTask", title: "Onboarding Survey", carePlanUUID: nil, schedule: onboardingSurveySchedule)
        onboardingSurveyTask.impactsAdherence = true
        onboardingSurveyTask.instructions = "Patient Onboarding Survey - Initial Info Intake." */
        
        //Add 6 Minute Walking Test
        
      /*  let sixMWTScheduleElem = OCKScheduleElement(start: morning, end: endSMWT, interval: DateComponents(day: 30))
        let sixMWTActiveSchedule = OCKSchedule(composing: [sixMWTScheduleElem])
        var sixMWTActiveTask = OCKTask(id: "6MWT", title: "6 Minute Walking Test", carePlanUUID: nil, schedule: sixMWTActiveSchedule)
        sixMWTActiveTask.impactsAdherence = true
        sixMWTActiveTask.instructions = "Evaluate Patient's Exercise Capacity." */
        
    /*    let raiScheduleElem = OCKScheduleElement(start: morning, end: endRAI, interval: DateComponents(day: 30))
        //raiScheduleElem.
        let raiSchedule = OCKSchedule(composing: [raiScheduleElem])
        var raiSurveyTask = OCKTask(id: "RAITask", title: "Risk Analysis Index Survey", carePlanUUID: nil, schedule: raiSchedule)
        raiSurveyTask.impactsAdherence = true
        raiSurveyTask.instructions = "Evaluate Patient Functional Capacity." */
        
        
        
        //Add SF-12 Survey
        
      /*  let sfTwelveScheduleElem = OCKScheduleElement(start: morning, end: nil, interval: DateComponents(day: 28))
        let sfTwelveSurveySchedule = OCKSchedule(composing: [sfTwelveScheduleElem])
        var sfTwelveSurveyTask = OCKTask(id: "SFTwelveTask", title: "SF-12 Health Questionnaire", carePlanUUID: nil, schedule: sfTwelveSurveySchedule)
        sfTwelveSurveyTask.impactsAdherence = true
        sfTwelveSurveyTask.instructions = "Complete Monthly Health Survey." */
        
        //Add DASI Questionnaire
        
     /*   let dasiScheduleElem = OCKScheduleElement(start: morning, end: nil, interval: DateComponents(day: 30))
        let dasiSchedule = OCKSchedule(composing: [dasiScheduleElem])
        var dasiSurveyTask = OCKTask(id: "DASITask", title: "DASI Questionnaire", carePlanUUID: nil, schedule: dasiSchedule)
        dasiSurveyTask.impactsAdherence = true
        dasiSurveyTask.instructions = "Evaluate Patient Functional Capacity." */
        
        
        
        
       // addTasks([onboardingSurveyTask, wiqSurveyTask, sixMWTActiveTask, raiSurveyTask], callbackQueue: .main, completion: nil)
        //dasiSurveyTask, sfTwelveSurveyTask, 
        createContacts()
        
    }
    
    func createContacts() {
        var contact1 = OCKContact(id: "oliver", givenName: "Oliver",
                                  familyName: "Aalami", carePlanUUID: nil)
        contact1.asset = "Contact1"
        contact1.title = "Vascular Surgeon"
        contact1.role = "Dr. Aalami is one of the Principal Investigators of the VascTrac study."
        contact1.emailAddresses = [OCKLabeledValue(label: CNLabelEmailiCloud, value: "aalami@stanford.edu")]
        contact1.phoneNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(650) 315-3236")]
        contact1.messagingNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(650) 315-3236")]

        contact1.address = {
            let address = OCKPostalAddress()
            address.street = "318 Campus Drive"
            address.city = "Stanford"
            address.state = "CA"
            address.postalCode = "94305"
            return address
        }()

        var contact2 = OCKContact(id: "elsie", givenName: "Elsie",
                                  familyName: "Ross", carePlanUUID: nil)
        contact2.asset = "Contact2"
        contact2.title = "Vascular Surgeon"
        contact2.role = "Dr. Ross is one of the Principal Investigators of the VascTrac study."
        contact1.emailAddresses = [OCKLabeledValue(label: CNLabelEmailiCloud, value: "elsie.ross@stanford.edu")]
        contact2.phoneNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(650) 723-5477")]
        contact2.messagingNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(650) 723-5477")]
        contact2.address = {
            let address = OCKPostalAddress()
            address.street = "318 Campus Drive"
            address.city = "Stanford"
            address.state = "CA"
            address.postalCode = "94305"
            return address
        }()

        addContacts([contact2, contact1])
    }
    
}

extension OCKHealthKitPassthroughStore {

    internal func populateSampleData() {

        let schedule = OCKSchedule.dailyAtTime(
            hour: 8, minutes: 0, start: Date(), end: nil, text: nil,
            duration: .hours(12), targetValues: [OCKOutcomeValue(100.0, units: "Steps")])

        let steps = OCKHealthKitTask(
            id: "steps",
            title: "Daily Steps Goal 🏃🏽‍♂️",
            carePlanUUID: nil,
            schedule: schedule,
            healthKitLinkage: OCKHealthKitLinkage(
                quantityIdentifier: .stepCount,
                quantityType: .cumulative,
                unit: .count()))

        addTasks([steps]) { result in
            switch result {
            case .success: print("Added tasks into HealthKitPassthroughStore!")
            case .failure(let error): print("Error: \(error)")
            }
        }
    }
}
