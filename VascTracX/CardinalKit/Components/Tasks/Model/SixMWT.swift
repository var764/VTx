//
//  SixMWT.swift
//  CardinalKit_Example
//
//  Created by Varun on 2/9/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import ResearchKit

struct SixMWT {
    static let sixMWTTask: ORKOrderedTask = {
        let intendedUseDescription = "Evaluates patient ability to walk at a normal pace."
        
        return ORKOrderedTask.fitnessCheck(withIdentifier: "6MWT", intendedUseDescription: "Please walk at a normal pace for 6 minutes.", walkDuration: TimeInterval(360), restDuration: TimeInterval(0), options: ORKPredefinedTaskOption.excludeInstructions)
        
    }()

}
