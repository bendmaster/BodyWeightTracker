//
//  MeasurementTableViewController.swift
//  BodyWeightTracker
//
//  Created by Benjamin Masters on 11/30/18.
//  Copyright © 2018 Benjamin Masters. All rights reserved.
//

import UIKit
import CoreData

class MeasurementTableViewController: UITableViewController {
    
    // MARK: Properties
    
    let container = ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer)!
    
    var entries = [MeasurementEntry]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let context = container.viewContext
        
        entries = loadMeasurementEntries(context: context)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entries.count
    }
    
    func loadMeasurementEntries(context: NSManagedObjectContext) -> [MeasurementEntry] {
        let request: NSFetchRequest<MeasurementEntry> = MeasurementEntry.fetchRequest()
        let result = try? context.fetch(request)
        return result!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MeasurementTableCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MeasurementTableCell else {
            fatalError("couldn't load cell in tableView method")
        }
        
        let entry = entries[indexPath.row]
        
        cell.bfProperty.text = " BF%: " + String(entry.bodyFat)
        cell.weightProperty.text = " Weight: " + String(entry.weight)
        let unformattedDate = entry.dateCreated!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.string(from: unformattedDate)
        print(date)
        cell.recordedDateProperty.text = " Recorded: " + date
        

        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
