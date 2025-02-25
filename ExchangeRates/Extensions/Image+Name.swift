//
//  Image+Name.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 09/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import SwiftUI

//  MARK: Image
/// Extension to retrieve all images by name.
///
/// Images are either inside the Assets.xcassets
/// or are systemName image from the SFSymbol mac app.
///
extension Image {

  static let rates = Image("market.up")

  static let favorites = Image(systemName: "star")

  static let arrowUp = Image(systemName: "arrow.up")

  static let arrowDown = Image(systemName: "arrow.down")

  static let arrowUpDown = Image(systemName: "arrow.up.and.down")
}
