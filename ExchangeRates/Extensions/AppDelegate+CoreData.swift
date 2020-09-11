//
//  AppDelegate+CoreData.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 11/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import Foundation

extension AppDelegate {
  /// Save the Core Data context in the persistent container.
  ///
  func saveContext() {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      }
      catch {
        viewModel.triggerCoreDataError()
      }
    }
  }
}
