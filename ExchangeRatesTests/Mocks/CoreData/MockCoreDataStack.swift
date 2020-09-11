//
//  MockCoreDataStack.swift
//  ExchangeRatesTests
//
//  Created by Roland Lariotte on 11/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import ExchangeRates
import Foundation
import CoreData

class MockCoreDataStack: CoreDataStack {

  convenience init() {
    self.init(modelName: "ExchangeRates")
  }

  override init(modelName: String) {
    super.init(modelName: modelName)

    let persistentStoreDescription = NSPersistentStoreDescription()
    persistentStoreDescription.type = NSInMemoryStoreType

    let container = NSPersistentContainer(name: modelName)
    container.persistentStoreDescriptions = [persistentStoreDescription]

    container.loadPersistentStores { storeDescription, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    persistentContainer = container
  }
}
