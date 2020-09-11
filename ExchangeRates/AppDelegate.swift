//
//  AppDelegate.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 09/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import SwiftUI
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  @EnvironmentObject var viewModel: RatesViewModel

  /// Core Data persistent container to save Rate as favorite.
  ///
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "ExchangeRates")
    container.loadPersistentStores { _, error in
      if let error = error {
        self.viewModel.triggerCoreDataError()
      }
    }
    return container
  }()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    return true
  }

  // MARK: UISceneSession Lifecycle
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
  }
}
