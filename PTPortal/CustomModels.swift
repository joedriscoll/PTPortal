//
//  TextField.swift
//  PTPortal
//
//  Created by Joseph Driscoll on 1/14/15.
//  Copyright (c) 2015 Joseph Driscoll. All rights reserved.
//
/// checkboxes https://gottliebplanet.wordpress.com/2014/08/09/create-a-checkbox-control-in-swift/

import UIKit
import Foundation
var customColor = CustomColors()

class Connect {
    let ip:NSString = "http://52.10.125.75"
    //let ip:NSString = "http://localhost:8000"
}
var c = Connect()

class blueButton:UIButton{

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = customColor.firstBlue
        self.layer.cornerRadius = 5
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    
}


class redButton:UIButton{
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = customColor.red
        self.layer.cornerRadius = 5
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    
}
class TextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    
    func setUp(pHolder:NSString,frame:CGRect){
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 5
        self.placeholder = pHolder as String
        self.frame = frame

    }

    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    private func newBounds(bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += padding.left
        newBounds.origin.y += padding.top
        newBounds.size.height -= (padding.top * 2) - padding.bottom
        newBounds.size.width -= (padding.left * 2) - padding.right
        return newBounds
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}


class Button: UIButton {
    
    func setUp(title:NSString,frame:CGRect){
        //self.backgroundColor = UIColor.lightGrayColor()
        self.setTitle(title as String, forState: UIControlState.Normal)
        self.frame = frame
        self.layer.cornerRadius = 5
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}

class ExerciseAlertLabel: UILabel {
    
    func setUp(text:String,frame:CGRect){
        self.font = UIFont.systemFontOfSize(15)
        self.text = text
        self.frame = frame
        self.textColor = UIColor.lightGrayColor()
        
        
    }
    
}

class PainAlert: UIView {
    let painDescription = ["Throb", "Burn", "Sharp", "Ache"]
    var painAttributes: ExerciseAlertLabel?
    var painLevel: ExerciseAlertLabel?
    var attributeText: ExerciseAlertLabel?
    var levelText: ExerciseAlertLabel?
    var painTitle: ExerciseAlertLabel?
    var done: Button?
    
    func setup(data:Array<CGFloat>, frame:CGRect){
        var tmpString = ""
        for var index = 0; index < 4; ++index {
            if data[index] as CGFloat > 0.5{
                tmpString = tmpString + " " + painDescription[index]
            }
        }
        //tmpString.substringFromIndex(advance(tmpString.startIndex,1))
        self.painTitle = ExerciseAlertLabel()
        self.painTitle?.setUp("Pain Recorded", frame: CGRectMake(80, 10, 250, 30))
        self.painTitle!.textColor = UIColor.blackColor()
        self.painTitle!.font = UIFont.systemFontOfSize(20)
        self.attributeText = ExerciseAlertLabel()
        self.attributeText!.setUp("Pain Attributes:", frame: CGRectMake(20, 45, 250, 30))
        self.painAttributes = ExerciseAlertLabel()
        self.painAttributes?.setUp(tmpString, frame: CGRectMake(20, 60, 250, 30))
        self.attributeText?.textColor = UIColor.blackColor()
        self.levelText = ExerciseAlertLabel()
        self.levelText!.setUp("Pain Level", frame:CGRectMake(20, 85, 250, 30))
        self.painLevel = ExerciseAlertLabel()
        self.painLevel?.setUp(data[4].description, frame: CGRectMake(20, 100, 250, 30))
        self.levelText?.textColor = UIColor.blackColor()
        self.done = Button()
        self.done?.setUp("Ok", frame: CGRectMake(100, 140, 100, 30))
        self.done?.backgroundColor = customColor.red
        self.done?.addTarget(self, action:"Done:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(self.painTitle!)
        self.addSubview(self.attributeText!)
        self.addSubview(self.painAttributes!)
        self.addSubview(self.levelText!)
        self.addSubview(self.painLevel!)
        self.addSubview(self.done!)
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 10
        self.frame = frame
    }
    
    
    func update(data:Array<CGFloat>, frame:CGRect){
        var tmpString = ""
        for var index = 0; index < 4; ++index {
            if data[index] as CGFloat > 0.5{
                tmpString = tmpString + painDescription[index] + " "
            }
        }
        tmpString.substringFromIndex(advance(tmpString.startIndex,1))
        self.painAttributes?.text = tmpString
        self.painAttributes?.textColor = UIColor.darkGrayColor()
        self.painLevel?.text = (data[4] * 10).description
        var num = data[4]*10
        println(num)
        if (num == 0){
            self.painLevel?.text =  "No Pain"
            
        }
        if (0 < num && num < 3.0){
            self.painLevel?.text =  "\(num): Can be Ignored"
            self.painLevel?.textColor = customColor.green
        }
        if (3.0 <= num && num < 5.0){
            self.painLevel?.text =  " \(num): Interferes with Tasks"
            self.painLevel?.textColor = customColor.firstBlue

            
        }
        if (5.0 <= num && num < 7.0){
            self.painLevel?.text =  "\(num): Interferes with Concentration"
            self.painLevel?.textColor = customColor.purple

            
        }
        if (7.0 <= num && num < 9.5){
            self.painLevel?.text =  "\(num): Interferes with Basic Needs"
            self.painLevel?.textColor = customColor.orange

        }
        if (9.5 <= num && num < 11){
            self.painLevel?.text =  "\(num): Bed Rest Required"
            self.painLevel?.textColor = customColor.red

        }
    }
    
    func Done(sender:Button!){
        println("Sefes")
        self.removeFromSuperview()
        
    }

}

class ExerciseAlert: UIView, CheckBoxDelegate {
    
