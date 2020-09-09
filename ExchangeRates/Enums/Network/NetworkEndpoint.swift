//
//  NetworkEndpoint.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 09/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import Foundation

//  MARK: NetworkEndpoint
/// ExchangeRates network url endpoints enumaration.
///
/// All urls are handled by this enum with a base url retrieve
/// from the Network.plist file as well as the api key.
///
enum NetworkEndpoint {

  /// Currencylayer.com base api url
  static let baseURL = URL(string: "\(NetworkAPIManager.retrieve(.apiBase, .currencylayer))")
  /// Currencylayer.com personal api key
  static let apiKey = NetworkAPIManager.retrieve(.apiKey, .currencylayer)

  /// URL key path access value for api call
  static let accessKey = "?access_Key=\(NetworkEndpoint.apiKey)"

  case live

  var url: URL {
    switch self {
    case .live:
      let liveURL = NetworkEndpoint.baseURL
        .flatMap {
          URL(string: $0.absoluteString + "live" + NetworkEndpoint.accessKey) }!
      return liveURL
    }
  }
}
