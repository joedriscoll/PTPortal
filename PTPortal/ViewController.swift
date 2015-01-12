//
//  ViewController.swift
//  PTPortal
//
//  Created by Joseph Driscoll on 1/5/15.
//  Copyright (c) 2015 Joseph Driscoll. All rights reserved.
//
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var usernameLabel: UILabel!
    @IBAction func goToHome(segue: UIStoryboardSegue) {
        
        println("Called gotoHome: unwind action")
        
    }
    var prequest:PatientRequest?
    var isLoggedIn:Int?
    var cell:UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isLoggedIn = NSUserDefaults.standardUserDefaults().valueForKey("ISLOGGEDIN") as? Int
        //NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "ISLOGGEDIN")
        if (self.isLoggedIn != 0 && self.isLoggedIn != nil) {
            println(self.isLoggedIn)
            println(NSUserDefaults.standardUserDefaults().valueForKey("SESSION_KEY"))
            self.prequest = PatientRequest(tableView: tableView!)
            self.prequest?.update()
            var s:Int = self.prequest!.getPatients()
            if(s == 0){
                self.performSegueWithIdentifier("goto_login", sender: self)
            }
        }
        else{
            self.performSegueWithIdentifier("goto_login", sender: self)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (prequest != nil){
            return prequest!.items.count;
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

        cell!.textLabel?.text = prequest!.items[indexPath.row]
        
        return cell!

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSUserDefaults.standardUserDefaults().setObject(prequest!.items[indexPath.item], forKey: "CURRENT_PATIENT")
        self.performSegueWithIdentifier("goto_patient_view",sender:self)
        // direct to patient page
    }


    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.isLoggedIn =  NSUserDefaults.standardUserDefaults().valueForKey("ISLOGGEDIN") as? Int
        if (self.isLoggedIn == 0 || self.isLoggedIn == nil) {
            self.performSegueWithIdentifier("goto_login", sender: self)
        } else{
            self.prequest?.update()
            var s:Int = self.prequest!.getPatients()
            if(s == 0){
                self.performSegueWithIdentifier("goto_login", sender: self)
            }
        }
    }
    
    class PatientRequest{

        var session_key = NSUserDefaults.standardUserDefaults().valueForKey("SESSION_KEY") as NSString
        var username = NSUserDefaults.standardUserDefaults().valueForKey("USERNAME") as NSString
        var get:NSString
        var url:NSURL
        var items:[String]
        var request:NSMutableURLRequest
        var reponseError: NSError?
        var response: NSURLResponse?
        var urlData: NSData?
        weak var responseData:NSString?
        var error: NSError?
        var jsonData:NSDictionary?
        var patient_list:[NSString]
        weak var tableView:UITableView?
    
        
        init(tableView:UITableView){
            println("initialized request")
            self.get = "?session_key=\(self.session_key)"
            self.url = NSURL(string: "http://localhost:8000/ptapi/getPatients"+get)!
            self.request = NSMutableURLRequest(URL: self.url)
            self.request.HTTPMethod = "GET"
            self.request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            self.request.setValue("application/json", forHTTPHeaderField: "Accept")
            self.items = ["hi"]
            self.patient_list = []
            self.tableView = tableView
        }
        
        func update(){
            self.session_key = NSUserDefaults.standardUserDefaults().valueForKey("SESSION_KEY") as NSString
            self.username = NSUserDefaults.standardUserDefaults().valueForKey("USERNAME") as NSString
            self.get = "?session_key=\(self.session_key)"
            self.url = NSURL(string: "http://localhost:8000/ptapi/getPatients"+get)!
            self.request = NSMutableURLRequest(URL: self.url)
            self.request.HTTPMethod = "GET"
            self.request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            self.request.setValue("application/json", forHTTPHeaderField: "Accept")

            
        }
        func getPatients() -> Int {
            NSURLCache.sharedURLCache().removeAllCachedResponses()
            self.items = []
            self.urlData = NSURLConnection.sendSynchronousRequest(self.request, returningResponse:&self.response, error:&self.reponseError)
            self.responseData = NSString(data:self.urlData!, encoding:NSUTF8StringEncoding)!
            self.jsonData = NSJSONSerialization.JSONObjectWithData(self.urlData!, options:NSJSONReadingOptions.MutableContainers , error: &self.error) as? NSDictionary
            if (self.jsonData?.valueForKey("success") as Int == 0){
                let appDomain = NSBundle.mainBundle().bundleIdentifier
                NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
                return 0
                //logoutTapped(logOutButton)
            }
            self.patient_list = self.jsonData?.valueForKey("patient_list") as [NSString]
            for(name) in self.patient_list{
                self.items.append(name)
                }
            return 1
           // self.tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
            }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logoutTapped(sender: UIButton) {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
    
}