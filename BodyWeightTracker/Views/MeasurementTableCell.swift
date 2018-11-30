//
//  MeasurementTableCell.swift
//  BodyWeightTracker
//
//  Created by Benjamin Masters on 11/30/18.
//  Copyright © 2018 Benjamin Masters. All rights reserved.
//

import UIKit

class MeasurementTableCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var bfProperty: UILabel!
    @IBOutlet weak var weightProperty: UILabel!
    @IBOutlet weak var recordedDateProperty: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
