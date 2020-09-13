//
//  NetworkAPIManager.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 09/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import Foundation

//  MARK: NetworkAPIManager
/// Retrieve url inside the Netowrk.plist .gitignored hidden file.
///
/// This class has only one function, to retrieve any url or api key for the all
/// ExchangeRates application. Its aim is to have all urls and keys in one place.
/// The plistValue, must be retrieve with a plistKey that can be found in enum NetworkPlistKey and a plistValue that can be found in enum NetworkPlistValue.
///
/// ```
/// let url = NetworkAPIManager.retrieve(.apiMains, .currencylayer)  // example of use
/// ```
final class NetworkAPIManager {

  /// Retrieve the url value in Network.plist file associated to the key
  ///
  /// - Parameters:
  ///     - plistKey: The key to retrieve the needed url or api key dictionary. See the
  ///     NetworkPlistKey for all keys enumaration.
  ///     - plistValue: The value that contains the needed url or api key in Network.plist
  /// - Returns: ExchangeRates application urls and api keys as a String value.
  ///
  class func retrieve(_ plistKey: NetworkPlistKey, _ plistValue: NetworkPlistValue) -> String {

    guard let filePath = Bundle.main.path(forResource: "Network", ofType: "plist"),
      let plist = NSDictionary(contentsOfFile: filePath) else { return String() }

    let key = plist.object(forKey: plistKey.rawValue) as? Dictionary<String, String>

    guard let value = key?[plistValue.rawValue] else { return String() }

    return value
  }
}
