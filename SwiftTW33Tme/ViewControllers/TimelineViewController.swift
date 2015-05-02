//
//  TimelineViewController.swift
//  SwiftTW33Tme
//
//  Created by Amie Kweon on 5/1/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {

    var tweets: [Tweet]?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var replyButton: UIButton!

    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)

        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }

    func refresh() {
        fetchData()
        refreshControl.endRefreshing()
    }

    func fetchData() {
        TwitterClient.sharedInstance.timelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let tweetViewController = segue.destinationViewController as? TweetViewController
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        if let tweetViewController = tweetViewController {
            if tweets?.count > indexPath.row {
                tweetViewController.tweet = tweets?[indexPath.row]
            }
        }
    }
}

extension TimelineViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        let tweet = tweets![indexPath.row]
        cell.setTweet(tweet)
        return cell
    }
}
