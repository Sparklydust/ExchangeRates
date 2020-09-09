//
//  ContentView.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 09/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import SwiftUI

//  MARK: ContentView
/// Main application view entry that present
/// the tab bar with associated Views.
///
struct ContentView: View {

  @State var selection: TabItem = .market

  var body: some View {
    TabView(selection: $selection) {

      MarketView()
        .tabItem {
          Text("Market")
          Image.market
      }
      .tag(TabItem.market)

      FavoritesView()
        .tabItem {
          Text("Favorites")
          Image.favorites
      }
      .tag(TabItem.favorites)
    }
  }
}

// MARK: - Previews
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ContentView()

      ContentView()
        .preferredColorScheme(.dark)
    }
  }
}
