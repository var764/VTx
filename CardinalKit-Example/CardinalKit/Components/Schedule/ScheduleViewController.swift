//
//  ScheduleViewController.swift
//  CardinalKit_Example
//
//  Created by Santiago Gutierrez on 12/21/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import CareKit
import CareKitStore
import UIKit
import SwiftUI
import FirebaseFirestore
import RealmSwift
import ResearchKit
import CardinalKit
import CareKitUI
//import FLCharts


class ScheduleViewController: OCKDailyPageViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Schedule"
        
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
        
    }
    
    override func dailyPageViewController(_ dailyPageViewController: OCKDailyPageViewController, prepare listViewController: OCKListViewController, for date: Date) {
        
        let identifiers = ["surveys", "OnboardingTask", "WIQTask", "6MWT", "RAITask"] //"DASITask" "SFTwelveTask"
        var query = OCKTaskQuery(for: date)
        query.ids = identifiers
        query.excludesTasksWithNoEvents = true

        storeManager.store.fetchAnyTasks(query: query, callbackQueue: .main) { result in
            switch result {
            case .failure(let error): print("Error: \(error)")
            case .success(let tasks):

                // Add a non-CareKit view into the list
               /* let tipTitle = "Customize your app!"
                let tipText = "Start with the CKConfiguration.plist file."

                // Only show the tip view on the current date
                if Calendar.current.isDate(date, inSameDayAs: Date()) {
                    let tipView = TipView()
                    tipView.headerView.titleLabel.text = tipTitle
                    tipView.headerView.detailLabel.text = tipText
                    tipView.imageView.image = UIImage(named: "GraphicOperatingSystem")
                    listViewController.appendView(tipView, animated: false)
                } */

               /* if #available(iOS 14, *), let walkTask = tasks.first(where: { $0.id == "6MWT" }) {

                    let view = SimpleTaskView(
                        task: walkTask,
                        eventQuery: OCKEventQuery(for: date),
                        storeManager: self.storeManager).padding([.vertical], 10)
                    
                   /* NumericProgressTaskView(
                        task: walkTask,
                        eventQuery: OCKEventQuery(for: date),
                        storeManager: self.storeManager)
                        .padding([.vertical], 10) */

                    listViewController.appendViewController(view.formattedHostingController(), animated: false)
                } */
                
                //Onboarding Survey//
                
                if let onboardingSurveyTask = tasks.first(where: {$0.id == "OnboardingTask"}) {
                    let surveyCard = OnboardingSurveyViewController(
                        viewSynchronizer: OnboardingSurveyViewSynchronizer(),
                        task: onboardingSurveyTask,
                        eventQuery: .init(for: date),
                        storeManager: self.storeManager)
                                                                    
                    listViewController.appendViewController(surveyCard, animated: false)
                }
                
                if let wiqSurveyTask = tasks.first(where: {$0.id == "WIQTask"}) {
                    //"OnboardingTask"
                    let surveyCard = SurveyItemViewController(
                        viewSynchronizer: SurveyItemViewSynchronizer(),
                        task: wiqSurveyTask,
                        eventQuery: .init(for: date),
                        storeManager: self.storeManager)
        
                    listViewController.appendViewController(surveyCard, animated: false)
                }
                
              /*  if let sfTwelveSurveyTask = tasks.first(where: {$0.id == "SFTwelveTask"})
                {
                    let surveyCard = SFTwelveSurveyViewController(
                        viewSynchronizer: SFTwelveSurveyViewSynchronizer(),
                        task: sfTwelveSurveyTask,
                        eventQuery: .init(for: date),
                        storeManager: self.storeManager)
                    
                    listViewController.appendViewController(surveyCard, animated: false)
                } */
                
                if let sixMWT = tasks.first(where: {$0.id == "6MWT"}) {
                    let surveyCard = SixMWTActiveViewController(
                        viewSynchronizer: SixMWTActiveViewSynchronizer(),
                        task: sixMWT,
                        eventQuery: .init(for: date),
                        storeManager: self.storeManager)
                    
                    listViewController.appendViewController(surveyCard, animated: false)
                }
                
                if let raiTask = tasks.first(where: {$0.id == "RAITask"}) {
                    let surveyCard = RAISurveyViewController(
                        viewSynchronizer: RAISurveyViewSynchronizer(),
                        task: raiTask,
                        eventQuery: .init(for: date),
                        storeManager: self.storeManager)
                    
                    listViewController.appendViewController(surveyCard, animated: false)
                }
                
                //WIQ Chart//
                
                // dynamic gradient colors
                let wiqGradientStart = UIColor { traitCollection -> UIColor in
                    return traitCollection.userInterfaceStyle == .light ? #colorLiteral(red: 0.9960784314, green: 0.3725490196, blue: 0.368627451, alpha: 1) : #colorLiteral(red: 0.8627432641, green: 0.2630574384, blue: 0.2592858295, alpha: 1)
                }
                let wiqGradientEnd = UIColor { traitCollection -> UIColor in
                    return traitCollection.userInterfaceStyle == .light ? #colorLiteral(red: 0.9960784314, green: 0.4732026144, blue: 0.368627451, alpha: 1) : #colorLiteral(red: 0.8627432641, green: 0.3598620686, blue: 0.2592858295, alpha: 1)
                }
                
                
                func noReturn() {
                    print("No data.")
                }
                
                /*let aggregator = OCKEventAggregator.custom {events -> Double in
                    let value = events.first?.outcome?.values.first?.doubleValue ?? 0
                    return Double(value)
                }
                                                            
                let wiqDataSeries = OCKDataSeriesConfiguration(
                    taskID: "WIQTask",
                    legendTitle: "WIQ Score (%)",
                    gradientStartColor: wiqGradientStart,
                    gradientEndColor: wiqGradientEnd,
                    markerSize: 3,
                    eventAggregator: aggregator)*/
                
             //   @ObservedObject var dataViewModel = WIQChartViewModel()
             //   var wiqPlotData = dataViewModel.wiqPoints
                
                
                let defaults = UserDefaults.standard
                var wiqGoal = 0
                var wiqDataArr : [Int : Double] = [:]
                var wiqPoints : [CGFloat] = []
                
                guard let authCollection =  CKStudyUser.shared.authCollection else { return }
                let db = Firestore.firestore()
                let collectionRef = db.collection(authCollection + "wiqscore")
                wiqGoal = defaults.integer(forKey: "wiqscore")
                var ind = 0
                var weekPoints = [Int]()

                collectionRef.order(by: "payload.date", descending: false).limit(to: 56).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            let payload = document.data()["payload"] as? [String : Any]  // cast payload to dic
                            let runningtotal = payload?["wiqscore"] as? Double ?? 0
                            print("Float running total: ")
                            print(CGFloat(runningtotal))
                            wiqPoints.append(CGFloat(runningtotal))
                            weekPoints.append(ind)
                            // add in dictionary with key = document date
                            wiqDataArr[ind] = runningtotal
                            ind += 1
                        }
                        print("this is data arr")
                        print("see stored wiq data:")
                        print(wiqDataArr)
                        
                        let test = OCKDataSeries(values: wiqPoints, title: "Weekly Patient WIQ Score (%)", gradientStartColor: wiqGradientStart, gradientEndColor: wiqGradientEnd, size: 15)
           
                        let chart = OCKCartesianChartView(type: .bar)

                        chart.graphView.dataSeries = [test]
                        chart.graphView.yMaximum = 100
                        chart.graphView.yMinimum = 0
                        chart.graphView.xMaximum = 8
                        chart.graphView.xMinimum = 0
                        chart.headerView.titleLabel.text = "WIQ Score"
                        chart.headerView.detailLabel.text = "Past 8 Weeks"
                        chart.autoresizesSubviews = true
                        listViewController.appendView(chart, animated: false)
                        
                    }
                }
                
                
                print("Working pt. 1")
                print(wiqPoints)
                
         /*       let test = OCKDataSeries(values: wiqPoints, title: "Weekly Patient WIQ Score (%)", gradientStartColor: wiqGradientStart, gradientEndColor: wiqGradientEnd, size: 2)
                
                let chart = OCKCartesianChartView(type: .bar)
                
                chart.graphView.dataSeries = [test]
                chart.graphView.yMaximum = 100
                chart.graphView.yMinimum = 0
                chart.graphView.xMaximum = 8
                chart.graphView.xMinimum = 0
                chart.headerView.titleLabel.text = "WIQ Score"
                chart.headerView.detailLabel.text = "Past 8 Weeks"
                chart.autoresizesSubviews = true */
                //chart.contentStackView.showsOuterSeparators = true
                
                //listViewController.appendView(chart, animated: false)
                
                
                /*let insightsCard = OCKCartesianChartViewController(
                    plotType: .line,
                    selectedDate: date,
                    configurations: [wiqDataSeries],
                    storeManager: self.storeManager)

                //insightsCard.chartView.graphView.axisView.autoresizesSubviews = true
                insightsCard.chartView.autoresizesSubviews = true
                insightsCard.chartView.graphView.accessibilityRespondsToUserInteraction = true
                insightsCard.chartView.graphView.xMinimum = 0
                insightsCard.chartView.graphView.xMaximum = 20

                
                insightsCard.chartView.headerView.titleLabel.text = "WIQ Score"
                insightsCard.chartView.headerView.detailLabel.text = "Weekly Tracking."
                insightsCard.chartView.accessibilityLabel = "WIQ Score, Weekly Tracking."*/
                //listViewController.appendViewController(insightsCard, animated: false)
            
                
               /* OCKChartViewController.
                
                CKSendHelper.getFromFirestore(collection: "wiqscore", identifier: "userID") { (document, error) in
                    
                    guard let scores = document?.data()?["wiqscore"] as? [[AnyHashable: Any]] else {                        return
                    }
                    guard let dates = document?.data()?["date"] as? [[AnyHashable: Any]] else {
                        return
                    }
                    
                    for elem in scores {
                        print(elem)
                    }
                    
                    for el in dates {
                        print(el)
                    }
                } */

                // Since the coffee task is only scheduled every other day, there will be cases
                // where it is not contained in the tasks array returned from the query.
                /*if let coffeeTask = tasks.first(where: { $0.id == "coffee" }) {
                    let coffeeCard = OCKSimpleTaskViewController(task: coffeeTask, eventQuery: .init(for: date),
                                                                 storeManager: self.storeManager)
                    listViewController.appendViewController(coffeeCard, animated: false)
                    
                    
                    let secondCoffeCard = TestViewController(viewSynchronizer: TestItemViewSynchronizer(), task: coffeeTask, eventQuery: .init(for: date), storeManager: self.storeManager)
                    
                    listViewController.appendViewController(secondCoffeCard, animated: false)
                }
                
                if let surveyTask = tasks.first(where: { $0.id == "survey" }) {
                    let surveyCard = SurveyItemViewController(
                        viewSynchronizer: SurveyItemViewSynchronizer(),
                        task: surveyTask,
                        eventQuery: .init(for: date),
                        storeManager: self.storeManager)
                    
                    listViewController.appendViewController(surveyCard, animated: false)
                } */
                // Create a card with all surveys events
