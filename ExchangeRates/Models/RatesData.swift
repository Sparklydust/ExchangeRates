//
//  RatesData.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 10/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import Foundation

//  MARK: RatesData
/// Model for NetworkEndpoint.live.url request.
///
/// Populates live exchange rates from currencylayer.com.
///
struct RatesData: Codable, Hashable, RatesDataProtocol {

  var success = false
  var terms = String()
  var privacy = String()
  var timestamp = Int()
  var source = String()
  var quotes = [String: Double]()
}