    var exerciseName:TextField?
    var nameLabel:ExerciseAlertLabel?
    var day:ExerciseAlertLabel?
    var sets:ExerciseAlertLabel?
    var exerciseAs:TextField?
    var exerciseDone:Button?
    var exerciseDelete:Button?
    let mCheckboxTitles = ["Mon", "Tue","Wed", "Thr", "Fri","Sat", "Sun"];
    var line = LineChart()
    var boxes:[CheckBox]?
    var e_id:Int?
    var e_post:PostReq?
    weak var e_proc:ExerciseProc?
    var url:TextField?
    var urlLabel:ExerciseAlertLabel?
    
    func getBoxes()->[CheckBox]{
        
        return self.boxes!
    }
    
    func addPost(ePP:ExerciseProc){
        var session_key = NSUserDefaults.standardUserDefaults().valueForKey("SESSION_KEY") as! NSString
        self.e_post = PostReq(post:"session_key=\(session_key)&e_id=\(self.e_id)&name=\(self.exerciseName!.text)&sets=\(self.exerciseAs!.text)&assinged_days=\(self.getStates())&url=\(self.url!.text)", url: (c.ip as String)+"/ptapi/editExerciseData")
        self.e_proc = ePP
        
    }
    func setUp(frame:CGRect){
        self.nameLabel = ExerciseAlertLabel()
        self.nameLabel?.setUp("Exercise Name:",frame:CGRectMake(20, 5, 250, 30))
        self.sets = ExerciseAlertLabel()
        self.sets?.setUp("Sets and Reps:", frame: CGRectMake(20, 115, 250, 30))
        self.day = ExerciseAlertLabel()
        self.day?.setUp("Days Assigned:", frame: CGRectMake(20, 65, 250, 30))
        self.addSubview(day!)
        self.addSubview(nameLabel!)
        self.addSubview(sets!)
        self.exerciseName = TextField()
        self.exerciseName?.setUp("Name",frame:CGRectMake(20, 30, 250, 30))
        self.exerciseAs = TextField()
        self.exerciseAs?.setUp("Sets and reps",frame:CGRectMake(20, 140, 250, 30))
        self.exerciseDone = Button()
        self.exerciseDone?.backgroundColor = customColor.firstBlue
        self.exerciseDone?.setUp("Update",frame: CGRectMake(190, 255, 80, 30))
        self.exerciseDone?.addTarget(self, action:"Done:", forControlEvents: UIControlEvents.TouchUpInside)
        self.exerciseDelete = Button()
        self.exerciseDelete?.backgroundColor = customColor.red
        self.exerciseDelete?.setUp("Delete",frame: CGRectMake(20, 255, 80, 30))
        self.exerciseDelete?.addTarget(self, action:"Delete:", forControlEvents: UIControlEvents.TouchUpInside)
        self.url = TextField()
        self.url?.setUp("url", frame: CGRectMake(20, 200, 250, 30))
        self.urlLabel = ExerciseAlertLabel()
        self.urlLabel?.setUp("URL of exercise directions", frame: CGRectMake(20, 175, 250, 30))
        self.addSubview(self.url!)
        self.addSubview(self.urlLabel!)
        self.addSubview(exerciseName!)
        self.addSubview(exerciseAs!)
        self.addSubview(exerciseDone!)
        self.addSubview(exerciseDelete!)
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 10
        self.frame = frame
        self.boxes = createCheckboxes()

        
    }

