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

        tableView.dataSource = self
        tableView.delegate = self


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
        var menu = menuItems[indexPath.row]
        println("go to " + menu["title"]!)
    }
}

extension MenuViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.textLabel?.text = menuItems[indexPath.row]["title"]
        return cell
    }
}