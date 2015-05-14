//
//  DatePickerController.swift
//  TestToDo
//
//  Created by Kosuke Matsuda on 2015/05/14.
//  Copyright (c) 2015年 Appirits. All rights reserved.
//

import UIKit

@objc protocol DatePickerControllerDelegate {
    optional func datePickerControllerDidSelect(controller: DatePickerController)
    optional func datePickerControllerDidCancel(controller: DatePickerController)
}

class DatePickerController: UIViewController {

    @IBOutlet weak var grandView: UIView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBOutlet weak var datePickerViewBottomConstraint: NSLayoutConstraint!

    weak var delegate: DatePickerControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clearColor()

        self.datePicker.backgroundColor = UIColor.whiteColor()
        self.datePicker.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        self.datePicker.locale = NSLocale(localeIdentifier: "ja_JP")
        self.datePicker.timeZone = NSTimeZone(abbreviation: "JST")

        self.grandView.backgroundColor = UIColor.blackColor()
        let gesture = UITapGestureRecognizer(target: self, action: "tapGrand:")
        self.grandView.addGestureRecognizer(gesture)
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

    @IBAction func tapCancel(sender: AnyObject) {
        self.delegate?.datePickerControllerDidCancel?(self)
    }

    @IBAction func tapDone(sender: AnyObject) {
        self.delegate?.datePickerControllerDidSelect?(self)
    }

    func tapGrand(gesture: UIGestureRecognizer) {
        self.delegate?.datePickerControllerDidCancel?(self)
    }

    func presentPicker(animated: Bool, completion: ((Bool) -> Void)?) {
        if self.view.superview != nil { return }

        self.grandView.alpha = 0
        let frame = UIScreen.mainScreen().bounds
        self.view.frame = frame

        let windows = UIApplication.sharedApplication().windows.reverse()
        for window in windows {
            if window.windowLevel == UIWindowLevelNormal {
                window.addSubview(self.view)
                break
            }
        }

        var height = CGRectGetHeight(self.toolBar.frame) + CGRectGetHeight(self.datePicker.frame)

        var endFrame = self.datePicker.frame
        var startFrame = endFrame
        startFrame.origin.y += height
        self.datePicker.frame = startFrame

        var endFrameToolBar = self.toolBar.frame
        var startFrameToolBar = endFrameToolBar
        startFrameToolBar.origin.y += height
        self.toolBar.frame = startFrameToolBar

        UIView.animateWithDuration(0.2, delay: 0, options: (.CurveEaseInOut | .LayoutSubviews), animations: { () -> Void in
            self.grandView.alpha = 0.5
            self.datePicker.frame = endFrame
            self.toolBar.frame = endFrameToolBar
            }) { (finished) -> Void in
                completion?(finished)
        }
    }

    func dismissPickerAnimated(animated: Bool, completion: ((Bool) -> Void)?) {
        if self.view.superview == nil { return }

        self.datePickerViewBottomConstraint.constant = -260
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.grandView.alpha = 0
            self.view.layoutIfNeeded()
            }) { (finished) -> Void in
                self.view.removeFromSuperview()
                completion?(finished)
        }
    }
}
