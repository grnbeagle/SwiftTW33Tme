//
//  Tweet.swift
//  SwiftTW33Tme
//
//  Created by Amie Kweon on 5/1/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var id: Int?
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var retweet: Bool = false
    var retweetedByCurrentUser: Bool = false
    var favorited: Bool = false
    var retweetUser: User?
    var retweetCount: Int?
    var favoriteCount: Int?

    init(dictionary: NSDictionary) {
        id = dictionary["id"] as? Int
        user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        retweetCount = dictionary["retweet_count"] as? Int
        if retweetCount == nil {
            retweetCount = 0
        }
        favoriteCount = dictionary["favorite_count"] as? Int
        if favoriteCount == nil {
            favoriteCount = 0
        }
        if let retweeted = dictionary["retweeted"] as? Bool {
            retweetedByCurrentUser = retweeted
        }
        if let favorited = dictionary["favorited"] as? Bool {
            self.favorited = favorited
        }

        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)

        var retweetDict = dictionary["retweeted_status"] as? NSDictionary
        if let retweetDict = retweetDict {
            retweet = true
            retweetUser = user
            user = User(dictionary: (retweetDict["user"] as? NSDictionary)!)
        }
    }

    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
}
