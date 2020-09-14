//
//  FavoritesViewModelTests.swift
//  ExchangeRatesTests
//
//  Created by Roland Lariotte on 14/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import XCTest
import Combine
@testable import ExchangeRates

class FavoritesViewModelTests: XCTestCase {

  var sut: FavoritesViewModel!
  var subscriptions: Set<AnyCancellable>!

  var mockCoreDataService: CoreDataService!
  var mockCoreDataStack: CoreDataStack!

  var fakeRates: [String: Double]!
  var fakeRatesData: RatesData!

  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = FavoritesViewModel()
    subscriptions = Set<AnyCancellable>()

    mockCoreDataStack = MockCoreDataStack()
    mockCoreDataService = CoreDataService(managedObjectContext: mockCoreDataStack.viewContext, coreDataStack: mockCoreDataStack)
    sut.coreDataService = mockCoreDataService

    fakeRates = ["USDAED": 3.672901,
                 "USDAFN": 76.589716,
                 "USDALL": 105.249848]
    fakeRatesData = RatesData(success: true,
                              terms: "https://test.com/terms",
                              privacy: "https://test.com/privacy",
                              timestamp: 1600015154,
                              source: "USD",
                              quotes: ["USDAED": 3.672901,
                                       "USDAFN": 76.589716,
                                       "USDALL": 105.249848,
                                       "USDAMD": 487.670403])
  }

  override func tearDownWithError() throws {
    fakeRatesData = nil
    fakeRates = nil
    mockCoreDataService = nil
    mockCoreDataStack = nil
    subscriptions = []
    sut = nil
    try super.tearDownWithError()
  }

  func testFavoritesViewModel_networkErrorComesFromAPICall_triggersNetworkAlertToUser() throws {
    let fakeCompletion = Subscribers.Completion<NetworkError>.failure(NetworkError.invalidResponse)

    sut.handle(fakeCompletion)

    XCTAssertTrue(sut.showNetworkAlert)
  }

  func testFavoritesViewModel_TwoSymbolsAreSavedInDevice_TrimCoreDataUpdateAndSaveTheseValuesInNewFavoriteRates() throws {
    _ = mockCoreDataService.save(symbol: "USDAED")
    _ = mockCoreDataService.save(symbol: "USDAFN")

    sut.trimCoreDataSavedRates(fakeRatesData)

    let expected = 2

    XCTAssertEqual(expected, sut.newFavoriteRates.count)
  }

  func testFavoritesViewModel_showsActivityIndicatorSetToTrue_isLoadingEqualTrue() throws {
    sut.showActivityIndicator(true)

    XCTAssertTrue(sut.isLoading)
  }

  func testFavoritesViewModel_showsActivityIndicatorSetToFalse_isLoadingEqualFalse() throws {
    sut.showActivityIndicator(false)

    XCTAssertFalse(sut.isLoading)
  }

  func testFavoritesViewModel_resetOldAndNewRates_oldRatesEqualNewRatesAndNewRatesIsEmpty() throws {
    let expectedNewRates = [String: Double]()
    let expectedOldRates = fakeRates

    sut.newFavoriteRates = fakeRates
    sut.oldFavoriteRates = [String: Double]()

    sut.resetOldNewFavoriteRates()

    XCTAssertEqual(expectedNewRates, sut.newFavoriteRates)
    XCTAssertEqual(expectedOldRates, sut.oldFavoriteRates)
  }
}
