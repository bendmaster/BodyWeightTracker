//
//  ViewController.swift
//  BodyWeightTracker
//
//  Created by Benjamin Masters on 11/26/18.
//  Copyright © 2018 Benjamin Masters. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bodyFatField.delegate = self
        weightField.delegate = self
        
    }
    
    @IBOutlet weak var bodyFatField: UITextField!
    
    @IBOutlet weak var weightField: UITextField!
    
    @IBAction func submitButton(_ sender: Any) {
        guard let bf:String = bodyFatField.text else { return }
        guard let wt:String = weightField.text else { return }
        
        let newEntry = MeasurementEntry(bodyFatMeasurement: Double(bf) ?? 0, weightMeasurement: Double(wt) ?? 0)
        
        _ = insertMeasurementIntoDB(measurement: newEntry)
        printDBStats()
    }
    

    @IBOutlet weak var submitTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var submitBottomConstraint: NSLayoutConstraint!
    
    private func insertMeasurementIntoDB(measurement: MeasurementEntry) -> Measurement {
        
        let container: NSPersistentContainer = ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer)!
        
        let context = container.viewContext
        
        let entry = Measurement(context: context)
        
        entry.bodyFatMeasurement = measurement.bodyFatMeasurement
        entry.entryID = Int32(measurement.entryID)
        entry.weightMeasurement = measurement.weightMeasurement
        entry.dateCaptured = measurement.dateCaptured
        
        return entry
        
    }
    
    private func printDBStats() {
        let container: NSPersistentContainer = ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer)!
        
        let context = container.viewContext
        
        let request: NSFetchRequest<Measurement> = Measurement.fetchRequest()
        
        if let measurementCount = try? context.fetch(request) {
            for measure in measurementCount {
                print(measure)
            }
        }
    }
    
}

