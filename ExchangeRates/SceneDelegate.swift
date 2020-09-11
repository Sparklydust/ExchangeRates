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

    /// Core Data managed object context.
    guard let context = (UIApplication.shared.delegate as? AppDelegate)?
      .persistentContainer
      .viewContext else {
        ratesViewModel.showCoreDataError = true
        return
    }

    let contentView = ContentView()
      .environment(\.managedObjectContext, context)
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
    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
  }
}
