//
//  ProfileCell.swift
//  SwiftTW33Tme
//
//  Created by Amie Kweon on 5/10/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {


    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!

    var bannerImageView: UIImageView?

    var user: User?

    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = 3
        userImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setProfileUser(user: User) {
        nameLabel.text = user.name
        screennameLabel.text = "@\(user.screenName!)"
        var imageURL = NSURL(string: user.profileImageUrl!)
        userImageView.loadAsync(imageURL!, animate: true, failure: nil)
        if let bannerImageUrl = user.bannerImageUrl {
            if bannerImageView == nil {
                bannerImageView = UIImageView(frame: CGRectMake(0, 0, frame.width, 150))
                bannerImageView!.contentMode = UIViewContentMode.ScaleAspectFill
                var imageUrl = NSURL(string: bannerImageUrl)
                bannerImageView!.loadAsync(imageUrl!, animate: false, failure: nil)
                addSubview(bannerImageView!)
                sendSubviewToBack(bannerImageView!)
                contentView.backgroundColor = UIColor.clearColor()
            }
        }
    }
}
