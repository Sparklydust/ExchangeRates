//
//  RatesViewModelTests.swift
//  ExchangeRatesTests
//
//  Created by Roland Lariotte on 14/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import XCTest
import SwiftUI
import Combine
@testable import ExchangeRates

class RatesViewModelTests: XCTestCase {

  var sut: RatesViewModel!
  var subscriptions: Set<AnyCancellable>!

  var mockCoreDataService: CoreDataService!
  var mockCoreDataStack: CoreDataStack!

  var fakeRates: [String: Double]!
  var fakeRatesData: RatesData!

  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = RatesViewModel()
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
  
  func testRatesViewModel_networkErrorComesFromAPICall_triggersNetworkAlertToUser() throws {
    let fakeCompletion = Subscribers.Completion<NetworkError>.failure(NetworkError.invalidResponse)

    sut.handle(fakeCompletion)

    XCTAssertTrue(sut.showNetworkAlert)
  }

  func testRatesViewModel_showsActivityIndicatorSetToTrue_isLoadingEqualTrue() throws {
    sut.showActivityIndicator(true)

    XCTAssertTrue(sut.isLoading)
  }

  func testRatesViewModel_showsActivityIndicatorSetToFalse_isLoadingEqualFalse() throws {
    sut.showActivityIndicator(false)

    XCTAssertFalse(sut.isLoading)
  }

  func testRatesViewModel_newRatesDataComesFromAPI_oldRatesEqualNewRatesAndNewRatesEqualDataFromAPI() throws {
    sut.newRates = fakeRates

    sut.setupOldRatesNewRates(with: fakeRatesData)

    XCTAssertEqual(sut.oldRates, fakeRates)
    XCTAssertEqual(sut.newRates, fakeRatesData.quotes)
    XCTAssertEqual(sut.rates, fakeRatesData)
  }

  func testRatesViewModel_resetOldAndNewRates_oldRatesEqualNewRatesAndNewRatesIsEmpty() throws {
    let expectedNewRates = [String: Double]()
    let expectedOldRates = fakeRates

    sut.newRates = fakeRates
    sut.oldRates = [String: Double]()

    sut.resetOldNewRates()

    XCTAssertEqual(expectedNewRates, sut.newRates)
    XCTAssertEqual(expectedOldRates, sut.oldRates)
  }

  func testRatesViewModel_methodToSetupCurrencyIsCalled_sutCurrencyEqualAPIDataSourceValue() throws {
    let expected = fakeRatesData.source
    sut.rates = fakeRatesData

    sut.setupCurrency()

    XCTAssertEqual(expected, sut.currency)
  }

  func testRatesViewModel_userTapOnStarToSaveAFavoriteRate_twoRatesAreSavedInCoreData() throws {
    let fakeData = "USDAFN"
    _ = mockCoreDataService.save(symbol: "USDAED")

    sut.favoriteStarIsTapped(for: fakeData)

    let fetchRates = mockCoreDataService.fetch()
    let expected = 2

    XCTAssertEqual(expected, fetchRates.count)
  }

  func testRatesViewModel_userTapOnStarToDeleteAFavoriteRate_savedRatesOnDeviceLeftIsOneObjectInCoreData() throws {
    let fakeData = "USDAFN"
    _ = mockCoreDataService.save(symbol: "USDAED")
    _ = mockCoreDataService.save(symbol: fakeData)

    sut.isFavorited = true

    sut.favoriteStarIsTapped(for: fakeData)

    let fetchRates = mockCoreDataService.fetch()
    let expected = 1

    XCTAssertEqual(expected, fetchRates.count)
  }

  func testRatesViewModel_symbolIsSavedInCoreData_methodCheckIfDataIsInDevice_returnTrue() throws {
    let fakeData = "USDAFN"
    _ = mockCoreDataService.save(symbol: fakeData)

    sut.checkForSaved(fakeData)

    XCTAssertTrue(sut.isFavorited)
  }

  func testRatesViewModel_symbolIsNotSavedInCoreData_methodCheckIfDataIsInDevice_returnFalse() throws {
    let fakeData = "USDAFN"

    sut.checkForSaved(fakeData)

    XCTAssertFalse(sut.isFavorited)
  }

  func testRatesViewModel_triggerCoreDataError_showCoreDataErrorValueIsTrue() throws {
    sut.triggerCoreDataError()

    XCTAssertTrue(sut.showCoreDataError)
  }

  func testRatesViewModel_triggerCoreDataCrash_showCoreDataCrashValueIsTrue() throws {
    sut.triggerCoreDataCrash()

    XCTAssertTrue(sut.showCoreDataCrash)
  }

  func testRatesViewModel_valueFromRatesQuotesIsFormattedToCurrency_returnDoubleWithCurrencyFormat() throws {
    let fakePrice = 23.45

    let result = sut.populateFormatted(fakePrice)
    let expected = "$23.45"

    XCTAssertEqual(expected, result)
  }
}
