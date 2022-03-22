//
//  ChartViewControllerRepresentable.swift
//  CardinalKit_Example
//
//  Created by Varun on 3/12/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

struct ChartViewControllerRepresentable: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIViewController
    
    func updateUIViewController(_ taskViewController: UIViewController, context: Context) {}
    func makeUIViewController(context: Context) -> UIViewController {
        let manager = CKCareKitManager.shared
        let vc = ChartViewController()
        return UINavigationController(rootViewController: vc)
    }
    
}
