//
//  NavPersonCell.swift
//  SwiftTW33Tme
//
//  Created by Amie Kweon on 5/10/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class NavPersonCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var screennameLabel: UILabel!

    @IBOutlet weak var profileImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
        screennameLabel.textColor = UIColor.tweetmeGrayColor()
        contentView.backgroundColor = UIColor.tweetmeLightGrayColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setPerson(user: User) {
        nameLabel.text = user.name!
        screennameLabel.text = "@\(user.screenName!)"
        var imageUrl = NSURL(string: user.profileImageUrl!)
        profileImageView.loadAsync(imageUrl!, animate: false, failure: nil)
    }
}
