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

  @State var data: Dictionary<String, Double>.Element

  var body: some View {
    VStack {
      DetailsTitle(data: data)
      .padding(32)

      Spacer()
    }
    .navigationBarTitle(Localized.details, displayMode: .large)
    .navigationBarItems(trailing: Button(action: {
      self.viewModel.favoriteStarIsTapped(for: self.data.key)
    }) {
      Image(systemName: viewModel.isFavorited ? "star.fill" : "star")
        .resizable()
        .frame(width: 28, height: 28)
        .foregroundColor(.yellow) }
    )
      .alert(isPresented: $viewModel.showCoreDataError) {
        self.viewModel.showCoreDataErrorAlert()
    }
    .onAppear {
      self.viewModel.checkForSaved(self.data.key)
    }
  }
}

// MARK: - Previews
struct DetailsView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      DetailsView(data: ("AUSDUSD", 234.34))

      DetailsView(data: ("AUSDUSD", 234.34))
        .preferredColorScheme(.dark)
    }
  }
}