    func Done(sender:Button!){
        var patient_username = NSUserDefaults.standardUserDefaults().valueForKey("CURRENT_PATIENT") as! NSString
        var session_key = NSUserDefaults.standardUserDefaults().valueForKey("SESSION_KEY") as! NSString
        if self.e_id >= 0{
            e_post?.update("session_key=\(session_key)&e_id=\(self.e_id!)&name=\(self.exerciseName!.text)&patient_username=\(patient_username)&sets=\(self.exerciseAs!.text)&assigned_days=\(self.getStates())&url=\(self.url!.text)", url: (c.ip as String)+"/ptapi/editExerciseData")
        }
        else{
            e_post?.update("session_key=\(session_key)&patient_username=\(patient_username)&name=\(self.exerciseName!.text)&sets=\(self.exerciseAs!.text)&assigned_days=\(self.getStates())&url=\(self.url!.text)", url: (c.ip as String)+"/ptapi/addNewExercise")
        }
        e_post?.Post(self.e_proc!)
        self.removeFromSuperview()
        
    }
    
    func clear(){
        self.setStates([0,0,0,0,0,0,0])
        self.exerciseName?.text = ""
        self.exerciseAs?.text = ""
        self.e_id = -1
        self.url?.text = ""
        
    }
    
    func Delete(sender:Button!){
        var patient_username = NSUserDefaults.standardUserDefaults().valueForKey("CURRENT_PATIENT") as! NSString
        var session_key = NSUserDefaults.standardUserDefaults().valueForKey("SESSION_KEY") as! NSString
        if self.e_id >= 0{
            e_post?.update("session_key=\(session_key)&e_id=\(self.e_id!)&name=\(self.exerciseName!.text)&patient_username=\(patient_username)&sets=\(self.exerciseAs!.text)&assigned_days=\(self.getStates())&url=\(self.url!.text)", url: (c.ip as String)+"/ptapi/deleteExerciseData")
        e_post?.Post(self.e_proc!)

        }

        self.removeFromSuperview()

    }
    
    func createCheckboxes() -> [CheckBox] {
        var boxes:[CheckBox] = []
        let lNumberOfCheckboxes = 7;
        let lCheckboxHeight: CGFloat = 20.0;
        // #2
        var lFrame = CGRectMake(20, 90, 30, lCheckboxHeight);
        
        for (var counter = 0; counter < lNumberOfCheckboxes; counter++) {
            var lCheckbox = CheckBox(frame: lFrame, title: mCheckboxTitles[counter], selected: false);
            lCheckbox.mDelegate = self;
            lCheckbox.tag = counter;
            boxes.append(lCheckbox)
            self.addSubview(lCheckbox);
            lFrame.origin.x += lFrame.size.width + 5;
            if((counter + 1) % 10 == 0)
            {
                lFrame.origin.x = 20
                lFrame.origin.y += lFrame.size.height + 10
            }
        }
        return boxes
    }
    
    
    // #5
    func didSelectCheckbox(state: Bool, identifier: Int, title: String) {
        println("checkbox '\(title)' has state \(state)");
    }
    
