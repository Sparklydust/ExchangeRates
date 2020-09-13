//
//  NetworkPlistKey.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 09/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import Foundation

//  MARK: NetworkPlistKey
/// Network.plist file String key.
///
/// Enumaration of the String keys to access the
/// NetworkIronFX.plist file that contains all the API
/// addresses and keys needed in the app. This enum
/// is attached to NetworkAPIManager.swift file.
///
enum NetworkPlistKey: String {

  case apiBase
  case apiKey
}
