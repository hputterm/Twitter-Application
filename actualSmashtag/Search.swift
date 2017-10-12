//
//  Search.swift
//  actualSmashtag
//
//  Created by Harry Putterman on 9/24/17.
//  Copyright © 2017 Harry Putterman. All rights reserved.
//

import UIKit
import CoreData

class Search: NSManagedObject {
    /**
     Returns a new Search if a matching one does not exist or an existing one if it is does.
     */
    class func findOrCreateSearch(matching searchText: String, using context: NSManagedObjectContext) -> Search{
        let request: NSFetchRequest<Search> = Search.fetchRequest()
        request.predicate = NSPredicate(format: "searchName = %@", searchText)
        do{
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "NOTGOOD")
                return matches[0]
            }
        } catch {
            
        }
        let search = Search(context: context)
        search.searchName = searchText
        return search
    }
}
