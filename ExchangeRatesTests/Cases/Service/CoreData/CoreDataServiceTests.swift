//
//  CoreDataServiceTests.swift
//  ExchangeRatesTests
//
//  Created by Roland Lariotte on 11/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import XCTest
import CoreData
@testable import ExchangeRates

class CoreDataServiceTests: XCTestCase {

  var sut: CoreDataService!
  var mockCoreDataStack: CoreDataStack!

  override func setUpWithError() throws {
    try super.setUpWithError()
    mockCoreDataStack = MockCoreDataStack()
    sut = CoreDataService(managedObjectContext: mockCoreDataStack.viewContext, coreDataStack: mockCoreDataStack)
  }

  override func tearDownWithError() throws {
    sut = nil
    mockCoreDataStack = nil
    try super.tearDownWithError()
  }

  func testCoreDataService_saveNewSymbolInCoreData_returnTrueWithTheEURSymbolSaved() throws {
    let expected = "EUR"

    let rate = sut.save(symbol: "EUR")

    XCTAssertTrue(rate?.symbol == expected)
  }

  func testCoreDataService_saveTwoRatesInCoreData_fetchSavedDataReturnCountTwo() throws {
    _ = sut.save(symbol: "EUR")
    _ = sut.save(symbol: "USD")

    let fetchedRates = sut.fetch()

    XCTAssertNotNil(fetchedRates)
    XCTAssertEqual(fetchedRates.count, 2)
  }

  func testCoreDataService_SaveOneRateToDeleteIt_DeleteRateReturnEmptyCoreData() throws {
    _ = sut.save(symbol: "EUR")

    var fetchedRate = sut.fetch()
    XCTAssertNotNil(fetchedRate)

    sut.delete(rate: fetchedRate[0])
    fetchedRate = sut.fetch()

    XCTAssertEqual(fetchedRate, [])
  }
}
