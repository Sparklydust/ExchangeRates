//
//  MarketViewModel.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 10/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import SwiftUI
import Combine

//  MARK: MarketViewModel
/// Logic handler for the MarketView and DetailsView.
///
final class MarketViewModel: ObservableObject {

  private var subscriptions = Set<AnyCancellable>()

  var coreDataService = CoreDataService()

  // UI Levers
  @Published var showNetworkAlert = false
  @Published var showTryAgainButton = false
  @Published var isLoading = false
  @Published var showCoreDataError = false
  @Published var showCoreDataCrash = false
  @Published var isFavorited = false

  // Timer
  @Published var date = Date()
  @Published var timer = Timer
    .publish(every: 61, on: .main, in: .common)
    .autoconnect()

  // Data
  @Published var rates = RatesData()
  @Published var oldRates = [String: Double]()
  @Published var newRates = [String: Double]()
  @Published var currency = String()

  // UX
  @Published var rateArrow = Image(systemName: "arrow.up")
  @Published var rateColor: Color = .blue
  @Published var detailRateArrow = Image(systemName: "arrow.up")
  @Published var detailRateColor: Color = .blue
}

// MARK: - Network call
extension MarketViewModel {
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

  /// Perform actions on the rates data coming
  /// from the api where needed.
  ///
  func handle(_ data: RatesData) {
    resetOldRatesNewRates()
    newRates = data.quotes
    rates = data
    setCurrency()
    convertTimestampToDate()
  }

  /// Perform actions on the end of the api call
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
  ///
  func setCurrency() {
    currency = rates.source
  }
}

// MARK: - Timer
extension MarketViewModel {
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

// MARK: - CoreData
extension MarketViewModel {
  /// User favorites a rate in Details view and save it in
  /// Core Data.
  ///
  func favoriteStarIsTapped(for symbol: String) {
    if isFavorited {
      let fetchedRates = coreDataService.fetch()
      for i in fetchedRates {
        if i.symbol == symbol {
          _ = coreDataService.delete(rate: i)
          isFavorited = false
        }
      }
    }
    else {
      _ = coreDataService.save(symbol: symbol)
      isFavorited = true
    }
  }

  /// To fill the favorite star if the user already
  /// save the rate in Core Data.
  ///
  func checkForSaved(_ symbol: String) {
    let fetchedRates = coreDataService.fetch()
    for i in fetchedRates {
      if i.symbol == symbol {
        isFavorited = true
        break
      }
      else {
        isFavorited = false
      }
    }
  }
}

// MARK: - Alert
extension MarketViewModel {
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

  /// Show alert to user when there is an issue saving
  /// a rate in Core Data Rate as favorite.
  ///
  func showCoreDataErrorAlert() -> Alert {
    Alert(title: Text(Localized.internalErrorTitle),
          message: Text(Localized.internalErrorMessage),
          dismissButton: .cancel {
            self.showCoreDataError = false
      })
  }

  /// Show alert to user when Core Data crash while
  /// setting up the container at app launch.
  ///
  func showCoreDataCrashAlert() -> Alert {
    Alert(title: Text(Localized.internalCrashTitle),
          message: Text(Localized.internalCrashMessage),
          dismissButton: .cancel {
            self.showCoreDataCrash = false
      })
  }

  /// Trigger Core Data Error.
  ///
  func triggerCoreDataError() {
    showCoreDataError = true
  }

  /// Trigger Core Data Crash.
  ///
  func triggerCoreDataCrash() {
    showCoreDataCrash = true
  }
}

// MARK: - NumberFormatter
extension MarketViewModel {
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