    func getStates() -> [Int]{
        var states:[Int] = []
        for var i=0; i<self.boxes?.count; i=i+1{
            if self.boxes?[i].selected == true{
                states.append(1)
            }
            else{
                states.append(0)
            }
        }
        return states
    }
    
    func setStates(sel:[Int]){
        for var i=0; i<self.boxes?.count; i=i+1{
            if sel[i] == 1{
                self.boxes?[i].selected = true
            }
            else{
                self.boxes?[i].selected = false
            }
        }
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}

@objc protocol CheckBoxDelegate {
    // #1
    func didSelectCheckbox(state: Bool, identifier: Int, title: String);
}

class CheckBox: UIButton {
    weak var mDelegate: CheckBoxDelegate?;
    // #1
    
    deinit{
        println("destroyed checkbox")
    }
    // #2
    init(frame: CGRect, title: String, selected: Bool) {
        super.init(frame: frame);
        self.adjustEdgeInsets();
        self.applyStyle();
        self.setTitle(title, forState: UIControlState.Normal);
        self.addTarget(self, action: "onTouchUpInside:", forControlEvents: UIControlEvents.TouchUpInside);
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func adjustEdgeInsets() {
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center;
    }
    
    // #6
    func applyStyle() {
        self.titleLabel?.font = UIFont.systemFontOfSize(14)
        self.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal);
        self.setTitleColor(customColor.firstBlue, forState: UIControlState.Selected);
    }
    
    func onTouchUpInside(sender: UIButton) {
        // #7
        self.selected = !self.selected;
        // #8
        var titleString = self.titleLabel?.text
        mDelegate?.didSelectCheckbox(self.selected, identifier: self.tag, title: titleString!);
    }
}



class PostReq{
    var url:NSURL
    var request:NSMutableURLRequest
    var jsonData:NSDictionary?
    var queue:NSOperationQueue?
    var postData:NSData?
    var postLength:NSString?
    
    deinit{
        println("deleted requestttt")
    }
    
    init(post:NSString, url:String){
        self.url = NSURL(string: url)!
        self.request = NSMutableURLRequest(URL: self.url)
        self.request.HTTPMethod = "POST"
        self.request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        self.request.setValue("application/json", forHTTPHeaderField: "Accept")
        self.queue  = NSOperationQueue()
        self.postData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        self.postLength = String( postData!.length )
        
    }
    
    func update(post:NSString, url:String){
        self.postData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        self.postLength = String( self.postData!.length )
        self.url = NSURL(string: url)!
        self.request = NSMutableURLRequest(URL: self.url)
        self.request.HTTPMethod = "POST"
        self.request.HTTPBody = self.postData
        self.request.setValue((self.postLength as! String), forHTTPHeaderField: "Content-Length")
        self.request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        self.request.setValue("application/json", forHTTPHeaderField: "Accept")
    }
    
    func Post(obj:Processor) -> Int {
        println("ihiehsiohfeoieasnfvoiaensoivn")
        var success:Int = 0
        println(self.request.HTTPBody)
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (error != nil) {
                println("API error: \(error), \(error.userInfo)")
            }
            else{
                var jsonError:NSError?
                println(self.url)
                println(response)
                println("hihihi")
                println("hhhhhh")
                println("aaaaa")
                self.jsonData = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as? NSDictionary
                println(error)
                println(self.jsonData!)
                obj.processData(self.jsonData!)
                if (jsonError != nil) {
                    println("Error parsing json: \(jsonError)")
                    success = 0
                }
                if (self.jsonData?.valueForKey("success") as! Int == 1){
                    success = 1
                }
                else{
                    success = 0
                }
            }
        })
        return success
    }
}

class Processor {
    func processData(data:NSDictionary){
        println(data)
    }
}

class asProcessor:Processor{
    deinit{
        println("process deleted")
    }
    override func processData(data: NSDictionary) {
        super.processData(data)
        var success:NSInteger = data.valueForKey("success") as! NSInteger
        if(success == 1)
        {
            NSLog("Sign Up SUCCESS");
        } else {
            var error_msg:NSString
            if data["error_message"] as? NSString != nil {
                error_msg = data["error_message"] as! NSString
            } else {
                error_msg = "PT Username Not Found"
            }
        }
    }
}


class GetReq{
    var url:NSURL
    var request:NSMutableURLRequest
    var jsonData:NSDictionary?
    var queue:NSOperationQueue?
    var postData:NSData?
    var postLength:NSString?
    
