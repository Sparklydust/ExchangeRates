//
//  RatesDataProtocol.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 10/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import Foundation

protocol RatesDataProtocol {

  var success: Bool { get set }
  var terms: String { get set }
  var privacy: String { get set }
  var timestamp: Int { get set }
  var source: String { get set }
  var quotes: [String: Double] { get set }
}
