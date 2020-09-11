//
//  DetailsTitle.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 11/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import SwiftUI

//  MARK: DetailsTitle
/// Populate rate symbol and price with arrow.up or .down
///
struct DetailsTitle: View {

  @EnvironmentObject var viewModel: MarketViewModel

  @State var symbol: String
  @State var price: Double
  
  var body: some View {
    HStack {
      Text(symbol)
        .font(.title)
        .fontWeight(.bold)

      Spacer()

      HStack(alignment: .center, spacing: 12) {
        Text(viewModel.populateFormatted(price))
          .font(.title)
          .fontWeight(.bold)
          .minimumScaleFactor(0.001)
          .lineLimit(1)

        viewModel.detailRateArrow
          .font(Font.title.weight(.medium))
      }
      .foregroundColor(viewModel.detailRateColor)
    }
  }
}

// MARK: - Preuviews
struct DetailsTitle_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      DetailsTitle(symbol: "AUSDUSD",
                   price: 234.34)

      DetailsTitle(symbol: "AUSDUSD",
                   price: 234.34)
        .preferredColorScheme(.dark)
    }
  }
}
