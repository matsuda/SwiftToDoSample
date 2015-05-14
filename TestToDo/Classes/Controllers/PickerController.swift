//
//  PickerController.swift
//  TestToDo
//
//  Created by Kosuke Matsuda on 2015/05/14.
//  Copyright (c) 2015年 Appirits. All rights reserved.
//

import UIKit

@objc protocol PickerControllerDelegate {
    optional func pickerControllerDidSelect(controller: PickerController)
    optional func pickerControllerDidCancel(controller: PickerController)
}

class PickerController: UIViewController {

    @IBOutlet weak var grandView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var toolBar: UIToolbar!

    @IBOutlet weak var pickerViewBottomConstraint: NSLayoutConstraint!

    weak var delegate: PickerControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clearColor()
        self.pickerView.backgroundColor = UIColor.whiteColor()

        self.grandView.backgroundColor = UIColor.blackColor()
        let gesture = UITapGestureRecognizer(target: self, action: "tapGrand:")
        self.grandView.addGestureRecognizer(gesture)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapCancel(sender: AnyObject) {
        self.delegate?.pickerControllerDidCancel?(self)
    }

    @IBAction func tapDone(sender: AnyObject) {
        self.delegate?.pickerControllerDidSelect?(self)
    }

    func tapGrand(gesture: UIGestureRecognizer) {
        self.delegate?.pickerControllerDidCancel?(self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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

        var height = CGRectGetHeight(self.toolBar.frame) + CGRectGetHeight(self.pickerView.frame)

        var endFrame = self.pickerView.frame
        var startFrame = endFrame
        startFrame.origin.y += height
        self.pickerView.frame = startFrame

        var endFrameToolBar = self.toolBar.frame
        var startFrameToolBar = endFrameToolBar
        startFrameToolBar.origin.y += height
        self.toolBar.frame = startFrameToolBar

        UIView.animateWithDuration(0.2, delay: 0, options: (.CurveEaseInOut | .LayoutSubviews), animations: { () -> Void in
            self.grandView.alpha = 0.5
            self.pickerView.frame = endFrame
            self.toolBar.frame = endFrameToolBar
        }) { (finished) -> Void in
            completion?(finished)
        }
    }

    func dismissPickerAnimated(animated: Bool, completion: ((Bool) -> Void)?) {
        if self.view.superview == nil { return }

        self.pickerViewBottomConstraint.constant = -260
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.grandView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (finished) -> Void in
            self.view.removeFromSuperview()
            completion?(finished)
        }
    }
}
