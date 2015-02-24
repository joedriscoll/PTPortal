//
//  PatientViewVC.swift
//  PTPortal
//
//  Created by Joseph Driscoll on 1/9/15.
//  Copyright (c) 2015 Joseph Driscoll. All rights reserved.
//

import UIKit

class PatientViewVC: UIViewController {
    
    var previous = 0
    var actGet:GetReq?
    var act_g:ActivityGraph?
    var actProc:ActProc?
    var c = Connect()
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var chart: UIView!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBAction func goToPatientView(segue: UIStoryboardSegue) {
        previous = 1
        println("Called gotoPatientView: unwind action")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actGet = GetReq(post: "?session_key=None&patient_username=None", url: c.ip+"/ptapi/getActivity")
        self.act_g = ActivityGraph()
        self.actProc = ActProc(lab: dayLabel,cha:chart, graph:self.act_g!)
        

    
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if (previous == 0){
            var session_key = NSUserDefaults.standardUserDefaults().valueForKey("SESSION_KEY") as NSString
            var patient_username = NSUserDefaults.standardUserDefaults().valueForKey("CURRENT_PATIENT") as NSString
            patientNameLabel.text = patient_username + "'s Statistics"
            var format = NSDateFormatter()
            format.dateFormat = "yyyy-MM-dd"
            self.actGet?.update("?session_key=\(session_key)&patient_username=\(patient_username)&date=\(format.stringFromDate(NSDate()))", url: c.ip+"/ptapi/getActivity")
            self.actGet?.Get(self.actProc!)
            
            //var data = self.actProc.getData()
            //self.act_g = ActivityGraph(graphDataReq: data, chart:chart, dayLabel:dayLabel)
        }
        // Do any additional setup after loading the view.
    }
    
    class ActivityGraph{
        var graph_data:[NSDictionary]
        var view_index:Int
        var lineChart: LineChart?
        var current_dic: NSDictionary
        var dayLabelString:NSString
        var nextViewAlert:UIAlertView = UIAlertView()
        var prevViewAlert:UIAlertView = UIAlertView()
        
        
        deinit{
            
            println("destryoing activity graph")
        }
        init()
        {
            
            self.graph_data = []
            self.view_index = 0
            self.current_dic = Dictionary<String, String>()
            self.dayLabelString = ""
        }
        
        func create(graphDataReq:[NSDictionary], chart:UIView, dayLabel:UILabel, pain:PainAlert){
            dispatch_async(dispatch_get_main_queue()) {
                self.lineChart = LineChart()
                self.lineChart?.transferViews(pain, background: chart)
                self.graph_data = graphDataReq
                self.view_index = graphDataReq.count - 1
                self.current_dic = self.graph_data[self.view_index]
                var ll = self.current_dic.valueForKey("data")!.valueForKey("data")! as Array<Array<CGFloat>>
                self.lineChart?.addLine(self.current_dic.valueForKey("data")?.valueForKey("activity") as [CGFloat],pain:self.current_dic.valueForKey("data")?.valueForKey("pain") as [CGFloat], extradata: self.current_dic.valueForKey("data")!.valueForKey("data") as Array<Array<CGFloat>>)
                self.lineChart?.axisInset = 20
                self.lineChart?.labelsXVisible = true
                self.lineChart?.gridVisible = false
                self.lineChart?.dotsVisible = true
                self.lineChart?.numberOfGridLinesX = 5
                self.lineChart?.labelsYVisible = true
                self.lineChart?.numberOfGridLinesY = 5
                self.lineChart?.frame = CGRect(x: chart.frame.width * 0.035, y: chart.frame.height * 0.15, width: chart.frame.width * 0.95, height: chart.frame.height * 0.4)
            
                chart.addSubview(self.lineChart!)
                dayLabel.text = self.current_dic.valueForKey("name") as NSString
                self.dayLabelString = dayLabel.text!

                self.nextViewAlert.title = "No Data Available After " + self.dayLabelString
                self.nextViewAlert.message = "You have reached the most current data available."
                self.nextViewAlert.addButtonWithTitle("OK")
                self.prevViewAlert.title = "No Data Available Before " + self.dayLabelString
                self.prevViewAlert.message = "You have reached the oldest data available."
                self.prevViewAlert.addButtonWithTitle("OK")
            }
        }
    
        func Next(dayLabel:UILabel){
            if(self.view_index == (self.graph_data.count - 1)){
                self.nextViewAlert.show()
            }
            else{
                self.lineChart?.clear()
                self.view_index = self.view_index + 1
                self.current_dic = self.graph_data[self.view_index]
                self.lineChart?.addLine(self.current_dic.valueForKey("data")?.valueForKey("activity") as [CGFloat],pain:self.current_dic.valueForKey("data")?.valueForKey("pain") as [CGFloat], extradata: self.current_dic.valueForKey("data")?.valueForKey("data") as Array<Array<CGFloat>>)
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
                self.lineChart?.clear()
                self.view_index = self.view_index - 1
                self.current_dic = self.graph_data[self.view_index]
                self.lineChart?.addLine(self.current_dic.valueForKey("data")?.valueForKey("activity") as [CGFloat],pain:self.current_dic.valueForKey("data")?.valueForKey("pain") as [CGFloat], extradata: self.current_dic.valueForKey("data")?.valueForKey("data") as Array<Array<CGFloat>>)
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
    
    class ActProc:Processor{
        weak var dayLabel: UILabel?
        weak var chart: UIView?
        weak var graph:ActivityGraph?
        var data:NSDictionary?
        var pain:PainAlert?
        
        
        deinit{
            
            println("destryoing actproc")
        }
        init(lab:UILabel, cha:UIView, graph:ActivityGraph){
            self.chart = cha
            self.dayLabel = lab
            self.graph = graph
            self.pain = PainAlert()
         
            self.pain?.setup([0,0,0,0,0,0,0], frame: CGRectMake(cha.frame.width * 0.025, 100.0, cha.frame.width * 0.95, 200.0))
            
        }
        override func processData(data: NSDictionary) {
            super.processData(data)
            self.data = data
            var graphing:[NSDictionary] = self.data?.valueForKey("graphs") as [NSDictionary]
            self.graph?.create(graphing, chart:self.chart!, dayLabel:self.dayLabel!, pain:self.pain!)
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
