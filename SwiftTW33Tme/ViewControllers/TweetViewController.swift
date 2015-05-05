//
//  TweetViewController.swift
//  SwiftTW33Tme
//
//  Created by Amie Kweon on 5/2/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    var tweet: Tweet?

    static let replyIcon = UIImage(named: "Reply")
    static let retweetIcon = UIImage(named: "Retweet")
    static let favoriteIcon = UIImage(named: "Favorite")

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!

    @IBOutlet weak var containerTopSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var separator1: UIView!
    @IBOutlet weak var separator2: UIView!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetWordLabel: UILabel!
    @IBOutlet weak var favoriteWordLabel: UILabel!

    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        pictureView.layer.cornerRadius = 3
        pictureView.clipsToBounds = true

        retweetLabel.textColor = UIColor.tweetmeGrayColor()
        screennameLabel.textColor = UIColor.tweetmeGrayColor()
        separator1.backgroundColor = UIColor.tweetmeLightGrayColor()
        separator2.backgroundColor = UIColor.tweetmeLightGrayColor()
        timestampLabel.textColor = UIColor.tweetmeGrayColor()
        retweetWordLabel.textColor = UIColor.tweetmeGrayColor()
        favoriteWordLabel.textColor = UIColor.tweetmeGrayColor()

        var buttonSpacing = UIEdgeInsetsMake(6, 6, 6, 6)
        replyButton.setImage(TweetViewController.replyIcon, forState: UIControlState.Normal)
        replyButton.imageEdgeInsets = buttonSpacing

        retweetButton.setImage(TweetViewController.retweetIcon, forState: UIControlState.Normal)
        retweetButton.imageEdgeInsets = buttonSpacing

        favoriteButton.setImage(TweetViewController.favoriteIcon, forState: UIControlState.Normal)
        favoriteButton.imageEdgeInsets = buttonSpacing

        replyButton.alpha = 0.5
        retweetButton.alpha = 0.5
        favoriteButton.alpha = 0.5

        if let tweet = tweet {
            if let user = tweet.user {
                nameLabel.text = user.name
                screennameLabel.text = "@\(user.screenName!)"
                var imageURL = NSURL(string: user.profileImageUrl!)
                pictureView.loadAsync(imageURL!, animate: true, failure: nil)
            }
            messageLabel.text = tweet.text!
            timestampLabel.text = tweet.createdAt?.formattedDateWithStyle(NSDateFormatterStyle.FullStyle)
            if tweet.retweet {
                if let retweetUser = tweet.retweetUser {
                    retweetLabel.text = "\(retweetUser.name!) retweeted"
                }
                retweetLabel.hidden = false
                containerTopSpacingConstraint.constant = 28
            } else {
                retweetLabel.text = ""
                retweetLabel.hidden = true
                containerTopSpacingConstraint.constant = 0
            }
            updateCount(tweet)
            updateButtonState(tweet)
        }
    }

    func updateCount(tweet: Tweet) {
        if let retweetCount = tweet.retweetCount {
            retweetCountLabel.text = "\(retweetCount)"
            retweetWordLabel.text = retweetCount > 1 ? "RETWEETS" : "RETWEET"
        }
        if let favoriteCount = tweet.favoriteCount {
            favoriteCountLabel.text = "\(favoriteCount)"
            favoriteWordLabel.text = favoriteCount > 1 ? "FAVORITES" : "FAVORITE"
        }
        retweetCountLabel.sizeToFit()
        favoriteCountLabel.sizeToFit()
    }

    func updateButtonState(tweet: Tweet) {
        retweetButton.alpha = tweet.retweetedByCurrentUser ? 1 : 0.5
        favoriteButton.alpha = tweet.favorited ? 1 : 0.5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onReplyClicked(sender: AnyObject) {
        performSegueWithIdentifier("tweetToComposeSegue", sender: self)
    }

    @IBAction func onRetweetClicked(sender: AnyObject) {
        if let tweet = tweet {
            if !tweet.retweetedByCurrentUser {
                retweetButton.alpha = 1
                TwitterClient.sharedInstance.retweetWithId(tweet.id!, completion: { (tweet, error) -> () in
                    if let tweet = tweet {
                        // returned tweet is a retweeted tweet.. different from the original tweet
                        self.tweet!.currentUserRetweetId = tweet.id
                        self.tweet!.retweetedByCurrentUser = true
                        self.tweet!.retweetCount = tweet.retweetCount
                        self.updateCount(self.tweet!)
                    }
                })
            } else if tweet.currentUserRetweetId != nil {
                retweetButton.alpha = 0.5
                TwitterClient.sharedInstance.destroyStatusWithId(tweet.id!, completion: { (tweet, error) -> () in
                    if let tweet = self.tweet {
                        self.tweet!.retweetCount = tweet.retweetCount
                        self.tweet!.retweetedByCurrentUser = false
                        self.tweet!.currentUserRetweetId = nil
                        self.updateCount(self.tweet!)
                    }
                })
            }
        }
    }

    @IBAction func onFavoriteClicked(sender: AnyObject) {
        if let tweet = tweet {
            if tweet.favorited {
                favoriteButton.alpha = 0.5
                TwitterClient.sharedInstance.unfavoriteWithId(tweet.id!, completion: { (tweet, error) -> () in
                    if let tweet = tweet {
                        self.tweet!.favoriteCount = tweet.favoriteCount
                        self.updateCount(self.tweet!)
                    }
                })
            } else {
                favoriteButton.alpha = 1
                TwitterClient.sharedInstance.favoriteWithId(tweet.id!, completion: { (tweet, error) -> () in
                    if let tweet = tweet {
                        self.tweet!.favoriteCount = tweet.favoriteCount
                        self.updateCount(self.tweet!)
                    }
                })
            }
        }
    }

    @IBAction func onNavReplyClicked(sender: AnyObject) {
        performSegueWithIdentifier("tweetToComposeSegue", sender: self)
    }


    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let navigationController = segue.destinationViewController as? UINavigationController
        if let navigationController = navigationController {
            let composeViewController = navigationController.topViewController as? ComposeViewController
            if let composeViewController = composeViewController {
                composeViewController.replyTo = tweet
            }
        }

    }

}
