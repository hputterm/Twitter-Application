//
//  SmashTweetersTableViewController.swift
//  actualSmashtag
//
//  Created by Harry Putterman on 9/25/17.
//  Copyright © 2017 Harry Putterman. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class SmashTweetersTableViewController: FetchedResultsTableViewController
{
    var mention: String?{didSet{updateUI()}}
    var contrainer: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {didSet{updateUI()}}
    var fetchedResultsController: NSFetchedResultsController<Mention>?
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    /**
    Updates the UI by performing the fetch of the fetchedResultsController
    */
    private func updateUI(){
        if let context = contrainer?.viewContext, mention != nil{
            let request: NSFetchRequest<Mention> = Mention.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "count", ascending: false)]
            fetchedResultsController = NSFetchedResultsController<Mention>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            try? fetchedResultsController?.performFetch()
            tableView.reloadData()
            print("HI")
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Twitter Mention", for: indexPath)
        if let twitterMention = fetchedResultsController?.object(at: indexPath){
            cell.textLabel?.text = twitterMention.name
            cell.detailTextLabel?.text = "Number of times \(twitterMention.count)"
        }
        return cell
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections, sections.count > 0{
            return sections[section].numberOfObjects
        }
        else{
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController?.sections, sections.count > 0{
            return sections[section].indexTitle
        }
        else{
            return nil
        }
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return fetchedResultsController?.sectionIndexTitles
    }
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return fetchedResultsController?.section(forSectionIndexTitle: title, at: index) ?? 0
    }
}
