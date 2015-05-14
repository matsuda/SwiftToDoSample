//
//  EditViewController.swift
//  TestToDo
//
//  Created by Kosuke Matsuda on 2015/05/14.
//  Copyright (c) 2015年 Appirits. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var entry: Entry!
    var dataSource: [EntryProperty] = EntryProperty.all()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.presentingViewController == nil {
            self.title = "TODO編集"
            self.navigationItem.leftBarButtonItem = nil
        } else {
            self.title = "TODO作成"
            self.entry = Entry()
        }
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

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        }
        cell?.textLabel?.text = "\(indexPath.row)"
        return cell!
    }

    @IBAction func tapSubmit(sender: AnyObject) {
        if self.presentingViewController == nil {
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func tapCancel(sender: AnyObject) {
        if self.presentingViewController == nil {
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
