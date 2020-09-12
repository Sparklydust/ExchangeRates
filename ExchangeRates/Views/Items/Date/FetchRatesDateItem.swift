//
//  FetchRatesDateItem.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 11/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import SwiftUI

//  MARK: FetchRatesDateItem
/// Populate the date and time of the last
/// fetch rates from api call.
///
struct FetchRatesDateItem: View {

  @EnvironmentObject var viewModel: RatesViewModel

  var body: some View {
    HStack(alignment: .center) {
      Spacer()
      Text("\(viewModel.date.formatted())")
        .font(.footnote)
        .fontWeight(.medium)
      Spacer()
    }
    .padding(.vertical, 8)
  }
}

// MARK: Previews
struct FetchRatesDateItem_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      FetchRatesDateItem()

      FetchRatesDateItem()
        .preferredColorScheme(.dark)
    }
  }
}
