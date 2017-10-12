//
//  Mention.swift
//  actualSmashtag
//
//  Created by Harry Putterman on 9/24/17.
//  Copyright © 2017 Harry Putterman. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class Mention: NSManagedObject {
    /**
    Returns a new Mention if a matching one does not exist or an existing one if it is does.
    */
    class func findOrCreateMention(matching mentionInfo: Twitter.Mention, using context: NSManagedObjectContext) -> Mention{
        let request: NSFetchRequest<Mention> = Mention.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", mentionInfo.keyword)
        do{
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "NOTGOOD")
                return matches[0]
                
            }
        } catch {
            
        }
        let mention = Mention(context: context)
        mention.name = mentionInfo.keyword
        return mention
    }
}
