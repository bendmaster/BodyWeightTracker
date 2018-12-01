//
//  GraphViewController.swift
//  BodyWeightTracker
//
//  Created by Benjamin Masters on 12/1/18.
//  Copyright © 2018 Benjamin Masters. All rights reserved.
//

import UIKit
import ScrollableGraphView

class GraphViewController: UIViewController, ScrollableGraphViewDataSource {
    

    @IBOutlet weak var graph: ScrollableGraphView!
    let numberOfDataPointsInGraph = 50
    var linePlotData = [Double]()
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...numberOfDataPointsInGraph {
            linePlotData.append(Double(i % 5))
        }
        
        let linePlot = LinePlot(identifier: "line")
        let referenceLines = ReferenceLines()
        graph.addPlot(plot: linePlot)
        graph.addReferenceLines(referenceLines: referenceLines)
        graph.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        // Return the data for each plot.
        switch(plot.identifier) {
        case "line":
            return linePlotData[pointIndex]
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return "FEB \(pointIndex)"
    }
    
    func numberOfPoints() -> Int {
        return numberOfDataPointsInGraph
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
