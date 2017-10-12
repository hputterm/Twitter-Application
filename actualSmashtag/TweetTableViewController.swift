//
//  TweetTableViewController.swift
//  actualSmashtag
//
//  Created by Harry Putterman on 9/14/17.
//  Copyright © 2017 Harry Putterman. All rights reserved.
//

import UIKit
import Twitter


class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    private var tweets = [Array<Twitter.Tweet>](){
        didSet{
            
        }
    }
    var searchText: String?{
        didSet{
            if let text = searchText{
                recentSearches.addSearch(for: text)
            }
            searchTextField?.text = searchText
            searchTextField?.resignFirstResponder()
            tweets.removeAll()
            tableView.reloadData()
            searchForTweets()
            title = searchText
        }
    }
    /**
    Creates a twitter request for the query name.
    */
    private func twitterRequest()->Twitter.Request? {
        if let query = searchText, !query.isEmpty {
            return Twitter.Request(search: query, count: 100)
        }
        return nil
    }
    /**
    Adds tweets to the internal data structure.
    */
    internal func insertTweets(_ newTweets: [Twitter.Tweet]){
        self.tweets.insert(newTweets, at: 0)
        self.tableView.insertSections([0], with: .fade)
    }
    private var lastTwitterRequest: Twitter.Request?
    /**
    Fetches tweets using a twitter request.
    */
    private func searchForTweets(){
        if let request = twitterRequest(){
            lastTwitterRequest = request
            request.fetchTweets { [weak self] newTweets in
                DispatchQueue.main.async {
                    if request == self?.lastTwitterRequest{
                        self?.insertTweets(newTweets)
                    }
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    @IBOutlet weak var searchTextField: UITextField!{
        didSet{
            searchTextField.delegate = self
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchText = searchTextField.text
        }
        return true
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweet", for: indexPath)
        
        let tweet = tweets[indexPath.section][indexPath.row]
        if let tweetCell = cell as? tweetTableViewCell {
            tweetCell.tweet = tweet
        }
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if let destinationNavigation = destinationViewController as? UINavigationController{
            destinationViewController = destinationNavigation.visibleViewController ?? destinationViewController
        }
        if let individualViewController = destinationViewController as? individualTweetTableViewController{
            if let identifier = segue.identifier{
                if identifier == "individualTweetSegue"{
                    if let tweetIndex = tableView.indexPathForSelectedRow?.row{
                        individualViewController.tweet = tweets[0][tweetIndex]
                    }
                }
            }
        }
    }

}
