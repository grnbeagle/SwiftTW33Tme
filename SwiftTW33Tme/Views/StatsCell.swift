//
//  StatsCell.swift
//  SwiftTW33Tme
//
//  Created by Amie Kweon on 5/10/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class StatsCell: UITableViewCell {

    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var friendsCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!

    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var friendsLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!



    override func awakeFromNib() {
        super.awakeFromNib()

        tweetsLabel.textColor = UIColor.tweetmeGrayColor()
        friendsLabel.textColor = UIColor.tweetmeGrayColor()
        followersLabel.textColor = UIColor.tweetmeGrayColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUser(user: User) {
        tweetsCountLabel.text = "\(user.tweetsCount!)"
        friendsCountLabel.text = "\(user.friendsCount!)"
        followersCountLabel.text = "\(user.followersCount!)"
    }
}
