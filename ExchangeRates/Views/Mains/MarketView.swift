//
//  MarketView.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 09/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import SwiftUI

//  MARK: MarketView
/// Populates the exchanges rates in real time.
///
struct MarketView: View {

  var body: some View {
    Text("MarketView")
  }
}

// MARK: - Previews
struct MarketView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      MarketView()

      MarketView()
        .preferredColorScheme(.dark)
    }
  }
}
