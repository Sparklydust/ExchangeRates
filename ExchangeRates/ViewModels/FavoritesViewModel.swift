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

  // Models
  @ObservedObject var favoritesTimer = ExchangeTimer()
  var coreDataService = CoreDataService()

  // UI Levers
  @Published var showNetworkAlert = false
  @Published var showTryAgainButton = false
  @Published var isLoading = false

  // Data
  @Published var oldFavoriteRates = [String: Double]()
  @Published var newFavoriteRates = [String: Double]()
}

extension FavoritesViewModel {
  /// Download favorites live rates from the currency layer api.
  ///
  /// Fetch rates and trimmer them to show only user
  /// favorites. On error, trigger Alert to the user.
  ///
  func downloadFavoritesLiveRates() {
    let fetchRates = coreDataService.fetch()
    guard !fetchRates.isEmpty else {
      showActivityIndicator(false)
      return
    }

    NetworkRequest<RatesData>(.live).download()
      .sink(
        receiveCompletion: { [weak self] completion in
          guard let self = self else { return }
          self.handle(completion) },
        receiveValue: { [weak self] data in
          guard let self = self else { return }
          withAnimation(.easeInOut) {
            self.handleFavoritesRate(data) } })
      .store(in: &subscriptions)
  }

  /// Perform actions on the rates data coming
  /// from the api and trim only the favorites
  /// one.
  ///
  /// - Parameters:
  ///     - data: fetched api rates data
  ///
  func handleFavoritesRate(_ data: RatesData) {
    resetOldNewFavoriteRates()
    trimCoreDataSavedRates(data)
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

  /// Trim fetched data from api to only populate the one
  /// saved in CoreData.
  ///
  /// - Parameters:
  ///     - data: fetched api rates data
  ///
  func trimCoreDataSavedRates(_ data: RatesData) {
    let fetchedRates = coreDataService.fetch()

    for i in data.quotes {
      for j in fetchedRates {
        if i.key == j.symbol {
          newFavoriteRates.updateValue(i.value, forKey: i.key)
        }
      }
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

  /// Reset old Favorites Rates with new favorites
  /// ones and empty new Favorites before receiving
  ///  values from api call.
  ///
  func resetOldNewFavoriteRates() {
    oldFavoriteRates = newFavoriteRates
    newFavoriteRates = [String: Double]()
  }
}

// MARK: - CoreData
extension FavoritesViewModel {
  /// Delete saved rate from user action in table view
  /// by swiping the cell or using the edit button.
  ///
  /// - Parameters:
  ///     - savedRates: CoreData saved Rate models
  ///     - indexSet: position of the model in CoreData
  ///
  func deleteFavorite(from savedRates: FetchedResults<Rate>, at indexSet: IndexSet) {
    for i in indexSet {
      let rate = savedRates[i]
      coreDataService.delete(rate: rate)
      downloadFavoritesLiveRates()
    }
  }
}

// MARK: - Timer
extension FavoritesViewModel {
  /// Connect favorites timer to start network call at regular
  /// interval.
  ///
  func connectUpstreamFavoritesTimer() {
    showActivityIndicator(true)
    downloadFavoritesLiveRates()
    favoritesTimer.connect()
  }

  /// User cancel timer from Alert to stop making network
  /// request in FavoriteView.
  ///
  func cancelUpstreamFavoritesTimer() {
    showActivityIndicator(false)
    showTryAgainButton = true
    disconnectUpstreamFavoritesTimer()
  }

  /// Disconnect Timer to stop making network request in
  /// FavoriteView.
  ///
  func disconnectUpstreamFavoritesTimer() {
    favoritesTimer.disconnect()
  }

  /// User trigger Timer again from Alert to restart
  /// network request.
  ///
  func tryAgainUpstreamFavoritesTimer() {
    showTryAgainButton = false
    connectUpstreamFavoritesTimer()
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
              self.cancelUpstreamFavoritesTimer() }},
          secondaryButton: .default(Text(Localized.tryAgain)) {
            self.tryAgainUpstreamFavoritesTimer()
      })
  }
}
