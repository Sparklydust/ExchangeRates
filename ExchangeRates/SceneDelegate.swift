//
//  SceneDelegate.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 09/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  // MARK: EnvironmentObjects
  var marketViewModel = MarketViewModel()
  var favoritesViewModel = FavoritesViewModel()
  var searchBar = SearchBarItem()

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

    let contentView = ContentView()
      .environment(\.managedObjectContext, CoreDataStack.shared.viewContext)
      .environmentObject(marketViewModel)
      .environmentObject(favoritesViewModel)
      .environmentObject(searchBar)
    
    // Use a UIHostingController as window root view controller.
    if let windowScene = scene as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)
      window.rootViewController = UIHostingController(rootView: contentView)
      self.window = window
      window.makeKeyAndVisible()
    }
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    CoreDataStack.shared.saveContext()
  }
}
