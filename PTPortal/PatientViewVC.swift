//
//  PatientViewVC.swift
//  PTPortal
//
//  Created by Joseph Driscoll on 1/9/15.
//  Copyright (c) 2015 Joseph Driscoll. All rights reserved.
//

import UIKit

class PatientViewVC: UIViewController {
    
    
    @IBOutlet var chart: UIView!
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var patientNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    deinit{
        println("deinitiated")
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
       // patientNameLabel.text = prefs.valueForKey("CURRENT_PATIENT") as NSString + "'s Statistics"
        var lineChart = LineChart()
        lineChart.addLine([3, 4, 9, 11, 13, 15,7,8,2,10,0,24,6],pain:[3, 4, 9, 11, 13, 15,7,8,2,10,0,24,6])
        lineChart.axisInset = 20
        lineChart.labelsXVisible = true
        lineChart.gridVisible = false
        lineChart.dotsVisible = true
        lineChart.numberOfGridLinesX = 5
        lineChart.labelsYVisible = true
        lineChart.numberOfGridLinesY = 5
        lineChart.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        chart.addSubview(lineChart)
        
        
        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
