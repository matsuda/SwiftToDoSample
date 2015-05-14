//
//  KeyboardAccessoryView.swift
//  AsahiAd
//
//  Created by Kosuke Matsuda on 2015/05/11.
//  Copyright (c) 2015年 Appirits. All rights reserved.
//

import UIKit

@objc protocol KeyboardAccessoryViewDelegate {
    func keyboardAccessoryView(accessoryView: KeyboardAccessoryView, didTapDone button: UIBarButtonItem)
    func keyboardAccessoryView(accessoryView: KeyboardAccessoryView, didTapClose button: UIBarButtonItem)
}

class KeyboardAccessoryView: UIView {

    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!

    weak var delegate: KeyboardAccessoryViewDelegate?
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    // MARK - Singleton
    static let instance: KeyboardAccessoryView = {
        let nib = UINib(nibName: "KeyboardAccessoryView", bundle: nil)
        return nib.instantiateWithOwner(nil, options: nil).first as! KeyboardAccessoryView
    }()

    @IBAction func tapDone(sender: AnyObject) {
        self.delegate?.keyboardAccessoryView(self, didTapDone: self.doneButton)
    }

    @IBAction func tapClose(sender: AnyObject) {
        self.delegate?.keyboardAccessoryView(self, didTapClose: self.doneButton)
    }
}

extension UIViewController: KeyboardAccessoryViewDelegate {
    func keyboardAccessorView() -> KeyboardAccessoryView? {
        let view = KeyboardAccessoryView.instance
        view.delegate = self
        return view
    }
    func keyboardAccessoryView(accessoryView: KeyboardAccessoryView, didTapDone button: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    func keyboardAccessoryView(accessoryView: KeyboardAccessoryView, didTapClose button: UIBarButtonItem) {
        self.view.endEditing(true)
    }
}
