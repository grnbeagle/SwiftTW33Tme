//
//  ProfileViewController.swift
//  SwiftTW33Tme
//
//  Created by Amie Kweon on 5/10/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var tweets = [Tweet]()
    var user: User?
    var fromTimeline = false

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        if user == nil {
            user = User.currentUser
        }
        navigationItem.title = "\(user!.name!)"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        fetchData()

        if fromTimeline {
            var backButton = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: "onCloseTapped")
            self.navigationItem.leftBarButtonItem = backButton
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onCloseTapped() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func fetchData() {
        var params = NSMutableDictionary()
        params["screen_name"] = "\(user!.screenName!)"
        TwitterClient.sharedInstance.userTimelineWithParams(params, completion: { (tweets, error) -> () in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            }
        })
    }

    @IBAction func onHamburgerTapped(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("hamburgerTapped", object: nil)
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

extension ProfileViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return tweets.count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCellWithIdentifier("StatsCell", forIndexPath: indexPath) as? StatsCell
            cell?.setUser(user!)
            return cell!
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as? TweetCell
            cell!.frame = CGRectMake(0, 0, view.frame.width, 75)
            cell!.setTweet(tweets[indexPath.row])
            return cell!
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2  // one for stat and another for tweets
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            var containerView = UIView(frame: CGRectMake(0, 0, view.frame.width, 140))
            containerView.clipsToBounds = true

            var profileCell = tableView.dequeueReusableCellWithIdentifier("ProfileCell") as? ProfileCell
            profileCell!.frame = containerView.frame
            profileCell!.setProfileUser(user!)

            containerView.addSubview(profileCell!)
            return containerView
        } else {
            return nil
        }
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 140 : 0
    }
}