//
//  Localized.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 09/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import SwiftUI

//  MARK: Localized
/// Enumeration of localized Strings for translations.
///
/// This enum is the link between all the code String
/// declarations to the Localizable.strings keys to
/// perform the translations.
///
/// ```
/// Localized.market // example of use
/// ```
enum Localized {
  typealias LSK = LocalizedStringKey
}

// MARK: - Translation Keys
extension Localized {

  // MARK: Tab Bar Item
  static var market: LSK { return "market" }
  static var favorites: LSK { return "favorites" }

  // MARK: Navigation title
  static var details: LSK { return "details" }

  // MARK: Button
  static var tryAgain: LSK { return "tryAgain" }

  // MARK: Error Title
  static var networkErrorTitle: LSK { return "networkErrorTitle" }

  // MARK: Error Message
  static var networkErrorMessage: LSK { return "networkErrorMessage" }
}
