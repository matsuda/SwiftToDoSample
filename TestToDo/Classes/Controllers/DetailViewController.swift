//
//  DetailViewController.swift
//  TestToDo
//
//  Created by Kosuke Matsuda on 2015/05/14.
//  Copyright (c) 2015年 Appirits. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var entry: Entry!
    var dataSource: [EntryProperty] = EntryProperty.all()
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
        self.title = self.entry.title
        self.configureView()
        let nib = UINib(nibName: "FlexibleLabelCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: MemoCellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editData" {
            let destination = segue.destinationViewController as! EditViewController
            destination.entry = self.entry
        }
    }

    @IBAction func tapEdit(sender: AnyObject) {
        self.performSegueWithIdentifier("editData", sender: self)
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
        let row: EntryProperty = self.dataSource[indexPath.row]
        var height: CGFloat = 44
        switch row {
        case .Memo:
            if self.prototypeMemoCell == nil {
                self.prototypeMemoCell = tableView.dequeueReusableCellWithIdentifier(MemoCellIdentifier) as? FlexibleLabelCell
            }
            if let cell = self.prototypeMemoCell {
                cell.contentLabel.text = self.entry.memo
                cell.contentLabel.font = UIFont.systemFontOfSize(15)
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
        let row: EntryProperty = self.dataSource[indexPath.row]
        switch row {
        case .Title, .Priority, .DueDate:
            return self.tableView(tableView, labelCellForRowAtIndexPath: indexPath)
        case .Memo:
            return self.tableView(tableView, memoCellForRowAtIndexPath: indexPath)
        default:
            var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
            }
            return cell!
        }
    }

    func tableView(tableView: UITableView, labelCellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row: EntryProperty = self.dataSource[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier("LabelCell") as! UITableViewCell
        cell.textLabel?.text = row.toString()
        switch row {
        case .Title:
            cell.detailTextLabel?.text = self.entry.title
        case .Priority:
            cell.detailTextLabel?.text = self.entry.priority.toString()
        case .DueDate:
            cell.detailTextLabel?.text = self.entry.dueDateAsString
        default:
            break
        }
        return cell
    }

    func tableView(tableView: UITableView, memoCellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row: EntryProperty = self.dataSource[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier(MemoCellIdentifier) as! FlexibleLabelCell
        cell.contentLabel.font = UIFont.systemFontOfSize(15)
        cell.contentLabel.text = self.entry.memo
        return cell
    }
}

