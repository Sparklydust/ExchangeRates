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

  @State var data: Dictionary<String, Double>.Element
  
  var body: some View {
    VStack(alignment: .center, spacing: 16) {
      Text(data.key)
        .font(.title)
        .fontWeight(.bold)

      HStack(alignment: .center, spacing: 8) {
        Text(viewModel.populateFormatted(data.value))
          .font(.title)
          .fontWeight(.bold)
          .minimumScaleFactor(0.1)
          .lineLimit(1)
          .layoutPriority(1)

        self.viewModel.arrowFinder(for: data)
          .font(Font.title.weight(.medium))
      }
      .foregroundColor(self.viewModel.colorFinder(for: data))

      Spacer()
    }
  }
}

// MARK: - Preuviews
struct DetailsTitle_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      DetailsTitle(data: ("AUSDUSD", 234.34))

      DetailsTitle(data: ("AUSDUSD", 234.34))
        .preferredColorScheme(.dark)
    }
  }
}
