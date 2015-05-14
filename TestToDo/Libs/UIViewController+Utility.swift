//
//  UIViewController+AAD.swift
//  AsahiAd
//
//  Created by Kosuke Matsuda on 2015/04/30.
//  Copyright (c) 2015年 Appirits. All rights reserved.
//

import UIKit

private struct AssociatedKeys {
    static var shouldAdjustsScrollViewInsetsKey = "shouldAdjustsScrollViewInsetsKey"
}

extension UIViewController {
    var shouldAdjustsScrollViewInsets: Bool {
        get {
            if let value = objc_getAssociatedObject(self, &AssociatedKeys.shouldAdjustsScrollViewInsetsKey) as? NSNumber {
                return value.boolValue
            } else {
                return false
            }
        }
        set {
            objc_setAssociatedObject(
                self, &AssociatedKeys.shouldAdjustsScrollViewInsetsKey,
                NSNumber(bool: newValue), UInt(OBJC_ASSOCIATION_COPY_NONATOMIC)
            )
        }
    }

    func xxx_manuallyAdjustsScrollViewInsetsAndOffset(scrollView: UIScrollView, completion: ((UIScrollView) -> Void)?) {
        if self.shouldAdjustsScrollViewInsets { return }
        let currentInsets = scrollView.contentInset
        var insets = currentInsets
        var parent: UIViewController = self
        while !(parent.parentViewController is UINavigationController) &&
            parent.parentViewController != nil &&
            parent.parentViewController?.parentViewController != nil {
            parent = parent.parentViewController!
        }
        insets.top = parent.topLayoutGuide.length
        if !UIEdgeInsetsEqualToEdgeInsets(currentInsets, insets) {
            insets.top += currentInsets.top
            scrollView.contentInset = insets
            scrollView.scrollIndicatorInsets = insets
            if (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0 {
                let d = insets.top
                scrollView.setContentOffset(CGPointMake(0, -d), animated: false)
            }
        }
        self.shouldAdjustsScrollViewInsets = true
        completion?(scrollView)
    }
}
