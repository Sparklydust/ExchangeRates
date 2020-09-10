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
  @Published var date = Date()
  @Published var timer = Timer
    .publish(every: 1, on: .main, in: .common)
    .autoconnect()

  // Data
  @Published var rates = RatesData()
  @Published var oldRates = [String: Double]()
  @Published var newRates = [String: Double]()
  @Published var currency = String()

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
        receiveCompletion: { [weak self] completion in
          guard let self = self else { return }
          self.handle(completion) },
        receiveValue: { [weak self] data in
          guard let self = self else { return }
          withAnimation(.easeInOut) {
            self.handle(data) } })
      .store(in: &subscriptions)
  }

  /// Performe actions on the rates data coming
  /// from the api where needed.
  ///
  func handle(_ data: RatesData) {
    resetOldRatesNewRates()
    newRates = data.quotes
    rates = data
    setCurrency()
    convertTimestampToDate()
  }

  /// Performe actions on the end of the api call
  /// when finished or on failure.
  ///
  func handle(_ completion: Subscribers.Completion<NetworkError>) {
    switch completion {
    case .failure:
      showNetworkAlert = true
    case .finished:
      showActivityIndicator(false)
      break
    }
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

  /// Setup the currency of the user coming from
  /// the api.
  func setCurrency() {
    currency = rates.source
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
      .store(in: &subscriptions)
    downloadLiveRates()
  }

  /// Convert timestamp value to a readable Date format.
  ///
  func convertTimestampToDate() {
    _ = date.addingTimeInterval(TimeInterval(rates.timestamp))
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

// MARK: NumberFormatter
extension RatesViewModel {
  /// Format the price and currency depending
  /// on user localization.
  ///
  func populateFormatted(_ price: Double) -> String {

    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = true
    formatter.locale = .current
    formatter.numberStyle = .currency
    formatter.currencyCode = currency

    guard let formattedValue = formatter.string(from: NSNumber(value: price)) else {
      return String()
    }
    return formattedValue
  }
}
