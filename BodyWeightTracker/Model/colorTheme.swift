//
//  colorTheme.swift
//  BodyWeightTracker
//
//  Created by Benjamin Masters on 12/15/18.
//  Copyright © 2018 Benjamin Masters. All rights reserved.
//

import Foundation
import UIKit


struct colorTheme {
    
    var backgroundColor: UIColor
    var textColor: UIColor
    var buttonColor: UIColor
    var buttonTextColor: UIColor
    var errorColor: UIColor
    
    init(backgroundColor: UIColor, textColor: UIColor, buttonColor: UIColor, buttonTextColor: UIColor, errorColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.buttonColor = buttonColor
        self.buttonTextColor = buttonTextColor
        self.errorColor = errorColor
    }
}
