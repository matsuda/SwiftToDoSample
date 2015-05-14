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
        self.configureView()
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

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }

//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        switch indexPath.row {
//        case 3:
//            return 100
//        default:
//            return 44
//        }
//    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row: EntryProperty = self.dataSource[indexPath.row]
        switch row {
        case .Title, .Priority, .CreatedAt:
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
        case .CreatedAt:
            cell.detailTextLabel?.text = self.entry.createdAtAsString
        default:
            break
        }
        return cell
    }

    func tableView(tableView: UITableView, memoCellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row: EntryProperty = self.dataSource[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier("MemoCell") as! UITableViewCell
        let label = cell.viewWithTag(1) as! UILabel
        label.text = self.entry.memo
        return cell
    }
}

