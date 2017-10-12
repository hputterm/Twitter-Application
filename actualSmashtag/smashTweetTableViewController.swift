//
//  smashTweetTableViewController.swift
//  actualSmashtag
//
//  Created by Harry Putterman on 9/24/17.
//  Copyright © 2017 Harry Putterman. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class smashTweetTableViewController: TweetTableViewController
{
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    override func insertTweets(_ newTweets: [Twitter.Tweet]) {
        super.insertTweets(newTweets)
        updataDatabase(with: newTweets)
    }
    private func updataDatabase(with tweets: [Twitter.Tweet]){
        container?.performBackgroundTask({[weak self] context in
            for twitterInfo in tweets{
                _ = Tweet.findOrCreateTweet(matching: twitterInfo, and: (self?.searchText!)!, using: context)
            }
            try? context.save()
            self?.printDataBaseStatistics()
        })
    }
    /**
    Prints the information from core data framework to verify the system is working.
    */
    private func printDataBaseStatistics(){
        if let context = container?.viewContext{
            context.perform {
                let request: NSFetchRequest<Mention> = Mention.fetchRequest()
                if let tweetResults = try? context.fetch(request){
                    for x in tweetResults{
                        print(x.name)
                    }
                }
                if let tweeterCount = try? context.count(for: Tweet.fetchRequest()){
                    print("\(tweeterCount) tweeterCount")
                }
                if let tweeterCount = try? context.count(for: Mention.fetchRequest()){
                    print("\(tweeterCount) mentionCount")
                }
                if let tweeterCount = try? context.count(for: Search.fetchRequest()){
                    print("\(tweeterCount) searchCount")
                }
            }
        }
    }
}
