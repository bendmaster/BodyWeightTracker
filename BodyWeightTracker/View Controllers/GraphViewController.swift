//
//  GraphViewController.swift
//  BodyWeightTracker
//
//  Created by Benjamin Masters on 12/1/18.
//  Copyright © 2018 Benjamin Masters. All rights reserved.
//

import UIKit
import ScrollableGraphView
import CoreData

class GraphViewController: UIViewController, ScrollableGraphViewDataSource {
    
    // MARK: Properties
    
    @IBOutlet weak var bodyFatGraph: ScrollableGraphView!
    @IBOutlet weak var weightGraph: ScrollableGraphView!
    let container = ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer)!
    var weightLinePlotData = [Double]()
    var bodyfatLinePlotData = [Double]()
    var datesRecorded = [String]()
    var dateFormatter = DateFormatter()
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load context
        let context = container.viewContext
        dateFormatter.dateFormat = "MM/dd"
        
        //Retrieve entries from entities and split them out into respective arrays
        let entries = retrieveDataPoints(from: context)
        parseDataToArrays(entries: entries)
        
        //Establish Body Fat Graph
        let BFlinePlot = LinePlot(identifier: "BF")
        
        BFlinePlot.shouldFill = true
        BFlinePlot.fillColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        BFlinePlot.fillType = ScrollableGraphViewFillType.solid
        BFlinePlot.lineColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        BFlinePlot.lineWidth = 1
        BFlinePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        let BFReferenceLines = ReferenceLines()
        BFReferenceLines.absolutePositions = [5.0, 7.5, 10.0, 12.5, 15.0, 17.5, 20.0, 22.5, 25.0, 27.5, 30.0]
        bodyFatGraph.addPlot(plot: BFlinePlot)
        bodyFatGraph.shouldAdaptRange = true
        bodyFatGraph.backgroundFillColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        bodyFatGraph.addReferenceLines(referenceLines: BFReferenceLines)
        bodyFatGraph.dataSource = self
        
        // Establish Weight Graph
        let WTlinePlot = LinePlot(identifier: "WT")
        
        WTlinePlot.shouldFill = true
        WTlinePlot.fillColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        WTlinePlot.fillType = ScrollableGraphViewFillType.solid
        WTlinePlot.lineColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        WTlinePlot.lineWidth = 1
        WTlinePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        let WeightReferenceLines = ReferenceLines()
        WeightReferenceLines.absolutePositions = [0, 25, 50, 75, 100, 125, 150, 175, 200, 225, 250, 275, 300]
        weightGraph.addPlot(plot: WTlinePlot)
        weightGraph.backgroundFillColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        weightGraph.shouldAdaptRange = true
        weightGraph.addReferenceLines(referenceLines: WeightReferenceLines)
        weightGraph.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        // Return the data for each plot.
        switch(plot.identifier) {
        case "BF":
            return bodyfatLinePlotData[pointIndex]
        case "WT":
            return weightLinePlotData[pointIndex]
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return datesRecorded[pointIndex]
    }
    
    func numberOfPoints() -> Int {
        return bodyfatLinePlotData.count
    }
    
    func retrieveDataPoints(from context: NSManagedObjectContext) -> [MeasurementEntry] {
        
        let request: NSFetchRequest<MeasurementEntry> = MeasurementEntry.fetchRequest()
        let result = try? context.fetch(request)
        
        return result!
        
    }
    
    func parseDataToArrays(entries: [MeasurementEntry]) {
        
        for entry in entries {
            self.bodyfatLinePlotData.append(entry.bodyFat)
            self.weightLinePlotData.append(entry.weight)
            self.datesRecorded.append(dateFormatter.string(from: entry.dateCreated!))
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
