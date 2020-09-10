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

  var body: some View {
    Text("FavoritesView")
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
