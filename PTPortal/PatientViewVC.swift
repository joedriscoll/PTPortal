//
//  PatientViewVC.swift
//  PTPortal
//
//  Created by Joseph Driscoll on 1/9/15.
//  Copyright (c) 2015 Joseph Driscoll. All rights reserved.
//

import UIKit

class PatientViewVC: UIViewController {
    
    
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var chart: UIView!
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBAction func goToPatientView(segue: UIStoryboardSegue) {
        println("Called gotoPatientView: unwind action")
    }
    
    var act_req:ActivityRequest?
    var act_g:ActivityGraph?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        // Do any additional setup after loading the view.
    }
    deinit{
        println("deinitiated")
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        patientNameLabel.text = prefs.valueForKey("CURRENT_PATIENT") as NSString + "'s Statistics"
        self.act_req = ActivityRequest()
        self.act_req!.update()
        var data = self.act_req!.getData()
        self.act_g = ActivityGraph(graphDataReq: data, chart:chart, dayLabel:dayLabel)

        
        
        
        // Do any additional setup after loading the view.
    }
    
    class ActivityGraph{
        var graph_data:[NSDictionary]
        var view_index:Int
        var lineChart = LineChart()
        var current_dic: NSDictionary
        var dayLabelString:NSString
        var nextViewAlert:UIAlertView = UIAlertView()
        var prevViewAlert:UIAlertView = UIAlertView()
        
        
        
        init(graphDataReq:[NSDictionary], chart:UIView, dayLabel:UILabel){
            self.lineChart = LineChart()
            self.graph_data = graphDataReq
            self.view_index = graphDataReq.count - 1
            self.current_dic = self.graph_data[self.view_index]
            self.lineChart.addLine(self.current_dic.valueForKey("data")?.valueForKey("activity") as [CGFloat],pain:self.current_dic.valueForKey("data")?.valueForKey("pain") as [CGFloat])
            lineChart.axisInset = 20
            lineChart.labelsXVisible = true
            lineChart.gridVisible = false
            lineChart.dotsVisible = true
            lineChart.numberOfGridLinesX = 5
            lineChart.labelsYVisible = true
            lineChart.numberOfGridLinesY = 5
            lineChart.frame = CGRect(x: 20, y: 60, width: 300, height: 200)
            chart.addSubview(lineChart)
            dayLabel.text = self.current_dic.valueForKey("name") as NSString
            self.dayLabelString = dayLabel.text!
            self.nextViewAlert.title = "No Data Available After " + self.dayLabelString
            self.nextViewAlert.message = "You have reached the most current data available."
            self.nextViewAlert.addButtonWithTitle("OK")
            self.prevViewAlert.title = "No Data Available Before " + self.dayLabelString
            self.prevViewAlert.message = "You have reached the oldest data available."
            self.prevViewAlert.addButtonWithTitle("OK")


            
        }
    
        func Next(dayLabel:UILabel){
            if(self.view_index == (self.graph_data.count - 1)){
                self.nextViewAlert.show()
            }
            else{
                self.lineChart.clear()
                self.view_index = self.view_index + 1
                self.current_dic = self.graph_data[self.view_index]
                self.lineChart.addLine(self.current_dic.valueForKey("data")?.valueForKey("activity") as [CGFloat],pain:self.current_dic.valueForKey("data")?.valueForKey("pain") as [CGFloat])
                dayLabel.text = self.current_dic.valueForKey("name") as NSString
                self.dayLabelString = dayLabel.text!
                self.nextViewAlert.title = "No Data Available After " + self.dayLabelString
            }
        }
        
        func Prev(dayLabel:UILabel){
            if(self.view_index == 0){
                self.prevViewAlert.show()
            }
            else{
                self.lineChart.clear()
                self.view_index = self.view_index - 1
                self.current_dic = self.graph_data[self.view_index]
                self.lineChart.addLine(self.current_dic.valueForKey("data")?.valueForKey("activity") as [CGFloat],pain:self.current_dic.valueForKey("data")?.valueForKey("pain") as [CGFloat])
                dayLabel.text = self.current_dic.valueForKey("name") as NSString
                self.dayLabelString = dayLabel.text!
                self.prevViewAlert.title = "No Data Available Before " + self.dayLabelString
            }
        }

        
        
        
    }

    @IBAction func nextTapped(sender: UIButton) {
        self.act_g!.Next(dayLabel)
    }
    
    @IBAction func previousTapped(sender: UIButton) {
        self.act_g!.Prev(dayLabel)
    }
    
    class ActivityRequest{
        
        var session_key = NSUserDefaults.standardUserDefaults().valueForKey("SESSION_KEY") as NSString
        var patient_username = NSUserDefaults.standardUserDefaults().valueForKey("CURRENT_PATIENT") as NSString
        var get:NSString
        var url:NSURL
        var request:NSMutableURLRequest
        var reponseError: NSError?
        var response: NSURLResponse?
        var urlData: NSData?
        weak var responseData:NSString?
        var error: NSError?
        var jsonData:NSDictionary?
        
        
        init(){
            println("initialized request")
            self.get = "?session_key=\(self.session_key)"
            self.url = NSURL(string: "http://localhost:8000/ptapi/getPatients"+get)!
            self.request = NSMutableURLRequest(URL: self.url)
            self.request.HTTPMethod = "GET"
            self.request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            self.request.setValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        func update(){
            self.session_key = NSUserDefaults.standardUserDefaults().valueForKey("SESSION_KEY") as NSString
            self.patient_username = NSUserDefaults.standardUserDefaults().valueForKey("CURRENT_PATIENT") as NSString
            
            self.get = "?session_key=\(self.session_key)&patient_username=\(self.patient_username)"
            self.url = NSURL(string: "http://localhost:8000/ptapi/getActivity"+get)!
            self.request = NSMutableURLRequest(URL: self.url)
            self.request.HTTPMethod = "GET"
            self.request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            self.request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            
        }
        func getData() -> [NSDictionary] {
            NSURLCache.sharedURLCache().removeAllCachedResponses()
            self.urlData = NSURLConnection.sendSynchronousRequest(self.request, returningResponse:&self.response, error:&self.reponseError)
            self.responseData = NSString(data:self.urlData!, encoding:NSUTF8StringEncoding)!
            self.jsonData = NSJSONSerialization.JSONObjectWithData(self.urlData!, options:NSJSONReadingOptions.MutableContainers , error: &self.error) as? NSDictionary
            println(self.jsonData)
            var graphs:[NSDictionary] = self.jsonData?.valueForKey("graphs") as [NSDictionary]
            
            return graphs
            
            // self.tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
        
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
