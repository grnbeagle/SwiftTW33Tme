//
//  ComposeViewController.swift
//  SwiftTW33Tme
//
//  Created by Amie Kweon on 5/2/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

@objc protocol ComposeViewControllerDelegate {
    optional func composeViewController(composeViewController: ComposeViewController, didAddNewTweet tweet: Tweet)
}

class ComposeViewController: UIViewController {

    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!

    let placeholderText = "What's happening?"
    let charLimit = 140

    weak var delegate: ComposeViewControllerDelegate?
    var replyTo: Tweet?
    var charCountLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        pictureView.layer.cornerRadius = 3
        pictureView.clipsToBounds = true

        screennameLabel.textColor = UIColor.tweetmeGrayColor()
        messageTextView.textColor = UIColor.tweetmeGrayColor()
        messageTextView.text = placeholderText
        messageTextView.delegate = self

        if let user = User.currentUser {
            nameLabel.text = user.name
            screennameLabel.text = "@\(user.screenName!)"
            var imageURL = NSURL(string: user.profileImageUrl!)
            pictureView.loadAsync(imageURL!, animate: true, failure: nil)
        }

        if let replyTo = replyTo, user = replyTo.user {
            messageTextView.text = "@\(user.screenName!)"
            messageTextView.textColor = UIColor.blackColor()
            messageTextView.becomeFirstResponder()
        }

        // Set vertical alignment of message text to top
        automaticallyAdjustsScrollViewInsets = false

        // Setup a label for character count
        charCountLabel = UILabel(frame: CGRectMake(view.frame.width - 100, -3, 100, 50))
        charCountLabel!.text = "\(charLimit)"
        charCountLabel!.textColor = UIColor.tweetmeGrayColor()
        navigationController?.navigationBar.addSubview(charCountLabel!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        var params: [String: String] = ["status": messageTextView.text]
        if let replyTo = replyTo {
            params.updateValue("\(replyTo.id)", forKey: "in_reply_to_status_id")
        }
        TwitterClient.sharedInstance.updateStatusWithParams(params, completion: { (tweet, error) -> () in
            if tweet != nil {
                self.delegate?.composeViewController?(self, didAddNewTweet: tweet!)
            }
            if error != nil {
                println("error: \(error)")
            }
            self.close()
        })
    }

    @IBAction func onClose(sender: AnyObject) {
        close()
    }

    func close() {
        replyTo = nil
        dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ComposeViewController: UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
        textView.becomeFirstResponder()
    }

    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = placeholderText
            textView.textColor = UIColor.tweetmeGrayColor()
        }
        textView.resignFirstResponder()
    }

    func textViewDidChange(textView: UITextView) {
        var remainingCount = charLimit - count(textView.text)
        charCountLabel?.text = "\(remainingCount)"
    }
}

