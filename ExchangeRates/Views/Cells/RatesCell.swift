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

  @State var symbol: String
  @State var price: Double
  @State var rateArrow: Image
  @State var rateColor: Color
  @State var currency = "USD"

  @State var isPriceNeutral = true

  var body: some View {
    HStack {
      Text(symbol)
        .font(.headline)
        .fontWeight(.medium)
        .padding(.leading, 8)

      Spacer()

      HStack(alignment: .center, spacing: 16) {
        Text(format(value: price, currency: currency))
          .font(.headline)
          .fontWeight(.medium)

        rateArrow
      }
      .foregroundColor(rateColor)
      .padding(.trailing, 8)
    }
    .padding(.vertical, 16)
  }
}

extension RatesCell {
  func format(value: Double, currency: String) -> String {

    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = true
    formatter.locale = .current
    formatter.numberStyle = .currency
    formatter.currencyCode = currency

    guard let formattedValue = formatter.string(from: NSNumber(value: value)) else {
      return String()
    }
    return formattedValue
  }
}

// Previews
struct RatesCell_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      RatesCell(symbol: "AUSDUSD",
                price: 234.34,
                rateArrow: Image(systemName: "arrow.up"),
                rateColor: .green)

      RatesCell(symbol: "AUSDUSD",
                price: 234.34,
                rateArrow: Image(systemName: "arrow.down"),
                rateColor: .red)
        .preferredColorScheme(.dark)
    }
  }
}
