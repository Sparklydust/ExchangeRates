//
//  RatesViewModelTests.swift
//  ExchangeRatesTests
//
//  Created by Roland Lariotte on 10/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import XCTest
@testable import ExchangeRates

class RatesViewModelTests: XCTestCase {

  var sut: RatesViewModel!

  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = RatesViewModel()
  }

  override func tearDownWithError() throws {
    sut = nil
    try super.tearDownWithError()
  }

  func test() throws {
  }
}
