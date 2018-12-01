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
    
    // MARK: Variables
    
    let themeKey = "theme"
    
    let container = ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer)!
    
    
    // MARK: Outlets
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let context = container.viewContext

        
        try? context.save()
    }
    
    
    @IBAction func submitButton(_ sender: Any) {
        
        let bf:String = bodyFatField.text!
        let wt:String = weightField.text!
        let context = container.viewContext
        
        let entry = MeasurementEntry(context: context)
        
        entry.bodyFat = Double(bf)!
        entry.weight = Double(wt)!
        entry.dateCreated = Date()
        
        try? context.save()     
        

    }
    
    func themeToggle() {
        if toggleValue.isOn {
            backgroundContainer.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
        else {
            backgroundContainer.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        }
    }
    
    
    @IBAction func toggle(_ sender: Any) {
        UserDefaults.standard.set(toggleValue.isOn, forKey: themeKey)
        themeToggle()
    }
    
    
    
}

