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
    var eProc:ExerciseProc?
    var eReq:GetReq?
    var c = Connect()
    
    @IBOutlet var editViewButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eProc = ExerciseProc(t:self.tableView)
        self.editView = ExerciseAlert()
        self.editView?.setUp(CGRect(x: 40, y: 150, width: 300, height: 250))
        //tableView.layer.cornerRadius = 5
        //tableView.layer.borderWidth = 2
        //tableView.layer.borderColor = UIColor.blackColor().CGColor
        
        self.eReq = GetReq(post: "?session_key=None", url: c.ip+"/ptapi/patientsExerciseData")
                // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)

        var session_key = NSUserDefaults.standardUserDefaults().valueForKey("SESSION_KEY") as NSString
        var username = NSUserDefaults.standardUserDefaults().valueForKey("USERNAME") as NSString
        var patient_name = NSUserDefaults.standardUserDefaults().valueForKey("CURRENT_PATIENT") as NSString
        self.eReq?.update("?session_key=\(session_key)&patient_username=\(patient_name)", url: c.ip+"/ptapi/patientsExerciseData")
        self.eReq?.Get(self.eProc!)
        self.eProc?.table_items = self.eProc!.current_exercises
        self.editView?.addPost(self.eProc!)
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
                self.eProc?.table_items = self.eProc!.all_exercises
                self.eProc?.table_dic = self.eProc!.all_exercises_dic
                self.eProc?.lis = 1
                tableView?.reloadData()
            }
            else{
                editViewButton.setTitle("Edit Assigned Exercices", forState: UIControlState.Normal)
                println("its false")
                self.eProc?.table_items = self.eProc!.current_exercises
                self.eProc?.table_dic = self.eProc!.current_exercises_dic
                 self.eProc?.lis = 0
                tableView?.reloadData()
                            
            }
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.eProc != nil){
            return self.eProc!.table_items.count;
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
        cell!.textLabel?.text = self.eProc!.table_items[indexPath.row]
        ///coloring the texts
        if eProc?.lis == 0{
            if eProc?.current_exercises_dic[indexPath.row].valueForKey("e_completion") as Int == 0{
                cell!.textLabel?.textColor = customColor.red
            }
            if eProc?.current_exercises_dic[indexPath.row].valueForKey("e_completion") as Int == 1{
                cell!.textLabel?.textColor = UIColor.grayColor()
            }
            if eProc?.current_exercises_dic[indexPath.row].valueForKey("e_completion") as Int == 2{
                cell!.textLabel?.textColor = customColor.firstBlue
            }
            
        }
        else{
            cell!.textLabel?.textColor = UIColor.blackColor()
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if editView?.superview != backgroundView{
            if self.eProc?.lis == 1{
                if indexPath.row == eProc!.table_items.count - 1{
                    editView?.clear()
                    backgroundView.addSubview(editView!)
                    
                }
                else{
                backgroundView.addSubview(editView!)
                editView?.exerciseName?.text = self.eProc!.table_items[indexPath.item] // direct to patient page
                editView?.exerciseAs?.text = self.eProc!.all_exercises_dic[indexPath.row].valueForKey("e_sets") as? String
                editView?.setStates(eProc?.all_exercises_dic[indexPath.row].valueForKey("e_assigned_days") as [Int])
                editView?.e_id = eProc?.all_exercises_dic[indexPath.row].valueForKey("e_id") as? Int
                }
            }
        }
    }
    

    
    //"{success:1, all_exercises:[e.name:{e.id, e.sets, e.assigned_days}], completed_exercises:[e.name:{e.id,e.date,e.completion}]}"
}
