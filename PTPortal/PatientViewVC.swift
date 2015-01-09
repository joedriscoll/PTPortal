//
//  PatientViewVC.swift
//  PTPortal
//
//  Created by Joseph Driscoll on 1/9/15.
//  Copyright (c) 2015 Joseph Driscoll. All rights reserved.
//

import UIKit

class PatientViewVC: UIViewController {
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var patientNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        patientNameLabel.text = prefs.valueForKey("CURRENT_PATIENT") as NSString + "'s Statistics"
        
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
