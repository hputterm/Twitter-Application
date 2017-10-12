//
//  individualTweetTableViewController.swift
//  actualSmashtag
//
//  Created by Harry Putterman on 9/18/17.
//  Copyright © 2017 Harry Putterman. All rights reserved.
//

import UIKit
import Twitter

class individualTweetTableViewController: UITableViewController {
    enum mediaOrMention{
        case media(MediaItem)
        case mention(Twitter.Mention)
    }
    var tweet:Twitter.Tweet?{
        didSet{
            if tweet?.media.count != 0{
                dictOfMentions.append([])
                for i in (tweet?.media)!{
                    dictOfMentions[0].append(mediaOrMention.media(i))
                }
                sectionHeaders.append("Images")
            }
            for i in [tweet?.hashtags, tweet?.urls, tweet?.userMentions]{
                if i?.count != 0{
                    dictOfMentions.append([])
                    for x in i! {
                        dictOfMentions[dictOfMentions.count-1].append(mediaOrMention.mention(x))
                    }
                }
            }
            if tweet?.hashtags.count != 0 {sectionHeaders.append("HashTags")}
            if tweet?.urls.count != 0 {sectionHeaders.append("URLs")}
            if tweet?.userMentions.count != 0 {sectionHeaders.append("User Mentions")}
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dictOfMentions.count
    }
    var dictOfMentions = [[mediaOrMention]]()
    var sectionHeaders = [String]()
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictOfMentions[section].count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell
        switch dictOfMentions[indexPath.section][indexPath.row]{
        case .media(let value):
            cell = tableView.dequeueReusableCell(withIdentifier: "subImageTableViewCell", for: indexPath)
            if let imageCell = cell as? imageTableViewCell{
                imageCell.mediaForImage = value
            }
        case .mention(let value):
            cell = tableView.dequeueReusableCell(withIdentifier: "subMentionTableViewCell", for: indexPath)
            cell.textLabel?.text = value.keyword
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mention = dictOfMentions[indexPath.section][indexPath.row]
        switch mention {
        case .media(let value):
            let aspectRatio = value.aspectRatio
            return tableView.bounds.size.width / CGFloat(aspectRatio)
        default:
            tableView.estimatedRowHeight = tableView.rowHeight
            return UITableViewAutomaticDimension
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if let desinationAsNavigation = destinationViewController as? UINavigationController{
            destinationViewController = desinationAsNavigation.visibleViewController ?? destinationViewController
        }
        if let tweetViewController = destinationViewController as? TweetTableViewController{
            if let identifier = segue.identifier{
                if identifier == "searchForItem"{
                    if let tweetIndex = tableView.indexPathForSelectedRow{
                        switch dictOfMentions[tweetIndex.section][tweetIndex.row] {
                        case .mention(let value):
                            tweetViewController.searchText = value.keyword
                        default:
                            break
                        }
                    }
                }
            }
        }
        if let imageViewController = destinationViewController as? ImageViewController{
            if let identifier = segue.identifier{
                if identifier == "segueToImageView"{
                    if let tweetIndex = tableView.indexPathForSelectedRow{
                        switch dictOfMentions[tweetIndex.section][tweetIndex.row]{
                        case .media(let value):
                            imageViewController.imageData = value.url
                        default:
                            break
                        }
                    }
                }
            }
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "searchForItem"{
            if let tweetIndex = tableView.indexPathForSelectedRow{
                let whatCouldBeUrl = dictOfMentions[tweetIndex.section][tweetIndex.row]
                var url = ""
                switch whatCouldBeUrl {
                case .mention(let value):
                    url = value.keyword
                default:
                    break
                }
                if sectionHeaders[tweetIndex.section] == "URLs"{
                    UIApplication.shared.open(URL(string: url)!)
                    return false
                }
            }
        }
        return true
    }
}
