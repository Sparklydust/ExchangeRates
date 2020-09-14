//
//  NetworkRequestTests.swift
//  ExchangeRatesTests
//
//  Created by Roland Lariotte on 10/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import XCTest
import Combine
@testable import ExchangeRates

class NetworkRequestTests: XCTestCase {

  var expectation: XCTestExpectation!
  var subscriptions: Set<AnyCancellable>!

  override func setUpWithError() throws {
    try super.setUpWithError()
    expectation = XCTestExpectation(description: "wait for fake queue change")
    subscriptions = Set<AnyCancellable>()
  }

  override func tearDownWithError() throws {
    subscriptions = []
    expectation = nil
    try super.tearDownWithError()
  }

  func testNetworkRequest_mockURLSessionAddCorrectDataResponse_returnRatesDataModelValues() throws {
    let expectedTimestamp = 1599669546
    let expectedSource = "USD"
    let expectedQuotes = ["USDAED": 3.672901,
                          "USDAFN": 76.589716,
                          "USDALL": 105.249848]

    let networkRequest = NetworkRequest<RatesData>(.live, resourceSession:
      MockURLSession(data: FakeResponseData.liveRatesCorrectData,
                     response: FakeResponseData.response200OK,
                     error: nil))

    networkRequest.download()
      .sink(
        receiveCompletion: { completion in
          self.expectation.fulfill() },
        receiveValue: { value in
          XCTAssertEqual(expectedTimestamp, value.timestamp)
          XCTAssertEqual(expectedSource, value.source)
          XCTAssertEqual(expectedQuotes, value.quotes)
      })
      .store(in: &subscriptions)

    wait(for: [expectation], timeout: 1)
  }

  func testNetworkRequest_mockURLSessionAddServerErrorAsResponse_returnNetworkErrorInvalidResponse() throws {
    let expectedNetworkError = NetworkError.invalidResponse.localizedDescription

    let networkRequest = NetworkRequest<RatesData>(.live, resourceSession:
      MockURLSession(data: nil,
                     response: FakeResponseData.responseKO,
                     error: nil))

    networkRequest.download()
      .sink(
        receiveCompletion: { completion in
          switch completion {
          case .failure(let error):
            XCTAssertEqual(expectedNetworkError, error.localizedDescription)
          case .finished:
            break
          }
          self.expectation.fulfill() },
        receiveValue: { value in
          XCTAssertNil(value)
      })
      .store(in: &subscriptions)

    wait(for: [expectation], timeout: 1)
  }

  func testNetworkRequest_mockURLSessionAddNilValues_returnComletionWithFailure() throws {
    let networkRequest = NetworkRequest<RatesData>(.live, resourceSession:
      MockURLSession(data: nil,
                     response: nil,
                     error: nil))

    networkRequest.download()
      .sink(
        receiveCompletion: { completion in
          XCTAssertTrue(true, "completion return a failure")
          self.expectation.fulfill() },
        receiveValue: { value in
          XCTAssertNil(value) })
      .store(in: &subscriptions)

    wait(for: [expectation], timeout: 1)
  }
}
