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
    var replyTo: Tweet?
    var sinceTweetId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        tweets = [Tweet]()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)

        createLoadingIcon()
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
        var params = NSMutableDictionary()
        if let sinceTweetId = sinceTweetId {
            params["since_id"] = sinceTweetId
        }
        TwitterClient.sharedInstance.timelineWithParams(params, completion: { (tweets, error) -> () in
            if let tweets = tweets {
                self.tweets! += tweets
                if self.sinceTweetId == nil && count(tweets) > 0 {
                    var lastTweet = tweets[count(tweets)-1] as Tweet
                    self.sinceTweetId = lastTweet.id
                }
                self.tableView.reloadData()
            }
        })
    }

    func createLoadingIcon() {
        var tableFooterView = UIView(frame: CGRectMake(0, 0, view.frame.width, 50))
        var loadingView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        loadingView.startAnimating()
        loadingView.center = tableFooterView.center
        tableFooterView.addSubview(loadingView)
        tableView.tableFooterView = tableFooterView
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
                let composeButton = sender as? UIBarButtonItem
                if let composeButton = composeButton {
                    if composeButton.title == "Compose" {
                        replyTo = nil
                    }
                }
                if replyTo != nil {
                    composeViewController.replyTo = replyTo!
                }
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
        cell.replyButton.tag = indexPath.row
        cell.replyButton.addTarget(self, action: "onReplyClicked:", forControlEvents: UIControlEvents.TouchDown)

        cell.retweetButton.tag = indexPath.row
        cell.retweetButton.addTarget(self, action: "onRetweetClicked:", forControlEvents: UIControlEvents.TouchDown)

        cell.favoriteButton.tag = indexPath.row
        cell.favoriteButton.addTarget(self, action: "onFavoriteClicked:", forControlEvents: UIControlEvents.TouchDown)

        let tweet = tweets![indexPath.row]
        cell.setTweet(tweet)

        return cell
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row >= self.tweets!.count - 1 {
            fetchData()
        }
    }

    func onReplyClicked(sender: AnyObject?) {
        var button = sender as? UIButton
        if let button = button {
            let row = button.tag
            if row < tweets?.count {
                replyTo = tweets?[row]
                self.performSegueWithIdentifier("composeSegue", sender: self)
            }
        }
    }

    func onRetweetClicked(sender: AnyObject?) {
        var button = sender as? UIButton
        if let button = button {
            let row = button.tag
            if row < tweets?.count {
                if let tweet = tweets?[row] {
                    if !tweet.retweetedByCurrentUser {
                        button.alpha = 1
                        var tweetId = tweet.id!
                        TwitterClient.sharedInstance.retweetWithId(tweetId, completion: { (tweet, error) -> () in
                            if let tweet = tweet {
                                self.tweets?[row] = tweet
                            }
                        })
                    } else {
                        button.alpha = 0.5
                        TwitterClient.sharedInstance.destroyStatusWithId(tweet.id!, completion: { (tweet, error) -> () in
                            var tweet = self.tweets?[row]
                            if let tweet = tweet {
                                tweet.retweetCount = max(0, tweet.retweetCount! - 1)
                                tweet.retweetedByCurrentUser = false
                                self.tweets?[row] = tweet
                            }
                        })
                    }
                }
            }
        }
    }

    func onFavoriteClicked(sender: AnyObject?) {
        var button = sender as? UIButton
        if let button = button {
            let row = button.tag
            if row < tweets?.count {
                if let tweet = tweets?[row] {
                    var tweetId = tweet.id!
                    if tweet.favorited {
                        button.alpha = 0.5
                        TwitterClient.sharedInstance.unfavoriteWithId(tweetId, completion: { (tweet, error) -> () in
                            if let tweet = tweet {
                                self.tweets?[row] = tweet
                            }
                        })
                    } else {
                        button.alpha = 1
                        TwitterClient.sharedInstance.favoriteWithId(tweetId, completion: { (tweet, error) -> () in
                            if let tweet = tweet {
                                self.tweets?[row] = tweet
                            }
                        })
                    }
                }
            }
        }
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