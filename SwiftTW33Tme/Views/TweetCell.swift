//
//  TweetCell.swift
//  SwiftTW33Tme
//
//  Created by Amie Kweon on 5/1/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    static let replyIcon = UIImage(named: "Reply")
    static let retweetIcon = UIImage(named: "Retweet")
    static let favoriteIcon = UIImage(named: "Favorite")

    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!

    @IBOutlet weak var retweetSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var pictureTopSpacingConstraint: NSLayoutConstraint!

    var didSetupConstraints = false

    override func awakeFromNib() {
        super.awakeFromNib()

        self.separatorInset = UIEdgeInsetsZero
        self.layoutMargins = UIEdgeInsetsZero

        pictureView.layer.cornerRadius = 3
        pictureView.clipsToBounds = true

        usernameLabel.textColor = UIColor.tweetmeGrayColor()
        timeLabel.textColor = UIColor.tweetmeGrayColor()
        retweetLabel.textColor = UIColor.tweetmeGrayColor()

        var buttonSpacing = UIEdgeInsetsMake(6, 6, 6, 6)
        replyButton.setImage(TweetCell.replyIcon, forState: UIControlState.Normal)
        replyButton.imageEdgeInsets = buttonSpacing

        retweetButton.setImage(TweetCell.retweetIcon, forState: UIControlState.Normal)
        retweetButton.imageEdgeInsets = buttonSpacing

        favoriteButton.setImage(TweetCell.favoriteIcon, forState: UIControlState.Normal)
        favoriteButton.imageEdgeInsets = buttonSpacing

        replyButton.alpha = 0.5
        retweetButton.alpha = 0.5
        favoriteButton.alpha = 0.5
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setTweet(tweet: Tweet) {
        if let user = tweet.user {
            usernameLabel.text = "@\(user.screenName!)"
            nameLabel.text = user.name
            var imageURL = NSURL(string: user.profileImageUrl!)
            pictureView.loadAsync(imageURL!, animate: true, failure: nil)
        }
        messageLabel.text = tweet.text
        timeLabel.text = tweet.createdAt?.shortTimeAgoSinceNow()
        if tweet.retweet && !tweet.retweetedByCurrentUser {
            if let retweeter = tweet.retweetUser {
                retweetLabel.text = "\(retweeter.name!) retweeted"
            }
            retweetSpacingConstraint.constant = 22
            pictureTopSpacingConstraint.constant = 22
            retweetLabel.hidden = false
        } else {
            retweetLabel.text = ""
            retweetSpacingConstraint.constant = 0
            pictureTopSpacingConstraint.constant = 0
            retweetLabel.hidden = true
        }
        retweetButton.alpha = tweet.retweetedByCurrentUser ? 1 : 0.5
        favoriteButton.alpha = tweet.favorited ? 1 : 0.5
    }
}
