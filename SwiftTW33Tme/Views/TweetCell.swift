//
//  TweetCell.swift
//  SwiftTW33Tme
//
//  Created by Amie Kweon on 5/1/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    var didSetupConstraints = false

    override func awakeFromNib() {
        super.awakeFromNib()

        pictureView.layer.cornerRadius = 3
        pictureView.clipsToBounds = true

        //setNeedsUpdateConstraints()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setTweet(tweet: Tweet) {
        if let user = tweet.user {
            usernameLabel.text = user.screenName
            nameLabel.text = user.name
            var imageURL = NSURL(string: user.profileImageUrl!)
            pictureView.loadAsync(imageURL!, animate: true, failure: nil)
        }
        messageLabel.text = tweet.text
        timeLabel.text = tweet.createdAt?.shortTimeAgoSinceNow()
    }

//    override func updateConstraints() {
//        if !didSetupConstraints {
//            pictureView.autoSetDimensionsToSize(CGSizeMake(50, 50))
//            pictureView.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: 30)
//            pictureView.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 8)
//
//            nameLabel.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: 30)
//            nameLabel.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Right, ofView: pictureView, withOffset: 10)
//            nameLabel.setContentCompressionResistancePriority(751, forAxis: UILayoutConstraintAxis.Horizontal)
//
//            usernameLabel.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: 30)
//            usernameLabel.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Right, ofView: nameLabel, withOffset: 10)
//
//            timeLabel.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Right, ofView: usernameLabel, withOffset: 10, relation: NSLayoutRelation.GreaterThanOrEqual)
//            timeLabel.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: 15)
//
//            didSetupConstraints = true
//        }
//        super.updateConstraints()
//    }

}
