//
//  FavoritesViewModel.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 11/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import SwiftUI
import Combine

//  MARK: FavoritesViewModel
/// Logic handler for the FavoritesView.
///
final class FavoritesViewModel: ObservableObject {
  
  private var subscriptions = Set<AnyCancellable>()

  var coreDataService = CoreDataService()

  // UI Levers
  @Published var showNetworkAlert = false
  @Published var showTryAgainButton = false
  @Published var isLoading = false

  // Timer
  @Published var timer = Timer
    .publish(every: 61, on: .main, in: .common)
    .autoconnect()

  // Data
  @Published var newFavoriteRates = [String: Double]()
  @Published var oldFavoriteRates = [String: Double]()
}

extension FavoritesViewModel {
  /// Download favorites live rates from the currency layer api.
  ///
  /// Fetch rates and trimmer them to show only user
  /// favorites. On error, trigger Alert to the user.
  ///
  func downloadFavoritesLiveRates() {
    let fetchRates = coreDataService.fetch()
    guard !fetchRates.isEmpty else { return }

    showActivityIndicator(true)
    NetworkRequest<RatesData>(.live).download()
      .sink(
        receiveCompletion: { [weak self] completion in
          guard let self = self else { return }
          self.handle(completion) },
        receiveValue: { [weak self] data in
          guard let self = self else { return }
          withAnimation(.easeInOut) {
            self.trimCoreDataSavedRates(data) } })
      .store(in: &subscriptions)
  }

  /// Trim fetch data from api to only populate the one
  /// saved in Core Data.
  ///
  func trimCoreDataSavedRates(_ data: RatesData) {
    resetOldFavoriteRatesNewFavoriteRates()
    let fetchedRates = coreDataService.fetch()

    for i in data.quotes {
      for j in fetchedRates {
        if i.key == j.symbol {
          newFavoriteRates.updateValue(i.value, forKey: i.key)
        }
      }
    }
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

  /// Reset old Favorites Rates with new favorites
  /// ones and empty new Favorites to receive values
  /// from api call.
  ///
  func resetOldFavoriteRatesNewFavoriteRates() {
    oldFavoriteRates = newFavoriteRates
    newFavoriteRates = [String: Double]()
  }
}

// MARK: - Timer
extension FavoritesViewModel {
  /// User cancel timer from Alert to stop making network
  /// request in FavoriteView.
  ///
  func cancelUpstreamTimer() {
    self.isLoading = false
    showTryAgainButton = true
    disconnectUpstreamTimer()
  }

  /// Disconnect Timer to stop making network request in
  /// FavoriteView.
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
    downloadFavoritesLiveRates()
  }
}

// MARK: - Alert
extension FavoritesViewModel {
  /// Show alert to user when network error is triggered.
  ///
  /// User has the choice to cancel or try again api call.
  ///
  func showNetworkErrorAlert() -> Alert {
    Alert(title: Text(Localized.networkErrorTitle),
          message: Text(Localized.favoritesDataErrorMessage),
          primaryButton: .cancel {
            withAnimation(.easeInOut) {
              self.cancelUpstreamTimer() }},
          secondaryButton: .default(Text(Localized.tryAgain)) {
            self.tryAgainUpstreamTimer()
      })
  }
}
