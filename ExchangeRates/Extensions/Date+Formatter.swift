//
//  Date+Formatter.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 11/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import Foundation

extension Date {
  /// Format timestamp converted value to a cleaner
  /// date and time format for user.
  ///
  func formatted() -> String {
    let formatter = DateFormatter()
    formatter.locale = .current
    formatter.dateStyle = .medium
    formatter.timeStyle = .medium
    return formatter.string(from: self)
  }
}
