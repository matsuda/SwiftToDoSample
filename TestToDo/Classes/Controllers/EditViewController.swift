//
//  EditViewController.swift
//  TestToDo
//
//  Created by Kosuke Matsuda on 2015/05/14.
//  Copyright (c) 2015年 Appirits. All rights reserved.
//

import UIKit

class EditViewController: UIViewController,
UITableViewDataSource, UITableViewDelegate,
UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var task: Task!
    var dataSource: [TaskProperty] = TaskProperty.all()

    let TextFieldCellIdentifier = "TextFieldCell"
    let TextViewCellIdentifier = "TextViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.presentingViewController == nil {
            self.title = "TODO編集"
            self.navigationItem.leftBarButtonItem = nil
        } else {
            self.title = "TODO作成"
            self.task = Task()
        }
        self.prepareTableView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addObserverForKeyboardNotifications()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserverForKeyboardNotifications()
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

    @IBAction func tapSubmit(sender: AnyObject) {
        self.view.endEditing(true)
        if self.presentingViewController == nil {
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func tapCancel(sender: AnyObject) {
        self.view.endEditing(true)
        if self.presentingViewController == nil {
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    func prepareTableView() {
        self.tableView.rowHeight = 44
        var nib = UINib(nibName: TextFieldCellIdentifier, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: TextFieldCellIdentifier)
        nib = UINib(nibName: TextViewCellIdentifier, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: TextViewCellIdentifier)
    }

    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let row = self.dataSource[indexPath.row]
        switch row {
        case .Title:
            let editCell = cell as! TextFieldCell
            editCell.textField.placeholder = "入力"
            editCell.label.text = row.toString()
            editCell.textField.text = self.task.title
        case .Memo:
            let editCell = cell as! TextViewCell
            editCell.label.font = UIFont.systemFontOfSize(17)
            editCell.label.text = row.toString()
            editCell.textView.text = self.task.memo
        case .Priority:
            cell.detailTextLabel?.font = UIFont.systemFontOfSize(14)
            cell.detailTextLabel?.textColor = UIColor.blackColor()
            cell.textLabel?.text = row.toString()
            cell.detailTextLabel?.text = self.task.priority.toString()
        case .DueDate:
            cell.detailTextLabel?.font = UIFont.systemFontOfSize(14)
            cell.detailTextLabel?.textColor = UIColor.blackColor()
            cell.textLabel?.text = row.toString()
            cell.detailTextLabel?.text = self.task.dueDateAsString
        default:
            break
        }
    }

    // MARK: - UITableView

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: CGFloat = 44;
        let row = self.dataSource[indexPath.row]
        switch row {
        case .Memo:
            height = 180
        default:
            break
        }
        return height
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = self.dataSource[indexPath.row]
        var cell: UITableViewCell!
        switch row {
        case .Title:
            cell = self.tableView(tableView, textFieldCellForRowAtIndexPath: indexPath)
        case .Memo:
            cell = self.tableView(tableView, textViewCellForRowAtIndexPath: indexPath)
        default:
            cell = self.tableView(tableView, defaultCellForRowAtIndexPath: indexPath)
        }
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }

    func tableView(tableView: UITableView, defaultCellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: "Cell")
        }
        return cell!
    }

    func tableView(tableView: UITableView, textFieldCellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = self.dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(TextFieldCellIdentifier) as! TextFieldCell
        cell.textField.delegate = self
        return cell
    }

    func tableView(tableView: UITableView, textViewCellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = self.dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(TextViewCellIdentifier) as! TextViewCell
        cell.textView.delegate = self
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = self.dataSource[indexPath.row]
        switch row {
        case .Title:
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! TextFieldCell
            cell.textField.becomeFirstResponder()
        case .Memo:
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! TextViewCell
            cell.textView.becomeFirstResponder()
        case .Priority:
            self.presentPickerController()
        case .DueDate:
            self.presentDatePickerController()
        default:
            break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - UITextField delegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.tableView.xxx_selectRowAtFirstRespondingView(textField)
        return true
    }

    // MARK: - UITextView delegate
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        self.tableView.xxx_selectRowAtFirstRespondingView(textView)
        return true
    }

}

extension EditViewController: UIPickerViewDataSource, UIPickerViewDelegate, PickerControllerDelegate {
    func presentPickerController() {
        self.view.endEditing(true)
        let pickerController = self.storyboard?.instantiateViewControllerWithIdentifier("PickerController") as! PickerController
        pickerController.presentPicker(true, completion: { (finished) -> Void in
            var priority = self.task.priority.rawValue
            pickerController.pickerView.selectRow(priority+1, inComponent: 0, animated: true)
        })
        self.addChildViewController(pickerController)
        pickerController.didMoveToParentViewController(self)
        pickerController.delegate = self
        pickerController.pickerView.delegate = self
        pickerController.pickerView.dataSource = self;
    }

    func dismissPickerController(controller: PickerController) {
        controller.dismissPickerAnimated(true, completion: { (finished) -> Void in
            controller.willMoveToParentViewController(nil)
            controller.removeFromParentViewController()
        })
    }

    func pickerControllerDidCancel(controller: PickerController) {
        self.dismissPickerController(controller)
    }

    func pickerControllerDidSelect(controller: PickerController) {
        let index = controller.pickerView.selectedRowInComponent(0)
        self.dismissPickerController(controller)
        let priority = Task.Priority(rawValue: index-1)!
        self.task.priority = priority
        self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .None)
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        let priority = Task.Priority(rawValue: row-1)
        return priority?.toString()
    }
}

extension EditViewController: DatePickerControllerDelegate {
    func presentDatePickerController() {
        self.view.endEditing(true)
        let pickerController = self.storyboard?.instantiateViewControllerWithIdentifier("DatePickerController") as! DatePickerController
        pickerController.presentPicker(true, completion: { (finished) -> Void in
            pickerController.datePicker.date = self.task.dueDate
        })
        self.addChildViewController(pickerController)
        pickerController.didMoveToParentViewController(self)
        pickerController.delegate = self
    }

    func dismissDatePickerController(controller: DatePickerController) {
        controller.dismissPickerAnimated(true, completion: { (finished) -> Void in
            controller.willMoveToParentViewController(nil)
            controller.removeFromParentViewController()
        })
    }

    func datePickerControllerDidCancel(controller: DatePickerController) {
        self.dismissDatePickerController(controller)
    }

    func datePickerControllerDidSelect(controller: DatePickerController) {
        let date = controller.datePicker.date
        self.dismissDatePickerController(controller)
        self.task.dueDate = date
        self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 2, inSection: 0)], withRowAnimation: .None)
    }
}

extension EditViewController {
    // MARK: - override super
    override var inputAccessoryView: UIView? {
        get {
            return keyboardAccessorView()
        }
    }

    override var scrollViewForKeyboardNotifications: UIScrollView {
        get {
            return self.tableView
        }
    }
}
