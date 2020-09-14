//
//  NetworkAPIManagerTests.swift
//  ExchangeRatesTests
//
//  Created by Roland Lariotte on 09/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import Foundation

import XCTest
@testable import ExchangeRates

class NetworkAPIManagerTests: XCTestCase {

  func testNetworkAPIManager_retrieveAPIBaseValueAssociatedToKeyUnitTest_returnExpectedValue() throws {
    let expected = "http://api.test.com/"

    let url = NetworkAPIManager.retrieve(.apiBase, .unitTest)

    XCTAssertEqual(url, expected)
  }

  func testNetworkAPIManager_retrieveAPIKeyValueAssociatedToKeyUnitTest_returnExpectedValue() throws {
    let expected = "123abc"

    let apiKey = NetworkAPIManager.retrieve(.apiKey, .unitTest)

    XCTAssertEqual(apiKey, expected)
  }
}
