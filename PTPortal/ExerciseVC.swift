//
//  ExerciseVC.swift
//  PTPortal
//
//  Created by Joseph Driscoll on 1/12/15.
//  Copyright (c) 2015 Joseph Driscoll. All rights reserved.
//

import UIKit

class ExerciseVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var backgroundView: UIView!
    var cell:UITableViewCell?
    var editView: ExerciseAlert?
    var prequest:ExerciseRequest?
    
    @IBOutlet var editViewButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editView = ExerciseAlert()
        self.editView?.setUp(CGRect(x: 40, y: 150, width: 300, height: 250))
        self.prequest = ExerciseRequest(tableView: self.tableView)
                // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func painLogTaped(sender: UIButton){
        if editView?.superview != backgroundView{
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func editViewExerciseTapped(sender: UIButton) {
        if (editView?.superview != backgroundView){
            if (editViewButton.currentTitle == "Edit Assigned Exercices"){
                editViewButton.setTitle("View Completed Exercices", forState: UIControlState.Normal)
                prequest?.table_items = prequest!.all_exercises
                tableView?.reloadData()
            }
            else{
                editViewButton.setTitle("Edit Assigned Exercices", forState: UIControlState.Normal)
                println("its false")
                prequest?.table_items = prequest!.current_exercises
                tableView?.reloadData()
                            
            }
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (prequest != nil){
            return prequest!.table_items.count;
        }
        else{
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        self.cell = self.tableView!.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        if (cell == nil) {
            println("itwasnil")
            self.cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        }
        cell!.textLabel?.text = prequest!.table_items[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if editView?.superview != backgroundView{
            backgroundView.addSubview(editView!)
            editView?.exerciseName?.text = prequest!.table_items[indexPath.item] // direct to patient page
        }
    }
    
    
    class ExerciseRequest{
        
        var session_key = NSUserDefaults.standardUserDefaults().valueForKey("SESSION_KEY") as NSString
        var username = NSUserDefaults.standardUserDefaults().valueForKey("USERNAME") as NSString
        var patient_name = NSUserDefaults.standardUserDefaults().valueForKey("CURRENT_PATIENT") as NSString
        var get:NSString
        var url:NSURL
        var current_exercises:[String]
        var all_exercises: [String]
        var request:NSMutableURLRequest
        var reponseError: NSError?
        var response: NSURLResponse?
        var urlData: NSData?
        weak var responseData:NSString?
        var error: NSError?
        var jsonData:NSDictionary?
        var patient_list:[NSString]
        var table_items:[String]
        weak var tableView:UITableView?
        
        
        init(tableView:UITableView){
            println("initialized request")
            self.get = "?session_key=\(self.session_key)"
            self.url = NSURL(string: "http://localhost:8000/ptapi/getPatientsExerciseData"+get)!
            self.request = NSMutableURLRequest(URL: self.url)
            self.request.HTTPMethod = "GET"
            self.request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            self.request.setValue("application/json", forHTTPHeaderField: "Accept")
            self.all_exercises = ["bye"]
            self.current_exercises = ["hi"]
            self.table_items = []
            self.patient_list = []
            self.tableView = tableView
        }
        
    }

}
