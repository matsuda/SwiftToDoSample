//
//  UIViewController+Keyboard.swift
//  AsahiAd
//
//  Created by Kosuke Matsuda on 2015/05/12.
//  Copyright (c) 2015年 Appirits. All rights reserved.
//

import UIKit

private struct AssociatedKeys {
    static var scrollViewContentInsetKey = "scrollViewContentInsetKey"
}

extension UIViewController {
    // MARK: computed properties
    var scrollViewForKeyboardNotifications: UIScrollView? {
        get {
            return nil
        }
    }

    var scrollViewContentInset: UIEdgeInsets {
        get {
            if let value = objc_getAssociatedObject(self, &AssociatedKeys.scrollViewContentInsetKey) as? NSValue {
                return value.UIEdgeInsetsValue()
            } else {
                if let scrollView = self.scrollViewForKeyboardNotifications {
                    let value = scrollView.contentInset
                    self.scrollViewContentInset = value
                    return value
                }
            }
            return UIEdgeInsetsZero
        }
        set {
            objc_setAssociatedObject(
                self, &AssociatedKeys.scrollViewContentInsetKey,
                NSValue(UIEdgeInsets: newValue)!, UInt(OBJC_ASSOCIATION_COPY_NONATOMIC)
            )
        }
    }

    // MARK: - observe notifications
    func addObserverForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    func removeObserverForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    func keyboardWillShow(notification: NSNotification) {
        if let scrollView = self.scrollViewForKeyboardNotifications {
            if let userInfo = notification.userInfo {
                let window = UIApplication.sharedApplication().keyWindow
                let keyboardEndFrameInScreen = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
                let keyboardEndFrameInWindow = window?.convertRect(keyboardEndFrameInScreen!, fromWindow: nil)
                let keyboardEndFrameInView = self.view.convertRect(keyboardEndFrameInWindow!, fromView: nil)
                let heightCoveredWithKeyboard = CGRectGetMaxY(scrollView.frame) - CGRectGetMinY(keyboardEndFrameInView)

                var insets = self.scrollViewContentInset
                insets.bottom = heightCoveredWithKeyboard
                self.scrollView(scrollView, setInsets: insets, givenUserInfo: userInfo)

                if scrollView is UITableView {
                    let tableView = scrollView as! UITableView
                    /*
                    let keyboardEndFrameInScrollView = self.view.convertRect(keyboardEndFrameInView, toView: scrollView)
                    if let indexPath = tableView.indexPathForRowAtPoint(keyboardEndFrameInScrollView.origin) {
                        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
                    }
                    */
                    if let indexPath = tableView.indexPathForSelectedRow() {
                        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
                    }
                }
            }
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        if let scrollView = self.scrollViewForKeyboardNotifications {
            let insets = self.scrollViewContentInset
            self.scrollView(scrollView, setInsets: insets, givenUserInfo: notification.userInfo)
        }
    }

    func scrollView(scrollView: UIScrollView, setInsets insets:UIEdgeInsets, givenUserInfo userInfo:NSDictionary?) {
        if let userInfo = userInfo {
            let duration: NSTimeInterval = userInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue ?? 0.25
            let animationCurve: Int = userInfo[UIKeyboardAnimationCurveUserInfoKey]?.integerValue ?? UIViewAnimationCurve.EaseInOut.rawValue
            let animationOptions: UIViewAnimationOptions = UIViewAnimationOptions(UInt(animationCurve << 16))
            UIView.animateWithDuration(duration, delay: 0, options: animationOptions, animations: { () -> Void in
                scrollView.contentInset = insets
                scrollView.scrollIndicatorInsets = insets
                }) { (finished) -> Void in
                    // completion
            }
        }
    }
}
