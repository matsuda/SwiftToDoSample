//
//  DetailViewController.swift
//  TestToDo
//
//  Created by Kosuke Matsuda on 2015/05/14.
//  Copyright (c) 2015年 Appirits. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EditViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var task: Task!
    var dataSource: [TaskProperty] = TaskProperty.all()
    var prototypeMemoCell: FlexibleLabelCell?
    let MemoCellIdentifier = "MemoCell"

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = self.task.title
        self.configureView()
        self.prepareTableView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editData" {
            let destination = segue.destinationViewController as! EditViewController
            destination.task = self.task
            destination.delegate = self
        }
    }

    @IBAction func tapEdit(sender: AnyObject) {
        self.performSegueWithIdentifier("editData", sender: self)
    }

    func editViewController(controller: EditViewController, didFinishWithSave save: Bool) {
        if save {
            if let context = self.task.managedObjectContext {
                var error: NSError?
                if context.save(&error) {
                    APPLOG("save task")
                } else {
                    APPLOG("can't save task : \(error) : \(error?.userInfo)")
                }
            }
        }
    }

    func prepareTableView() {
        let nib = UINib(nibName: "FlexibleLabelCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: MemoCellIdentifier)
    }

    func layoutPrototypeCellInTableView(tableView: UITableView) {
        if var frame = prototypeMemoCell?.frame {
            frame.size.width = tableView.frame.size.width
            prototypeMemoCell?.frame = frame
        }
        prototypeMemoCell?.setNeedsLayout()
        prototypeMemoCell?.layoutIfNeeded()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row: TaskProperty = self.dataSource[indexPath.row]
        var height: CGFloat = 44
        switch row {
        case .Memo:
            if self.prototypeMemoCell == nil {
                self.prototypeMemoCell = tableView.dequeueReusableCellWithIdentifier(MemoCellIdentifier) as? FlexibleLabelCell
            }
            if let cell = self.prototypeMemoCell {
                confitureMemoCell(cell, atIndexPath: indexPath)
                layoutPrototypeCellInTableView(tableView)
                let size = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
                height = max(size.height + 1, height)
            }
        default:
            break
        }
        return height
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row: TaskProperty = self.dataSource[indexPath.row]
        switch row {
        case .Title, .Priority, .DueDate:
            return self.tableView(tableView, labelCellForRowAtIndexPath: indexPath)
        case .Memo:
            return self.tableView(tableView, memoCellForRowAtIndexPath: indexPath)
        default:
            return self.tableView(tableView, defaultCellForRowAtIndexPath: indexPath)
        }
    }

    func tableView(tableView: UITableView, defaultCellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier = "Cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: CellIdentifier)
        }
        return cell!
    }

    func tableView(tableView: UITableView, labelCellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let LabelCellIdentifier = "LabelCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(LabelCellIdentifier) as! UITableViewCell
        confitureLabelCell(cell, atIndexPath: indexPath)
        return cell
    }

    func tableView(tableView: UITableView, memoCellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row: TaskProperty = self.dataSource[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier(MemoCellIdentifier) as! FlexibleLabelCell
        confitureMemoCell(cell, atIndexPath: indexPath)
        return cell
    }

    func confitureLabelCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let row: TaskProperty = self.dataSource[indexPath.row]
        cell.textLabel?.text = row.toString()
        switch row {
        case .Title:
            cell.detailTextLabel?.text = self.task.title
        case .Priority:
            cell.detailTextLabel?.text = self.task.priority.toString()
        case .DueDate:
            cell.detailTextLabel?.text = self.task.dueDateAsString
        default:
            break
        }
    }

    func confitureMemoCell(cell: FlexibleLabelCell, atIndexPath indexPath: NSIndexPath) {
        cell.selectionStyle = .None
        cell.contentLabel.font = UIFont.systemFontOfSize(15)
        cell.contentLabel.text = self.task.memo
    }
}

