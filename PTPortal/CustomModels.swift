//
//  TextField.swift
//  PTPortal
//
//  Created by Joseph Driscoll on 1/14/15.
//  Copyright (c) 2015 Joseph Driscoll. All rights reserved.
//
/// checkboxes https://gottliebplanet.wordpress.com/2014/08/09/create-a-checkbox-control-in-swift/

import UIKit

class TextField: UITextField {

    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);

    func setUp(pHolder:NSString,frame:CGRect){
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 5
        self.placeholder = pHolder
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
        self.backgroundColor = UIColor.lightGrayColor()
        self.setTitle(title, forState: UIControlState.Normal)
        self.frame = frame
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}

class ExerciseAlert: UIView, CheckBoxDelegate {
    
    var exerciseName:TextField?
    var exerciseAs:TextField?
    var exerciseDone:Button?
    var exerciseCancel:Button?
    let mCheckboxTitles = ["Sun", "Mon", "Tue","Wed", "Thr", "Fri","Sat"];
    var line = LineChart()
    var boxes:[CheckBox]?

    
    func getBoxes()->[CheckBox]{
        
        return self.boxes!
    }
    
    func setUp(frame:CGRect){
        self.exerciseName = TextField()
        self.exerciseName?.setUp("Name",frame:CGRectMake(20, 10, 250, 30))
        self.exerciseAs = TextField()
        self.exerciseAs?.setUp("Sets and reps",frame:CGRectMake(20, 90, 250, 30))
        self.exerciseDone = Button()
        self.exerciseDone?.setUp("Done",frame: CGRectMake(190, 140, 80, 30))
        self.exerciseCancel = Button()
        self.exerciseCancel?.setUp("Cancel",frame: CGRectMake(20, 140, 80, 30))
        self.addSubview(exerciseName!)
        self.addSubview(exerciseAs!)
        self.addSubview(exerciseDone!)
        self.addSubview(exerciseCancel!)
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 10
        self.frame = frame
        self.boxes = createCheckboxes()
    }
    
    func createCheckboxes() -> [CheckBox] {
        var boxes:[CheckBox] = []
        let lNumberOfCheckboxes = 7;
        let lCheckboxHeight: CGFloat = 20.0;
        // #2
        var lFrame = CGRectMake(20, 50, 30, lCheckboxHeight);
        
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
        return states
        
        
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}

import Foundation
@objc protocol CheckBoxDelegate {
    // #1
    func didSelectCheckbox(state: Bool, identifier: Int, title: String);
}

class CheckBox: UIButton {
    weak var mDelegate: CheckBoxDelegate?;
    // #1
    required init(coder: NSCoder) {
        super.init();
    }
    
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
    
    func adjustEdgeInsets() {
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center;
    }
    
    // #6
    func applyStyle() {
        self.titleLabel?.font = UIFont.systemFontOfSize(14)
        self.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        self.setTitleColor(UIColor.redColor(), forState: UIControlState.Selected);
    }
    
    func onTouchUpInside(sender: UIButton) {
        // #7
        self.selected = !self.selected;
        // #8
        var titleString = self.titleLabel?.text
        mDelegate?.didSelectCheckbox(self.selected, identifier: self.tag, title: titleString!);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
override func drawRect(rect: CGRect) {
// Drawing code
}
*/




