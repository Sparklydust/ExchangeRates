//
//  DetailsView.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 11/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import SwiftUI

//  MARK: DetailsView
/// Populate details of a single rate.
///
struct DetailsView: View {

  @EnvironmentObject var viewModel: RatesViewModel

  @State var symbol: String
  @State var price: Double

  @State var isFavorited = false

  var body: some View {
    VStack {
      DetailsTitle(symbol: symbol,
                   price: price)
      .padding(32)

      Spacer()
    }
    .navigationBarTitle(Localized.details, displayMode: .large)
    .navigationBarItems(trailing: Button(action: {}) {
      Image(systemName: isFavorited ? "star.fill" : "star")
        .resizable()
        .frame(width: 28, height: 28)
        .foregroundColor(.yellow) }
    )
      .alert(isPresented: $viewModel.showCoreDataError) {
        self.viewModel.showCoreDataErrorAlert()
    }
  }
}

// MARK: - Previews
struct DetailsView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      DetailsView(symbol: "AUSDUSD",
                  price: 234.34)

      DetailsView(symbol: "AUSDUSD",
                  price: 234.34)
        .preferredColorScheme(.dark)
    }
  }
}
