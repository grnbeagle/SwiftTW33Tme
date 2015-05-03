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
        tableView.delegate = self
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var tweetViewController = segue.destinationViewController as? TweetViewController
        var navigationController = segue.destinationViewController as? UINavigationController
        if let tweetViewController = tweetViewController {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)!
            if tweets?.count > indexPath.row {
                tweetViewController.tweet = tweets?[indexPath.row]
            }
        }
        if let navigationController = navigationController {
            var composeViewController = navigationController.topViewController as? ComposeViewController
            if let composeViewController = composeViewController {
                composeViewController.delegate = self
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

extension TimelineViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension TimelineViewController: ComposeViewControllerDelegate {
    func composeViewController(composeViewController: ComposeViewController, didAddNewTweet tweet: Tweet) {
        tweets?.insert(tweet, atIndex: 0)
        tableView.reloadData()
    }
}