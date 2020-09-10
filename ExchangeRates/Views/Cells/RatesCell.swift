//
//  RatesCell.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 10/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import SwiftUI

//  MARK: RatesCell
/// Populates live rates with title and values as well as
/// a button to save rates to favorites
struct RatesCell: View {

  @EnvironmentObject var viewModel: RatesViewModel

  @State var symbol: String
  @State var price: Double

  @State var isPriceNeutral = true

  var body: some View {
    HStack {
      Text(symbol)
        .font(.headline)
        .fontWeight(.medium)
        .padding(.leading, 8)

      Spacer()

      HStack(alignment: .center, spacing: 16) {
        Text(viewModel.populateFormatted(price))
          .font(.headline)
          .fontWeight(.medium)

        viewModel.rateArrow
      }
      .foregroundColor(viewModel.rateColor)
      .padding(.trailing, 8)
    }
    .padding(.vertical, 16)
  }
}

// Previews
struct RatesCell_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      RatesCell(symbol: "AUSDUSD",
                price: 234.34)

      RatesCell(symbol: "AUSDUSD",
                price: 234.34)
        .preferredColorScheme(.dark)
    }
  }
}
