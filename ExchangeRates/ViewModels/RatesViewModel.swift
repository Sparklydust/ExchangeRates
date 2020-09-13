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
/// Logic handler for the RatesView and DetailsView.
///
final class RatesViewModel: ObservableObject {

  private var subscriptions = Set<AnyCancellable>()

  // Models
  @ObservedObject var ratesTimer = ExchangeTimer()
  var coreDataService = CoreDataService()

  // UI Levers
  @Published var showNetworkAlert = false
  @Published var showTryAgainButton = false
  @Published var isLoading = false
  @Published var showCoreDataError = false
  @Published var showCoreDataCrash = false
  @Published var isFavorited = false

  // Data
  @Published var date = Date()
  @Published var rates = RatesData()
  @Published var oldRates = [String: Double]()
  @Published var newRates = [String: Double]()
  @Published var currency = String()
}

// MARK: - Network call
extension RatesViewModel {
  /// Download live rates from the currency layer api.
  ///
  /// Fetch new rates on success and reset old saved rates.
  /// On error, trigger Alert to the user.
  ///
  func downloadLiveRates() {
    NetworkRequest<RatesData>(.live).download()
      .sink(
        receiveCompletion: { [weak self] completion in
          guard let self = self else { return }
          self.handle(completion) },
        receiveValue: { [weak self] data in
          guard let self = self else { return }
          withAnimation(.easeInOut) {
            self.handleRates(data) } })
      .store(in: &subscriptions)
  }

  /// Perform actions on the rates data coming
  /// from the api.
  ///
  /// - Parameters:
  ///     - data: fetched api rates data
  ///
  func handleRates(_ data: RatesData) {
    setupOldRatesNewRates(with: data)
    setupCurrency()
    convertTimestampToDate()
  }

  /// Perform actions on the end of the api call
  /// when finished or on failure.
  ///
  /// - Parameters:
  ///     - completion: Network call publisher completion
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
  /// - Parameters:
  ///     - action: Boolean value
  ///
  func showActivityIndicator(_ action: Bool) {
    isLoading = action
  }

  /// Action that setup old rates and new rates data
  /// in Views.
  ///
  /// - Warning: Order of the action must be kept
  /// this way in the method.
  ///
  /// - Parameters:
  ///     - data: rates data fetch from api call.
  ///
  func setupOldRatesNewRates(with data: RatesData) {
    resetOldNewRates()
    newRates = data.quotes
    rates = data
  }

  /// Reset old Rates with new rates and empty
  /// new rates to set new values from api call.
  ///
  func resetOldNewRates() {
    oldRates = newRates
    newRates = [String: Double]()
  }

  /// Setup the main currency exchange rates to
  /// the user coming from the api.
  ///
  func setupCurrency() {
    currency = rates.source
  }

  /// Set the color of the rate.
  ///
  /// Comparewith the old one fetched from api. Set to
  /// blue for first api call or if value has not changed
  /// from last call.
  ///
  func colorFinder(for data: Dictionary<String, Double>.Element) -> Color {
    for o in oldRates {
      if o.key == data.key
        && o.value > data.value {
        return .red
      }
      else if o.key == data.key
        && o.value < data.value {
        return .green
      }
    }
    return .blue
  }

  /// Set the arrow of the rate.
  ///
  /// Comparing with the old one fetched from api.Set
  /// to arrowUpDown for first api call or if value has
  /// not changed from last call.
  ///
  func arrowFinder(for data: Dictionary<String, Double>.Element) -> Image {
    for o in oldRates {
      if o.key == data.key
        && o.value > data.value {
        return .arrowDown
      }
      else if o.key == data.key
        && o.value < data.value {
        return .arrowUp
      }
    }
    return .arrowUpDown
  }
}

// MARK: - Timer
extension RatesViewModel {
  /// Connect rates timer to start network call at regular
  /// interval.
  ///
  func connectUpstreamRatesTimer() {
    showActivityIndicator(true)
    downloadLiveRates()
    ratesTimer.connect()
  }

  /// User cancel timer from Alert to stop making network
  /// request in RatesView.
  ///
  func cancelUpstreamRatesTimer() {
    self.isLoading = false
    showTryAgainButton = true
    disconnectUpstreamRatesTimer()
  }

  /// Disconnect Timer to stop making network request in
  /// RatesView.
  ///
  func disconnectUpstreamRatesTimer() {
    ratesTimer.disconnect()
  }

  /// User trigger Timer again from Alert to restart
  /// network request.
  ///
  func tryAgainUpstreamRatesTimer() {
    showTryAgainButton = false
    connectUpstreamRatesTimer()
  }

  /// Convert timestamp value to a readable Date format.
  ///
  func convertTimestampToDate() {
    _ = date.addingTimeInterval(TimeInterval(rates.timestamp))
  }
}

// MARK: - CoreData
extension RatesViewModel {
  /// User favorites a rate in Details view and save it in
  /// Core Data.
  ///
  /// - Parameters:
  ///     - symbol: rate symbol shown in the DetailsView
  ///
  func favoriteStarIsTapped(for symbol: String) {
    if isFavorited {
      let fetchedRates = coreDataService.fetch()
      for i in fetchedRates {
        if i.symbol == symbol {
          coreDataService.delete(rate: i)
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
  /// - Parameters:
  ///     - symbol: rate symbol shown in the DetailsView
  ///
  func checkForSaved(_ symbol: String) {
    isFavorited = false
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
              self.cancelUpstreamRatesTimer() }},
          secondaryButton: .default(Text(Localized.tryAgain)) {
            self.tryAgainUpstreamRatesTimer()
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
extension RatesViewModel {
  /// Format the price and currency depending
  /// on user localization.
  ///
  /// - Parameters:
  ///     - price: rate price fetched from api
  ///
  func populateFormatted(_ price: Double) -> String {

    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = true
    formatter.locale = .current
    formatter.maximumFractionDigits = 6
    formatter.numberStyle = .currency
    formatter.currencyCode = currency

    guard let formattedValue = formatter.string(from: NSNumber(value: price)) else {
      return String()
    }
    return formattedValue
  }
}
