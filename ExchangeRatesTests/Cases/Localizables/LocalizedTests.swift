//
//  LocalizedTests.swift
//  ExchangeRatesTests
//
//  Created by Roland Lariotte on 14/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import XCTest
@testable import ExchangeRates

class LocalizedTests: XCTestCase {

  func testLocalized_checkForKeyTranslationMatch_ratesReturnTrue() throws {
    XCTAssertEqual("rates", Localized.rates)
  }

  func testLocalized_checkForKeyTranslationMatch_favoritesReturnTrue() throws {
    XCTAssertEqual("favorites", Localized.favorites)
  }

  func testLocalized_checkForKeyTranslationMatch_detailsReturnTrue() throws {
    XCTAssertEqual("details", Localized.details)
  }

  func testLocalized_checkForKeyTranslationMatch_tryAgainReturnTrue() throws {
    XCTAssertEqual("tryAgain", Localized.tryAgain)
  }

  func testLocalized_checkForKeyTranslationMatch_networkErrorTitleReturnTrue() throws {
    XCTAssertEqual("networkErrorTitle", Localized.networkErrorTitle)
  }

  func testLocalized_checkForKeyTranslationMatch_internalErrorTitleReturnTrue() throws {
    XCTAssertEqual("internalErrorTitle", Localized.internalErrorTitle)
  }

  func testLocalized_checkForKeyTranslationMatch_internalCrashTitleReturnTrue() throws {
    XCTAssertEqual("internalCrashTitle", Localized.internalCrashTitle)
  }

  func testLocalized_checkForKeyTranslationMatch_networkErrorMessageReturnTrue() throws {
    XCTAssertEqual("networkErrorMessage", Localized.networkErrorMessage)
  }

  func testLocalized_checkForKeyTranslationMatch_internalErrorMessageReturnTrue() throws {
    XCTAssertEqual("internalErrorMessage", Localized.internalErrorMessage)
  }

  func testLocalized_checkForKeyTranslationMatch_internalCrashMessageReturnTrue() throws {
    XCTAssertEqual("internalCrashMessage", Localized.internalCrashMessage)
  }

  func testLocalized_checkForKeyTranslationMatch_favoritesDataErrorMessageReturnTrue() throws {
    XCTAssertEqual("favoritesDataErrorMessage", Localized.favoritesDataErrorMessage)
  }

  func testLocalized_checkForKeyTranslationMatch_chooseFavoritesReturnTrue() throws {
    XCTAssertEqual("chooseFavorites", Localized.chooseFavorites)
  }
}
