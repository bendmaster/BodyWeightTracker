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
    
    let themeKey = "theme"
    
    @IBOutlet weak var bodyFatField: UITextField!
    
    @IBOutlet weak var toggleValue: UISwitch!
    
    @IBOutlet weak var weightField: UITextField!
    
    @IBOutlet weak var backgroundContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bodyFatField.delegate = self
        weightField.delegate = self
        
        if let toggleState = UserDefaults.standard.value(forKey: themeKey) {
            toggleValue.isOn = toggleState as! Bool
        }
            
        else {
            UserDefaults.standard.set(toggleValue.isOn, forKey: themeKey)
        }
        
        themeToggle()
        
    }
    

    
    @IBAction func submitButton(_ sender: Any) {
        guard let bf:String = bodyFatField.text else { return }
        guard let wt:String = weightField.text else { return }
        
        let newEntry = MeasurementEntry(bodyFatMeasurement: Double(bf) ?? 0, weightMeasurement: Double(wt) ?? 0)
        
//        _ = insertMeasurementIntoDB(measurement: newEntry)
        
        printDBStats()
    }
    
    func themeToggle() {
        if toggleValue.isOn {
            backgroundContainer.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
        else {
            backgroundContainer.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        }
    }
    
    
    @IBOutlet weak var submitTopConstraint: NSLayoutConstraint!
    
    @IBAction func toggle(_ sender: Any) {
        UserDefaults.standard.set(toggleValue.isOn, forKey: themeKey)
        themeToggle()
    }
    
    @IBOutlet weak var submitBottomConstraint: NSLayoutConstraint!
    
    private func insertMeasurementIntoDB(measurement: MeasurementEntry) -> Measurement {
        
        let container: NSPersistentContainer = ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer)!
        
        let context = container.viewContext
        
        let entry = Measurement(context: context)
        
        entry.bodyFatMeasurement = measurement.bodyFatMeasurement
        entry.entryID = Int32(measurement.entryID)
        entry.weightMeasurement = measurement.weightMeasurement
        entry.dateCaptured = measurement.dateCaptured
        
        try? context.save()
        
        return entry
        
    }
    
    private func printDBStats() {
        let container: NSPersistentContainer = ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer)!
        
        let context = container.viewContext
        
        let request: NSFetchRequest<Measurement> = Measurement.fetchRequest()
        
        if let measurementCount = try? context.fetch(request) {
            for measure in measurementCount {
                print("ID:\(measure.entryID)\nBF:\(measure.bodyFatMeasurement)\nWeight:\(measure.weightMeasurement)\nDate:\(measure.dateCaptured!)\n\n")
            }
            bodyFatField.text = String(measurementCount[0].bodyFatMeasurement)
            weightField.text = String(measurementCount[0].weightMeasurement)
        }
    }
    
}

