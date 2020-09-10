//
//  MockURLSession.swift
//  ExchangeRatesTests
//
//  Created by Roland Lariotte on 10/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import Foundation

class MockURLSession: URLSession {

  var data: Data?
  var response: URLResponse?
  var error: Error?

  init(data: Data?, response: URLResponse?, error: Error?) {
    self.data = data
    self.response = response
    self.error = error
  }

  override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    let data = self.data
    let response = self.response
    let error = self.error
    return MockURLSessionDataTask {
      completionHandler(data, response, error)
    }
  }
}
