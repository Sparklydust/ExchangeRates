//
//  NetworkRequestProtocol.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 10/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import Foundation
import Combine

protocol NetworkRequestProtocol {

  associatedtype Resource

  /// Parameter when calling NetworkRequest that
  /// set the full url path of the API request.
  ///
  var resourceURL: NetworkEndpoint { get set }

  /// Main URLSession framework for API request.
  ///
  /// This parameter is not needed to be fullfilled in
  /// the NetworkRequest class as it is automatically set
  /// in the init() and is only used for URLSession mock.
  ///
  var resourceSession: URLSession { get set }

  /// Loading data request for any Resource type.
  ///
  /// Download any data type using a GET request with
  /// NetworkError to handle errors.
  ///
  /// - Returns: one data or one error
  ///
  func download() -> AnyPublisher<Resource, NetworkError>
}
