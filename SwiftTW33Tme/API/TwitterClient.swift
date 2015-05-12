//
//  TwitterClient.swift
//  SwiftTW33Tme
//
//  Created by Amie Kweon on 4/30/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

let twitterConsumerKey = "tl2Av403xlyFF1MsPsAoXKA7Q"
let twitterConsumerSecret = "DBm4OMnrVHKVNIeQsLr88cNvQBIPjSeyy0kZDiwNXDNB9A1lHv"
let twitterURL = NSURL(string: "https://api.twitter.com")

//let twitterConsumerKey = "rsofhkUa3oEiNSj8KkRCuDLNr"
//let twitterConsumerSecret = "26xmmRTmSgy3sBbbmSl4xUciwW35F8KYjfLLrsBWfWuqsSAsud"
//let twitterURL = NSURL(string: "https://api.twitter.com")


class TwitterClient: BDBOAuth1RequestOperationManager {

    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    static let sharedInstance = TwitterClient(baseURL: twitterURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)

    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion

        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token",
            method: "GET", callbackURL: NSURL(string: "swifttweetme://oauth"),
            scope: nil,
            success: { (requestToken: BDBOAuth1Credential!) -> Void in
                println("Got the request token")
                var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                println("Failed to get request token")
                self.loginCompletion?(user: nil, error: error)
        }
    }

    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token",
            method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query),
            success: { (accessToken: BDBOAuth1Credential!) -> Void in
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil,
                    success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                        var user = User(dictionary: response as! NSDictionary)
                        User.currentUser = user
                        println("user: \(user.name)")
                        self.loginCompletion?(user: user, error: nil)
                    }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                        println("error: \(error)")
                        self.loginCompletion?(user: nil, error: error)
                })
            }) { (error: NSError!) -> Void in
                println("Failed to receive access token")
                self.loginCompletion?(user: nil, error: error)
        }
    }

    func timelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json?include_my_retweet=1", parameters: params,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error: \(error)")
                completion(tweets: nil, error: error)
        })
    }

    func userTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/user_timeline.json", parameters: params,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error: \(error)")
                completion(tweets: nil, error: error)
        })
    }

    func updateStatusWithParams(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/update.json", parameters: params,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error: \(error)")
                completion(tweet: nil, error: error)
        })
    }

    func retweetWithId(tweetId: Int, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/retweet/\(tweetId).json", parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error: \(error)")
                completion(tweet: nil, error: error)
        })
    }

    func destroyStatusWithId(tweetId: Int, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/destroy/\(tweetId).json", parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error: \(error)")
                completion(tweet: nil, error: error)
        })
    }

    func favoriteWithId(tweetId: Int, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        let params = ["id": tweetId]
        POST("1.1/favorites/create.json", parameters: params,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error: \(error)")
                completion(tweet: nil, error: error)
        })
    }

    func unfavoriteWithId(tweetId: Int, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        let params = ["id": tweetId]
        POST("1.1/favorites/destroy.json", parameters: params,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error: \(error)")
                completion(tweet: nil, error: error)
        })
    }

}