//                let surveys = tasks.filter({ $0.id.contains("Survey_") })
//                if surveys.count>0{
//                    for survey in surveys{
//
//                    }
//                }
                
                if let surveysTask = tasks.first(where: {$0.id == "surveys"}){
                    let surveysCard = CheckListItemViewController(
                        viewSynchronizer: CheckListItemViewSynchronizer(),
                        task: surveysTask,
                        eventQuery: .init(for: date),
                        storeManager: self.storeManager)

                    listViewController.appendViewController(surveysCard, animated: false)
                }
                
//                // Create a card for the water task if there are events for it on this day.
//                if let doxylamineTask = tasks.first(where: { $0.id == "doxylamine" }) {
//
//                    let doxylamineCard = CheckListItemViewController(
//                        viewSynchronizer: CheckListItemViewSynchronizer(),
//                        task: doxylamineTask,
//                        eventQuery: .init(for: date),
//                        storeManager: self.storeManager)
//
//                    listViewController.appendViewController(doxylamineCard, animated: false)
//                }

                // Create a card for the nausea task if there are events for it on this day.
                // Its OCKSchedule was defined to have daily events, so this task should be
                // found in `tasks` every day after the task start date.
                if let nauseaTask = tasks.first(where: { $0.id == "nausea" }) {

                    // dynamic gradient colors
                    let nauseaGradientStart = UIColor { traitCollection -> UIColor in
                        return traitCollection.userInterfaceStyle == .light ? #colorLiteral(red: 0.9960784314, green: 0.3725490196, blue: 0.368627451, alpha: 1) : #colorLiteral(red: 0.8627432641, green: 0.2630574384, blue: 0.2592858295, alpha: 1)
                    }
                    let nauseaGradientEnd = UIColor { traitCollection -> UIColor in
                        return traitCollection.userInterfaceStyle == .light ? #colorLiteral(red: 0.9960784314, green: 0.4732026144, blue: 0.368627451, alpha: 1) : #colorLiteral(red: 0.8627432641, green: 0.3598620686, blue: 0.2592858295, alpha: 1)
                    }

                    // Create a plot comparing nausea to medication adherence.
                    let nauseaDataSeries = OCKDataSeriesConfiguration(
                        taskID: "nausea",
                        legendTitle: "Nausea",
                        gradientStartColor: nauseaGradientStart,
                        gradientEndColor: nauseaGradientEnd,
                        markerSize: 10,
                        eventAggregator: OCKEventAggregator.countOutcomeValues)

                    let doxylamineDataSeries = OCKDataSeriesConfiguration(
                        taskID: "doxylamine",
                        legendTitle: "Doxylamine",
                        gradientStartColor: .systemGray2,
                        gradientEndColor: .systemGray,
                        markerSize: 10,
                        eventAggregator: OCKEventAggregator.countOutcomeValues)

                    let insightsCard = OCKCartesianChartViewController(
                        plotType: .bar,
                        selectedDate: date,
                        configurations: [nauseaDataSeries, doxylamineDataSeries],
                        storeManager: self.storeManager)

                    insightsCard.chartView.headerView.titleLabel.text = "Nausea & Doxylamine Intake"
                    insightsCard.chartView.headerView.detailLabel.text = "This Week"
                    insightsCard.chartView.headerView.accessibilityLabel = "Nausea & Doxylamine Intake, This Week"
                    listViewController.appendViewController(insightsCard, animated: false)

                    // Also create a card that displays a single event.
                    // The event query passed into the initializer specifies that only
                    // today's log entries should be displayed by this log task view controller.
                    let nauseaCard = OCKButtonLogTaskViewController(task: nauseaTask, eventQuery: .init(for: date),
                                                                    storeManager: self.storeManager)
                    listViewController.appendViewController(nauseaCard, animated: false)
                }
            }
        }

        
    }
    
}


private extension View {
    func formattedHostingController() -> UIHostingController<Self> {
        let viewController = UIHostingController(rootView: self)
        viewController.view.backgroundColor = .clear
        return viewController
    }
}

