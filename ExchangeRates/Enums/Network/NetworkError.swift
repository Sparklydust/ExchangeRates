//
//  NetworkError.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 10/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import Foundation

//  MARK: NetworkError
/// Handle API call response with error for debugging purpose.
///
enum NetworkError: LocalizedError {

  case addressUnreachable(URL)
  case invalidResponse

  var errorDescription: String? {
    switch self {
    case .invalidResponse:
      return "The server response is invalid."
    case .addressUnreachable(let url):
      return "\(url.absoluteString) is unreachable."
    }
  }
}
