//
//  RateData.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 11/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import Foundation

/// MARK: RateData
/// Core Data object to save user favorite rates.
///
final class RateData: ObservableObject {

  var symbol: String

  init(symbol: String) {
    self.symbol = symbol
  }
}
