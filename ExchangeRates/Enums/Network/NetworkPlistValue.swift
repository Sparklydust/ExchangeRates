//
//  NetworkPlistValue.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 09/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import Foundation

//  MARK: NetworkPlistValue
/// Network.plist file nested dictionary String key to retrieve value.
///
/// Enumaration of the String keys to access the
/// Network.plist nested dictionary value that contains
/// all the API addresses and keys needed in the app.
/// This enum is attached to NetworkAPIManager.swift
/// file.
///
enum NetworkPlistValue: String {

  case currencylayer
  case unitTest
}
