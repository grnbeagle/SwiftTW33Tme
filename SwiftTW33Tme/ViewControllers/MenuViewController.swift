//
//  MenuViewController.swift
//  SwiftTW33Tme
//
//  Created by Amie Kweon on 5/10/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    var menuItems: [[String: String]] = [
        ["title": "Timeline"],
        ["title": "Profile"],
        ["title": "Log out"]
    ]

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = UIColor.tweetmeLightGrayColor()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 30
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

}

extension MenuViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        NSNotificationCenter.defaultCenter().postNotificationName("menuSelectedByTag", object: indexPath.row)
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var personCell = tableView.dequeueReusableCellWithIdentifier("NavPersonCell") as? NavPersonCell
        personCell!.setPerson(User.currentUser!)
        return personCell
    }
}

extension MenuViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.textLabel?.text = menuItems[indexPath.row]["title"]
        cell.backgroundColor = UIColor.tweetmeLightGrayColor()
        return cell
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 105
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}