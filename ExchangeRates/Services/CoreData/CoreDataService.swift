//
//  CoreDataService.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 11/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import Foundation
import CoreData

//  MARK: CoreDataService
/// Responsible for saving, fetching and deleting data in
/// Core Data.
///
/// managedObjectContext and coreDataStack initializer are for
/// the unit test only and mock CoreDataService.
///
final class CoreDataService {

  static let modelName = "ExchangeRates"

  let managedObjectContext: NSManagedObjectContext
  let coreDataStack: CoreDataStack
  
  public init(managedObjectContext: NSManagedObjectContext = CoreDataStack.shared.viewContext,
              coreDataStack: CoreDataStack = CoreDataStack.shared) {
    self.managedObjectContext = managedObjectContext
    self.coreDataStack = coreDataStack
  }
}

/// MARK: - CoreData Actions
extension CoreDataService {
  /// Save Core Data Rate model in memory.
  ///
  func save(symbol: String) -> Rate? {
    let rateData = Rate(context: managedObjectContext)

    rateData.symbol = symbol

    coreDataStack.saveContext()

    return rateData
  }
  /// Fetch array of Core Data Rate models from memory.
  ///
  func fetch() -> [Rate] {
    let fetchRequest: NSFetchRequest<Rate> = Rate.fetchRequest()
    guard let rates = try? managedObjectContext.fetch(fetchRequest) else {
      return []
    }
    return rates
  }

  /// Delete Core Data Rate model in memory.
  ///
  func delete(symbol: NSManagedObject) {
    managedObjectContext.delete(symbol)
    coreDataStack.saveContext()
  }
}
