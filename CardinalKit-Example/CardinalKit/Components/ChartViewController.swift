//
//  ChartViewController.swift
//  CardinalKit_Example
//
//  Created by Varun on 3/12/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
//import Charts
import UIKit
//import TinyConstraints
import CareKit
import FirebaseCore
import FirebaseFirestore
import RealmSwift
import CareKitStore
//import SwiftUICharts
import SwiftUI
//import SwiftUICharts
import FLCharts
import UIKit
import CardinalKit

class ChartViewController: UIViewController {
    
    @IBOutlet weak var chartView: FLChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let barChartData = FLChartData(title: "Weekly WIQ Score",
                                       data: weeksData,
                                       legendKeys: [Key(key: "Patient WIQ Score", color: .init(startColor: .red, endColor: .purple))], unitOfMeasure: "Percent (%)")
        
        barChartData.xAxisUnitOfMeasure = "Weeks"
        //barChartData.yAxisFormatter = .decimal(2)
        let lineChart = FLChart(data: barChartData, type: .line())
        lineChart.cartesianPlane.showUnitsOfMeasure = true
        lineChart.showAverageLine = true
        
        let testing = WIQDataModel()
        testing.getData()
        
        let card = FLCard(chart: lineChart, style: .rounded)
        card.showAverage = true
        card.showLegend = true
        
        view.addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            card.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            card.heightAnchor.constraint(equalToConstant: 290),
            card.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
}
extension ChartViewController {
    var weeksData: [SinglePlotable] {
        [SinglePlotable(name: "Week 1", value: 30)]
    }
}

class WIQDataModel {
    
    let db = Firestore.firestore()
    let settings = FirestoreSettings()
    
    func getData() {
        let studyCollection = CKStudyUser.shared.studyCollection
        let dataCollection: String = "wiqscore"
        let targetCollection = "\(dataCollection)"
        let test = CKSendHelper.getFromFirestore(authCollection: studyCollection, collection: targetCollection, onCompletion: { (documents,error) in
            guard let documents = documents,
                 documents.count>0 else {
                print("Empty collection.")
               return
            }
            var objResult = [[String:Any]]()
            for document in documents {
                if let data = document.data(){
                    objResult.append(data)
                }
            }
            if objResult.count == 0 {
                print("Empty results object.")
            }
            else {
                for elem in objResult {
                    print(elem)
                }
            }
        })
    }
                                                 
    func retrieveData() {
        db.collection("wiqscore").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
}

/*class ChartViewController: UIViewController {
    lazy var test: View = {
        let demo = ChartViewTest()
        return demo
    }()
    //var line = LineView
   // lazy var lineTest: View = {
        //let chart = LineView(data: [0, 1], title: "Title", legend: "Legend").padding()
        //LineView.LineView(data: [0, 1], title: "Test")
        //return chart
  //  }()

   // var test: ChartView = {
   //     return LineView.
   // }()
} */
/*class ChartViewController: UIViewController, ChartViewDelegate {
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .systemBlue
        
        chartView.rightAxis.enabled = false
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .white
        yAxis.labelPosition = .insideChart
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        chartView.xAxis.setLabelCount(6, force: false)
        chartView.xAxis.labelTextColor = .white
        chartView.xAxis.axisLineColor = .systemBlue
        
        chartView.animate(xAxisDuration: 2.5)
        
        
        return chartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)
        
        setData()
        
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func setData() {
        let set_1 = LineChartDataSet(entries: yVals, label: "WIQ Score (%)")
        set_1.mode = .cubicBezier
        set_1.drawCirclesEnabled = false
        set_1.lineWidth = 3
        set_1.setColor(.white)
        set_1.fill = ColorFill(color: .white)
        set_1.fillAlpha = 0.8
        set_1.drawFilledEnabled = true
        
        set_1.drawHorizontalHighlightIndicatorEnabled = false
        set_1.highlightColor = .systemRed
        
        let data = LineChartData(dataSet: set_1)
        data.setDrawValues(false)
        
        lineChartView.data = data
    }

    let yVals: [ChartDataEntry] = [ChartDataEntry(x: 0, y: 5), ChartDataEntry(x: 10, y: 0)]
    
    
    
}*/
