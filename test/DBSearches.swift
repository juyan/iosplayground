//
//  DBSearches.swift
//  test
//
//  Created by Jun Yan on 8/12/16.
//  Copyright © 2016 Superbet. All rights reserved.
//

import Foundation
import CoreData

class DBSearches : NSManagedObject {

  @NSManaged var query : String
  @NSManaged var lastSearched: Int

  static let entityName: String = "RecentSearches"

  class func recentSearches(count: Int, context: NSManagedObjectContext) -> [DBSearches] {
    let request = NSFetchRequest(entityName: entityName)
    request.fetchLimit = count
    request.sortDescriptors = [NSSortDescriptor(key: "lastSearched", ascending: false)]

    do {
      let results = try context.executeFetchRequest(request)
      return results as! [DBSearches]
    } catch let error as NSError {
      NSLog("recentSearches: \(error.localizedDescription)")
    }
    return []
  }

  class func searchWithQuery(query: String, inContext context: NSManagedObjectContext) -> DBSearches? {
    let request = NSFetchRequest(entityName: entityName)
    request.fetchLimit = 1
    request.predicate = NSPredicate(format: "%K == %@", "query", query)

    do {
      let results = try context.executeFetchRequest(request)
      return results.last as? DBSearches
    } catch let error as NSError {
      NSLog("objectById: \(error.localizedDescription)")
    }
    return nil
  }

  class func upsert(query: String, inWriteContext context: NSManagedObjectContext) -> DBSearches? {
    var object = searchWithQuery(query, inContext: context)

    // insert new object
    if object == nil {
      object = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: context) as? DBSearches
    }

    if let object = object {
      // set values
      object.query = query
      object.lastSearched = Int(NSDate().timeIntervalSince1970 * 1000)
      return object
    } else {
      return nil
    }
  }
}