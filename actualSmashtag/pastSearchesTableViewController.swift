//
//  pastSearchesTableViewController.swift
//  actualSmashtag
//
//  Created by Harry Putterman on 9/21/17.
//  Copyright © 2017 Harry Putterman. All rights reserved.
//

import UIKit
struct recentSearches
{
    /**
    Adds a search to the user defaults.
    */
    static func addSearch(for searchTerm: String){
        var currentArray = UserDefaults.standard.array(forKey: "searches") as? Array<String> ?? []
        currentArray.insert(searchTerm, at: 0)
        if currentArray.count > 100{
            currentArray.removeLast()
        }
        UserDefaults.standard.set(currentArray, forKey: "searches")
    }
    /**
    Returns a list of all the searches.
    */
    static func returnSearhArray()->Array<String>{
        return UserDefaults.standard.array(forKey: "searches") as? Array<String> ?? []
    }
    
}
class pastSearchesTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.returnSearhArray().count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentSearchesTableViewCell", for: indexPath)
        cell.textLabel?.text = recentSearches.returnSearhArray()[indexPath.row]
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination
        if let smashtweets = segue.destination as? SmashTweetersTableViewController{
            if let identifier  = segue.identifier{
                if identifier == "showHashTagOrdering"{
                    smashtweets.mention = "set"
                }
            }
        }
        if let tweetViewController = destinationViewController as? TweetTableViewController{
            if let identifier = segue.identifier{
                if identifier == "segueToTweetSearch"{
                    if let tweetIndex = tableView.indexPathForSelectedRow{
                        tweetViewController.searchText = recentSearches.returnSearhArray()[tweetIndex.row]
                    }
                }
            }
        }
    }
}
