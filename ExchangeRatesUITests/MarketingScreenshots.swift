//
//  MarketingScreenshots.swift
//  MarketingScreenshots
//
//  Created by Roland Lariotte on 13/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import XCTest

//  MARK: MarketingScreenshots
/// UITests for taking marketing screenshots to populate
/// on the AppStore.
///
/// Edit the scheme test to use Marketing.xctestplan.
/// Fake data must be provided in oldRates and oldFavoriteRates
/// variables set in the RatesViewModel and FavoritesViewModel.
/// Do not forget to comment out resetOldNewRates() and
/// resetOldNewFavoriteRates() to avoid deleting the fake data.
///
class MarketingScreenshots: XCTestCase {

  var app: XCUIApplication!

  override func setUpWithError() throws {
    try super.setUpWithError()
    continueAfterFailure = true
    app = XCUIApplication()
    app.launch()
  }

  override func tearDownWithError() throws {
    app.terminate()
    try super.tearDownWithError()
  }
}

// MARK: - Screenshots UITest action
extension MarketingScreenshots {
  func testMarketingScreenshots_01_RatesView_DetailsView_FavoritesView() {

    sleep(5)
    takeSaveScreenshot(name: "1.Rates")

    app.tables
      .cells
      .element(boundBy: 1)
      .tap()

    sleep(5)
    takeSaveScreenshot(name: "2.DetailsView")

    app.tabBars
      .buttons
      .element(boundBy: 1)
      .tap()

    sleep(5)
    takeSaveScreenshot(name: "3.FavoritesView")
  }
}

// MARK: - Screenshots action saver
extension MarketingScreenshots {
  /// Take screenshot and save as attachment that
  /// can be retrieve in the navigation panel.
  /// Command+9 and find the file by clicking on
  /// Test and expand the arrow.
  ///
  private func takeSaveScreenshot(name: String) {
    let screenshot = XCUIScreen.main.screenshot()

    let attachment = XCTAttachment(
      uniformTypeIdentifier: "public.png",
      name: "screenshot-\(name)-\(UIDevice.current.name).png",
      payload: screenshot.pngRepresentation,
      userInfo: nil)

    attachment.lifetime = .keepAlways

    add(attachment)
  }
}
