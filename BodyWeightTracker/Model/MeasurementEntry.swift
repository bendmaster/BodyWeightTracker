//
//  MeasurementEntry.swift
//  BodyWeightTracker
//
//  Created by Benjamin Masters on 11/26/18.
//  Copyright © 2018 Benjamin Masters. All rights reserved.
//

import Foundation


struct MeasurementEntry: Codable {
    var bodyFatMeasurement: Double
    var weightMeasurement: Double
    var dateCaptured: Date
    var entryID: Int
    
    static var uniqueId = 0
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init(bodyFatMeasurement: Double, weightMeasurement: Double) {
        self.bodyFatMeasurement = bodyFatMeasurement
        self.weightMeasurement = weightMeasurement
        self.entryID = MeasurementEntry.uniqueId
        self.dateCaptured = Date()
        MeasurementEntry.uniqueId += 1
        
    }
}
