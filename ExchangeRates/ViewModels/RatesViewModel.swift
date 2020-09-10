//
//  RatesViewModel.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 10/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import SwiftUI
import Combine

//  MARK: RatesViewModel
/// Logic handler for the MarketView and DetailsView.
///
final class RatesViewModel: ObservableObject {

  private var subscriptions = Set<AnyCancellable>()

  // UI Levers
  @Published var showNetworkAlert = false
  @Published var showTryAgainButton = false
  @Published var isLoading = false

  // Timer
  @Published var timer = Timer
    .publish(every: 61, on: .main, in: .common)
    .autoconnect()

  // Data
  @Published var oldRates = [String: Double]()
  @Published var newRates = [String: Double]()

  // UX
  @Published var rateArrow = Image(systemName: "arrow.up")
  @Published var rateColor: Color = .blue
}

// MARK: - Network call
extension RatesViewModel {
  /// Download live rates from the currency layer api.
  ///
  /// Fetch new rates on success and reset old saved rates.
  /// On error, trigger Alert to the user.
  ///
  func downloadLiveRates() {
    showActivityIndicator(true)
    NetworkRequest<RatesData>(.live).download()
      .sink(
        receiveCompletion: { completion in
          switch completion {
          case .failure:
            self.showNetworkAlert = true
          case .finished:
            self.showActivityIndicator(false)
            break }},
        receiveValue: { data in
          withAnimation(.easeInOut) {
            self.resetOldRatesNewRates()
            self.newRates = data.quotes } })
      .store(in: &subscriptions)
  }

  /// Trigger the UIKit navigfation controller
  /// set as Spinner in Views.
  ///
  func showActivityIndicator(_ action: Bool) {
    isLoading = action
  }

  /// Reset old Rates with new rates and empty
  /// new rates to receive values from api call.
  ///
  func resetOldRatesNewRates() {
    oldRates = newRates
    newRates = [String: Double]()
  }
}

// MARK: - Timer
extension RatesViewModel {
  /// User cancel timer from Alert to stop making network
  /// request in MarketView.
  ///
  func cancelUpstreamTimer() {
    self.isLoading = false
    showTryAgainButton = true
    disconnectUpstreamTimer()
  }

  /// Disconnect Timer to stop making network request in
  /// MarketView.
  ///
  func disconnectUpstreamTimer() {
    timer.upstream
      .connect()
      .cancel()
  }

  /// User trigger Timer again from Alert to restart
  /// network request.
  ///
  func tryAgainUpstreamTimer() {
    showTryAgainButton = false
    timer.upstream
      .connect()
      .store(in: &self.subscriptions)
    downloadLiveRates()
  }
}

// MARK: Alert
extension RatesViewModel {
  /// Show alert to user when network error is triggered.
  ///
  /// User has the choice to cancel or try again api call.
  ///
  func showNetworkErrorAlert() -> Alert {
    Alert(title: Text(Localized.networkErrorTitle),
          message: Text(Localized.networkErrorMessage),
          primaryButton: .cancel {
            withAnimation(.easeInOut) {
              self.cancelUpstreamTimer() }},
          secondaryButton: .default(Text(Localized.tryAgain)) {
            self.tryAgainUpstreamTimer()
      })
  }
}
