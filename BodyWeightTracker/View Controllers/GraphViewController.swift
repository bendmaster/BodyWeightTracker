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
    var weightLinePlotDataFromMorning = [Double]()
    var bodyfatLinePlotDataFromMorning = [Double]()
    var weightLinePlotDataFromAfternoon = [Double]()
    var bodyfatLinePlotDataFromAfternoon = [Double]()
    var datesRecorded = [String]()
    var dateFormatter = DateFormatter()
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load context
        let context = container.viewContext
        dateFormatter.dateFormat = "MM/dd"
        
        //Retrieve entries from entities and split them out into respective arrays
        let entries = retrieveDataPoints(context: context)
        parseDataToArrays(entries: entries)
        
        //Establish Body Fat Graph
        let BFMorningLinePlot = LinePlot(identifier: "BFMorning")
        let BFAfternoonLinePlot = LinePlot(identifier: "BFAfternoon")
        
        //Morning plot
        BFMorningLinePlot.shouldFill = true
        BFMorningLinePlot.fillColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1).withAlphaComponent(0.5)
        BFMorningLinePlot.fillType = ScrollableGraphViewFillType.solid
        BFMorningLinePlot.lineColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        BFMorningLinePlot.lineWidth = 3
        BFMorningLinePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        //Afternoon plot
        BFAfternoonLinePlot.shouldFill = true
        BFAfternoonLinePlot.fillColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1).withAlphaComponent(0.5)
        BFAfternoonLinePlot.fillType = ScrollableGraphViewFillType.solid
        BFAfternoonLinePlot.lineColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        BFAfternoonLinePlot.lineWidth = 3
        BFAfternoonLinePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        let BFReferenceLines = ReferenceLines()
        BFReferenceLines.absolutePositions = [5.0, 7.5, 10.0, 12.5, 15.0, 17.5, 20.0, 22.5, 25.0, 27.5, 30.0]
        
        bodyFatGraph.addPlot(plot: BFAfternoonLinePlot)
        bodyFatGraph.addPlot(plot: BFMorningLinePlot)
        
        bodyFatGraph.shouldAdaptRange = true
        bodyFatGraph.backgroundFillColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        bodyFatGraph.addReferenceLines(referenceLines: BFReferenceLines)
        bodyFatGraph.dataSource = self
        
        // Establish Weight Graph
        let WTMorninglinePlot = LinePlot(identifier: "WTMorning")
        let WTAfternoonlinePlot = LinePlot(identifier: "WTAfternoon")
        
        WTMorninglinePlot.shouldFill = true
        WTMorninglinePlot.fillColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1).withAlphaComponent(0.5)
        WTMorninglinePlot.fillType = ScrollableGraphViewFillType.solid
        WTMorninglinePlot.lineColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        WTMorninglinePlot.lineWidth = 3
        WTMorninglinePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        WTAfternoonlinePlot.shouldFill = true
        WTAfternoonlinePlot.fillColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        WTAfternoonlinePlot.fillType = ScrollableGraphViewFillType.solid
        WTAfternoonlinePlot.lineColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        WTAfternoonlinePlot.lineWidth = 3
        WTAfternoonlinePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        
        let WeightReferenceLines = ReferenceLines()
        WeightReferenceLines.absolutePositions = [0, 25, 50, 75, 100, 125, 150, 175, 200, 225, 250, 275, 300]
        weightGraph.addPlot(plot: WTAfternoonlinePlot)
        weightGraph.addPlot(plot: WTMorninglinePlot)
        weightGraph.backgroundFillColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        weightGraph.shouldAdaptRange = true
        weightGraph.addReferenceLines(referenceLines: WeightReferenceLines)
        weightGraph.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        // Return the data for each plot.
        switch(plot.identifier) {
        case "BFMorning":
            return bodyfatLinePlotDataFromMorning[pointIndex]
        case "BFAfternoon":
            return bodyfatLinePlotDataFromAfternoon[pointIndex]
        case "WTMorning":
            return weightLinePlotDataFromMorning[pointIndex]
        case "WTAfternoon":
            return weightLinePlotDataFromAfternoon[pointIndex]
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return datesRecorded[pointIndex]
    }
    
    func numberOfPoints() -> Int {
        return datesRecorded.count
    }
    
    func retrieveDataPoints(context: NSManagedObjectContext) -> [MeasurementEntry] {
        
        let request: NSFetchRequest<MeasurementEntry> = MeasurementEntry.fetchRequest()
        
        let result = try? context.fetch(request)
        
        return result!
        
    }
    
    func parseDataToArrays(entries: [MeasurementEntry]) {
        
        for entry in entries {
            self.bodyfatLinePlotDataFromMorning.append(entry.bodyFatMorning)
            self.bodyfatLinePlotDataFromAfternoon.append(entry.bodyFatAfternoon)
            self.weightLinePlotDataFromMorning.append(entry.weightMorning)
            self.weightLinePlotDataFromAfternoon.append(entry.weightAfternoon)
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
