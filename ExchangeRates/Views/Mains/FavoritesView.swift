//
//  FavoritesView.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 09/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import SwiftUI

//  MARK: FavoritesView
/// Populates user favorites saved rates.
///
struct FavoritesView: View {

  @EnvironmentObject var viewModel: FavoritesViewModel

  @FetchRequest(
    entity: Rate.entity(),
    sortDescriptors: [NSSortDescriptor(keyPath: \Rate.symbol, ascending: true)])
  var savedRates: FetchedResults<Rate>

  var body: some View {
    ZStack {
      if savedRates.isEmpty {
        EmptyFavoritesMessage()
      }
      else {
        List(savedRates, id: \.self) { rate in
          Text(rate.symbol ?? "unknow")
        }
      }
    }
    .navigationBarTitle(Localized.favorites, displayMode: .large)
  }
}

// MARK: - Previews
struct FavoritesView_Previews: PreviewProvider {

  static var previews: some View {
    Group {
      FavoritesView()

      FavoritesView()
        .preferredColorScheme(.dark)
    }
  }
}
