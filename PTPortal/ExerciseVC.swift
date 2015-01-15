//
//  ExerciseVC.swift
//  PTPortal
//
//  Created by Joseph Driscoll on 1/12/15.
//  Copyright (c) 2015 Joseph Driscoll. All rights reserved.
//

import UIKit

class ExerciseVC: UIViewController {
    @IBOutlet var backgroundView: UIView!
    var editView: ExerciseAlert?
    @IBOutlet var editViewButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editView = ExerciseAlert()
        self.editView?.setUp(CGRect(x: 20, y: 60, width: 300, height: 200))
                // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        @IBAction func editViewExerciseTapped(sender: UIButton) {
        
        if (editViewButton.currentTitle == "Edit Assigned Exercices"){
            editViewButton.setTitle("View Completed Exercices", forState: UIControlState.Normal)
            
        }
        else{
            editViewButton.setTitle("Edit Assigned Exercices", forState: UIControlState.Normal)
            backgroundView.addSubview(editView!)
            if(self.editView?.getBoxes()[0].selected == false){
                println("its false")
            }
        }
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
