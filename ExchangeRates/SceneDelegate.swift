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
  var ratesViewModel = RatesViewModel()

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

    let contentView = ContentView()
      .environment(\.managedObjectContext, CoreDataStack.shared.viewContext)
      .environmentObject(ratesViewModel)
    
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
