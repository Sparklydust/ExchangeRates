//
//  CoreDataStack.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 11/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import SwiftUI
import CoreData

//  MARK: CoreDataStack
/// Perform tasks on the core data container to setup
/// the appropriate context.
///
open class CoreDataStack {
  static var shared = CoreDataStack(modelName: "ExchangeRates")

  let modelName: String

  public init(modelName: String) {
    self.modelName = modelName
  }

  @EnvironmentObject var marketViewModel: MarketViewModel

  /// Core Data persistent container..
  ///
  public lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: self.modelName)
    container.loadPersistentStores { _, error in
      if let error = error {
        self.marketViewModel.triggerCoreDataError()
      }
    }
    return container
  }()

  /// CoreData view context passed in ContentView in SceneDelegate.
  ///
  public lazy var viewContext: NSManagedObjectContext = {
    return persistentContainer.viewContext
  }()

  /// Save the Core Data viewContext in the persistent container.
  ///
  public func saveContext() {
    guard viewContext.hasChanges else { return }
    do {
      try viewContext.save()
    }
    catch {
      marketViewModel.triggerCoreDataError()
    }
  }
}
