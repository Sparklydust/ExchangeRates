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

  @EnvironmentObject var viewModel: MarketViewModel

  @State var data: Dictionary<String, Double>.Element

  @State var isPriceNeutral = true

  var body: some View {
    HStack {
      Text(data.key)
        .font(.headline)
        .fontWeight(.medium)
        .padding(.leading, 8)

      Spacer()

      HStack(alignment: .center, spacing: 16) {
        Text(viewModel.populateFormatted(data.value))
          .font(.headline)
          .fontWeight(.medium)
          .minimumScaleFactor(0.1)
          .lineLimit(1)
          .layoutPriority(1)

        self.viewModel.arrowFinder(for: data)
      }
      .foregroundColor(self.viewModel.colorFinder(for: data))
      .padding(.trailing, 8)
    }
    .padding(.vertical, 16)
  }
}

// Previews
struct RatesCell_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      RatesCell(data: ("AUSDUSD", 234.34))

      RatesCell(data: ("AUSDUSD", 234.34))
        .preferredColorScheme(.dark)
    }
  }
}