    deinit{
        println("deleted Getrequestttt")
    }
    
    init(post:NSString, url:String){
        self.url = NSURL(string: url+(post as String))!
        self.request = NSMutableURLRequest(URL: self.url)
        self.request.HTTPMethod = "GET"
        self.request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        self.request.setValue("application/json", forHTTPHeaderField: "Accept")
        self.queue  = NSOperationQueue()
        
    }
    
    func update(post:NSString, url:String){
        self.url = NSURL(string: url+(post as String))!
        self.request = NSMutableURLRequest(URL: self.url)
        self.request.HTTPMethod = "GET"
        self.request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        self.request.setValue("application/json", forHTTPHeaderField: "Accept")
    }
    
    func Get(obj:Processor) -> Int {
        var success:Int = 0
        println(self.request.HTTPBody)
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (error != nil) {
                println("API error: \(error), \(error.userInfo)")
            }
            else{

                var jsonError:NSError?
                println(data!)
                self.jsonData = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as? NSDictionary
                println(self.url)
                obj.processData(self.jsonData!)
                if (jsonError != nil) {
                    println("Error parsing json: \(jsonError)")
                    success = 0
                }
                if (self.jsonData?.valueForKey("success") as! Int == 1){
                    success = 1
                }
                else{
                    success = 0
                }
            }
        })
        return success
    }
}

class ExerciseProc: Processor{
    var table_items:[String]
    weak var table:UITableView?
    var all_exercises:[String]
    var current_exercises:[String]
    var all_exercises_dic:[NSDictionary]
    var current_exercises_dic:[NSDictionary]
    var table_dic:[NSDictionary]
    var lis:Int?
    
    init(t:UITableView){
        self.table_items = []
        self.table_dic = []
        self.all_exercises = []
        self.current_exercises = []
        self.all_exercises_dic = []
        self.current_exercises_dic = []
        self.table = t
        self.lis = 0
    }
    
    override func processData(data: NSDictionary) {
        super.processData(data)
        self.all_exercises = []
        self.current_exercises = []
        self.all_exercises_dic = data.valueForKey("all_exercises") as! [NSDictionary]
        self.current_exercises_dic = data.valueForKey("current_exercises") as! [NSDictionary]
        for var a = 0;a < self.all_exercises_dic.count; a = a+1{
            self.all_exercises.append(self.all_exercises_dic[a].valueForKey("name") as! String)
        }
        for var a = 0;a < self.current_exercises_dic.count; a = a+1{
            var all_data:String = (self.current_exercises_dic[a].valueForKey("e_date") as! String) + ": " + (self.current_exercises_dic[a].valueForKey("name") as! String)
            self.current_exercises.append(all_data)
        }
        self.all_exercises.append("+ Add Exercise")
        self.all_exercises_dic.append(Dictionary<String,String>())
        dispatch_async(dispatch_get_main_queue()) {
            if self.lis == 0{
                self.table_items = self.current_exercises
                self.table_dic = self.current_exercises_dic
            }
            else{
                self.table_items = self.all_exercises
                self.table_dic = self.all_exercises_dic
                
            }
            self.table?.reloadData()
            return Void()
        }
        return Void()
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
override func drawRect(rect: CGRect) {
// Drawing code
}
*/




