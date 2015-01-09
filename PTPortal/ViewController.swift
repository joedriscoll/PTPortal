//
//  ViewController.swift
//  PTPortal
//
//  Created by Joseph Driscoll on 1/5/15.
//  Copyright (c) 2015 Joseph Driscoll. All rights reserved.
//
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var items: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if (isLoggedIn == 1) {
        getPatients()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        prefs.setObject(items[indexPath.item], forKey: "CURRENT_PATIENT")
        self.performSegueWithIdentifier("goto_patient_view", sender:self)
        // direct to patient page
    }
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("goto_login", sender: self)
        } else{
            
            self.usernameLabel.text = prefs.valueForKey("USERNAME") as NSString + "'s PT Portal"
            getPatients()
            self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
    }
    
    
    func getPatients(){
        items = []
        let session_key:NSString = prefs.valueForKey("SESSION_KEY") as NSString
        let username:NSString = prefs.valueForKey("USERNAME") as NSString
        var get:NSString = "?session_key=\(session_key)"
        
        var url:NSURL = NSURL(string: "http://localhost:8000/ptapi/getPatients"+get)!
        
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        println(request)
        request.HTTPMethod = "GET"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        var reponseError: NSError?
        var response: NSURLResponse?
        
        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
        
        if ( urlData != nil ) {
            let res = response as NSHTTPURLResponse!;
            
            NSLog("Response code: %ld", res.statusCode);
            
            if (res.statusCode >= 200 && res.statusCode < 300)
            {
                var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                
                NSLog("Response ==> %@", responseData);
                
                var error: NSError?
                
                let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as NSDictionary
                
                
                let patient_list:[NSString] = jsonData.valueForKey("patient_list") as [NSString]
                for(name) in patient_list{
                    items.append(name)
                    
                }
                
                
                
                //[jsonData[@"success"] integerValue];
                
            }
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