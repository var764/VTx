//
//  Extensions+UIColor.swift
//  CardinalKit_Example
//
//  Created by Santiago Gutierrez on 10/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

public extension UIColor {
    class func greyText() -> UIColor {
        return UIColor(netHex: 0x989998)
    }
    
    class func lightWhite() -> UIColor {
        return UIColor(netHex: 0xf7f8f7)
    }

    class func primaryColor() -> UIColor {
        UIColor(red: 1.00, green: 0.22, blue: 0.38, alpha: 1.00)
    }
}
