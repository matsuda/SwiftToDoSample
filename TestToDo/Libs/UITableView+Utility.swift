//
//  UITableView+AAD.swift
//  AsahiAd
//
//  Created by Kosuke Matsuda on 2015/05/11.
//  Copyright (c) 2015年 Appirits. All rights reserved.
//

import UIKit

extension UITableView {
    func xxx_selectRowAtFirstRespondingView(current: UIView?) {
        var view = current?.superview
        while (view != nil && !(view is UITableViewCell)) {
            view = view?.superview
        }
        if view is UITableViewCell {
            if let indexPath = self.indexPathForCell(view as! UITableViewCell) {
                self.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .None)
                let delay = 0.1
                let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue(), {
                    self.deselectRowAtIndexPath(indexPath, animated: true)
                })
            }
        }
    }
}
