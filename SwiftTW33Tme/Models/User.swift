//
//  User.swift
//  SwiftTW33Tme
//
//  Created by Amie Kweon on 5/1/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit


class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary
    var bannerImageUrl: String?
    var friendsCount: Int?
    var followersCount: Int?
    var tweetsCount: Int?

    static var _currentUser: User?
    static let currentUserKey = "currentUserKey"
    static let userDidLoginNotification = "userDidLoginNotification"
    static let userDidLogoutNotification = "userDidLogoutNotification"

    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
        bannerImageUrl = dictionary["profile_banner_url"] as? String
        friendsCount = dictionary["friends_count"] as? Int
        followersCount = dictionary["followers_count"] as? Int
        tweetsCount = dictionary["statuses_count"] as? Int
    }

    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }

    static var currentUser: User? {
        get {
            if _currentUser == nil {
                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if let data = data {
                    var dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
                    _currentUser = User(dictionary: dictionary!)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user

            if _currentUser != nil {
                var data = NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
