//
//  ExchangeTimer.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 13/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import Foundation
import Combine

//  MARK: ExchangeTimer
/// Timer.Publisher that trigger events at interval.
///
/// Used to trigger the api at constant interval. Value
/// from connectedPublisher interval and connect() must
/// matched to avoid incoherence on api call.
///
class ExchangeTimer: ObservableObject {

  /// Trigger timer for the onReceive plublisher at
  /// constant interval.
  ///
  var connectedPublisher = Timer
    .TimerPublisher(interval: 62, runLoop: .main, mode: .default)
    .autoconnect()

  /// Start the timer on the main thread.
  ///
  func connect() {
    connectedPublisher = Timer
      .TimerPublisher(interval: 62, runLoop: .main, mode: .default)
      .autoconnect()
  }

  /// Stop the timer for publisher at interval.
  ///
  func disconnect() {
    connectedPublisher
      .upstream
      .connect()
      .cancel()
  }
}
