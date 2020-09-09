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
}
