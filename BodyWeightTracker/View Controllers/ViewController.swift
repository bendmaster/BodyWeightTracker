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
    
    @IBOutlet weak var bfWarning: UILabel!
    
    @IBOutlet weak var wtWarning: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bodyFatField.delegate = self
        weightField.delegate = self
        weightField.text = ""
        bodyFatField.text = ""
        
        
        if let toggleState = UserDefaults.standard.value(forKey: themeKey) {
            toggleValue.isOn = toggleState as! Bool
        }
            
        else {
            UserDefaults.standard.set(toggleValue.isOn, forKey: themeKey)
        }
        
        themeToggle()
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        switch identifier {
            
        case "SubmitButtonSegue":
            return saveData()
            
        case "GraphBarButtonSegue", "TableBarButtonSegue":
            return true
            
        default:
            return false
            
        }
        
        
    }
    
    
    private func themeToggle() {
        if toggleValue.isOn {
            backgroundContainer.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
        else {
            backgroundContainer.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        }
    }
    
    private func displayWarning(textfield: UITextField, containsNonDigitChars: Bool) {
        if containsNonDigitChars != true {
            if textfield == bodyFatField {
                bfWarning.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.0)
            }
            else if textfield == weightField {
                wtWarning.textColor =  #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.0)
            }
            
        }
        else {
            if textfield == bodyFatField {
                bfWarning.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1).withAlphaComponent(1.0)
            }
            else if textfield == weightField {
                wtWarning.textColor =  #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1).withAlphaComponent(1.0)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789.").inverted
        let test = string.rangeOfCharacter(from: invalidCharacters)
        let check = test == nil
        displayWarning(textfield: textField, containsNonDigitChars: !check)
        return check
    }
    
    private func getNoon()-> Date {
        var now = Date()
        var nowComponents = DateComponents()
        let calendar = Calendar.current
        nowComponents.year = Calendar.current.component(.year, from: now)
        nowComponents.month = Calendar.current.component(.month, from: now)
        nowComponents.day = Calendar.current.component(.day, from: now)
        nowComponents.hour = 12
        nowComponents.minute = 00
        nowComponents.second = 00
        nowComponents.timeZone = NSTimeZone.local
        now = calendar.date(from: nowComponents)!
        return now as Date
    }
    
    @IBAction func toggle(_ sender: Any) {
        UserDefaults.standard.set(toggleValue.isOn, forKey: themeKey)
        themeToggle()
    }
    
    func saveData() -> Bool {
        
        let bf:String = bodyFatField.text!
        let wt:String = weightField.text!
        let context = container.viewContext
        
        if bf.count > 1 && wt.count > 1 {
            var calendar = Calendar.current
            calendar.timeZone = NSTimeZone.local
            
            // Get today's beginning & end
            let dateFrom = calendar.startOfDay(for: Date())
            let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)!
            
            // Set predicate as date being today's date
            let fromPredicate = NSPredicate(format: "dateCreated >= %@", dateFrom as NSDate)
            let toPredicate = NSPredicate(format: "dateCreated < %@", dateTo as NSDate)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
            
            let request: NSFetchRequest<MeasurementEntry> = MeasurementEntry.fetchRequest()
            request.predicate = datePredicate
            
            let retrievedEntry = try? context.fetch(request)
            
            if !(retrievedEntry?.isEmpty)! {
                
                let previouslyRecordedEntry = retrievedEntry![0]
                
                let beforeNoon = (Date() < getNoon())
                if beforeNoon {
                    previouslyRecordedEntry.bodyFatMorning = Double(bf)!
                    previouslyRecordedEntry.weightMorning = Double(wt)!
                }
                else {
                    previouslyRecordedEntry.bodyFatAfternoon = Double(bf)!
                    previouslyRecordedEntry.weightAfternoon = Double(wt)!
                }
                
            }
            else {
                
                let entry = MeasurementEntry(context: context)
                entry.dateCreated = Date()
                let beforeNoon = (entry.dateCreated! < getNoon())
                if beforeNoon {
                    entry.bodyFatMorning = Double(bf)!
                    entry.weightMorning = Double(wt)!
                }
                else {
                    entry.bodyFatAfternoon = Double(bf)!
                    entry.weightAfternoon = Double(wt)!
                }
            }
            
            
            try? context.save()
            return true
            
        }
            
        else {
            return false
        }
    }
    
    
    
}

