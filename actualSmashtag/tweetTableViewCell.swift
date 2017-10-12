//
//  tweetTableViewCell.swift
//  actualSmashtag
//
//  Created by Harry Putterman on 9/16/17.
//  Copyright © 2017 Harry Putterman. All rights reserved.
//

import UIKit
import Twitter
class tweetTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetBodyLabel: UILabel!
    @IBOutlet weak var tweetDateLabel: UILabel!
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    var tweet: Twitter.Tweet?{didSet{updateUI()}}
    private var tweetMentionColor:UIColor = UIColor.blue
    private var tweetHashTagColor:UIColor = UIColor.blue
    private var tweetURLColor:UIColor = UIColor.cyan
    /**
    Sets all of the UI components of this tweetTableViewCell
    */
    private func updateUI(){
        tweetUserLabel?.text = tweet?.user.description
        tweetBodyLabel?.attributedText = setAttributedText()
        if let profileImageURL = tweet?.user.profileImageURL{
            if let imageData = try? Data(contentsOf: profileImageURL){
                tweetProfileImageView?.image = UIImage(data: imageData)
            } else {
                tweetProfileImageView?.image = nil
            }
        }
        if let dateOfCreation = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(dateOfCreation) > 24*60*60{
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            tweetDateLabel?.text = formatter.string(from: dateOfCreation)
        } else {
            tweetDateLabel?.text = nil
        }
        
    }
    private func setAttributedText()->NSMutableAttributedString{
        let text = tweet?.text
        let newtext = NSMutableAttributedString(string: text!)
        var attribute = [NSForegroundColorAttributeName: tweetHashTagColor]
        for mention in (tweet?.hashtags)!{
            newtext.addAttributes(attribute, range: mention.nsrange)
        }
        attribute = [NSForegroundColorAttributeName: tweetURLColor]
        for mention in (tweet?.urls)!{
            newtext.addAttributes(attribute, range: mention.nsrange)
        }
        attribute = [NSForegroundColorAttributeName: tweetMentionColor]
        for mention in (tweet?.userMentions)!{
            newtext.addAttributes(attribute, range: mention.nsrange)
        }
        return newtext
    }
    
}
