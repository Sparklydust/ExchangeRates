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

  static let market = Image("market.up")

  static let favorites = Image(systemName: "star")
}
