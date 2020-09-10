//
//  FakeResponseData.swift
//  ExchangeRatesTests
//
//  Created by Roland Lariotte on 10/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import Foundation

class FakeResponseData {

  static let response200OK = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                             statusCode: 200,
                                             httpVersion: nil,
                                             headerFields: nil)!

  static let responseKO = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                          statusCode: 500,
                                          httpVersion: nil,
                                          headerFields: nil)!

  class RessourceError: Error {}
  static let error = RessourceError()

  static var liveRatesCorrectData: Data {
    let bundle = Bundle(for: FakeResponseData.self)
    let liveRatesURL = bundle.url(forResource: "liveRates", withExtension: "json")
    let liveRatesData = try! Data(contentsOf: liveRatesURL!)
    return liveRatesData
  }

  static let liveRatesIncorrectData = "error".data(using: .utf8)!
}
