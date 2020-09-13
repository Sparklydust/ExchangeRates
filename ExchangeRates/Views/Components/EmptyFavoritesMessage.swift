//
//  EmptyFavoritesMessage.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 11/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import SwiftUI

//  MARK: EmptyFavoritesMessage
/// Populate message to user on an Empty FavoritesView Tab.
///
struct EmptyFavoritesMessage: View {
  
  var body: some View {
    ZStack {
      Text(Localized.chooseFavorites)
        .font(.headline)
        .fontWeight(.medium)
        .padding(32)
        .multilineTextAlignment(.center)
    }
  }
}

// MARK: - Previews
struct EmptyFavoritesMessage_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      EmptyFavoritesMessage()

      EmptyFavoritesMessage()
        .preferredColorScheme(.dark)
    }
  }
}
