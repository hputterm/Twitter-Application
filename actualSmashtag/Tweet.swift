//
//  Tweet.swift
//  actualSmashtag
//
//  Created by Harry Putterman on 9/24/17.
//  Copyright © 2017 Harry Putterman. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class Tweet: NSManagedObject {
    /**
     Returns a new Tweet if a matching one does not exist or an existing one if it is does.
     */
    class func findOrCreateTweet(matching twitterInfo: Twitter.Tweet,and searchText: String, using context: NSManagedObjectContext) -> Tweet{
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", twitterInfo.identifier)
        do{
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "NOTGOOD")
                return matches[0]
            }
        } catch {
            
        }
        let tweet = Tweet(context: context)
        tweet.id = twitterInfo.identifier
        let search = Search.findOrCreateSearch(matching: searchText, using: context)
        tweet.nameOfSearch?.adding(search)
        for hashTag in twitterInfo.hashtags{
            let mention = Mention.findOrCreateMention(matching: hashTag, using: context)
            mention.count += 1
            mention.tweetsWithMention?.adding(tweet)
            mention.search?.adding(search)
        }
        return tweet
    }
}
