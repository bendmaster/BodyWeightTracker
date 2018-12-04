//
//  SubmitButton.swift
//  BodyWeightTracker
//
//  Created by Benjamin Masters on 12/3/18.
//  Copyright © 2018 Benjamin Masters. All rights reserved.
//

import UIKit

class SubmitButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        layer.cornerRadius = frame.width / 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        layer.masksToBounds = false
        layer.shadowRadius = 1.0
        layer.shadowOpacity = 1.0
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: -3.0, height: -3.0)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        backgroundColor  = .blue
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
    }
    
}
