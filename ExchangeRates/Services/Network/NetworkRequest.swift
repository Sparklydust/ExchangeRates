//
//  NetworkRequest.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 09/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import Foundation
import Combine

//  MARK: NetworkRequest
/// ExchangeRates application network requests handler.
///
/// Request being made within this application are being
/// set here with a resourceURL as full url. ResourceSession
/// is set to be used for unit test only and mock URLSession.
///
final class NetworkRequest<Resource> where Resource: Codable {

  private var resourceURL: NetworkEndpoint
  private var resourceSession: URLSession

  init(_ resourceURL: NetworkEndpoint,
       resourceSession: URLSession = URLSession(configuration: .default)) {
    self.resourceURL = resourceURL
    self.resourceSession = resourceSession
  }

  // MARK: - Dispatch Queues
  let downloadQueue = DispatchQueue(
    label: "downloadQueue", qos: .userInitiated,
    attributes: .concurrent, autoreleaseFrequency: .inherit, target: .main)
}

// MARK: - Network Requests
extension NetworkRequest {

  /// Loading data request for any Resource type.
  ///
  /// Download any data type using a GET request with
  /// error handling.
  ///
  /// - Returns: one data
  ///
  func download() -> AnyPublisher<Resource, NetworkError> {

    resourceSession
      .dataTaskPublisher(for: resourceURL.url)
      .receive(on: downloadQueue)
      .retry(2)
      .map(\.data)
      .decode(type: Resource.self, decoder: JSONDecoder())
      .mapError { error -> NetworkError in
        switch error {
        case is URLError:
          return .addressUnreachable(self.resourceURL.url)
        default:
          return .invalidResponse }}
      .eraseToAnyPublisher()
  }
}
