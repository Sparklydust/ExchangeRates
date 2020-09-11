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

  @EnvironmentObject var viewModel: MarketViewModel

  @State var selection: TabItem = .market

  var body: some View {
    TabView(selection: $selection) {

      MarketView()
        .tabItem {
          Text(Localized.market)
          Image.market
      }
      .tag(TabItem.market)

      FavoritesView()
        .tabItem {
          Text(Localized.favorites)
          Image.favorites
      }
      .tag(TabItem.favorites)
      
    }
    .alert(isPresented: $viewModel.showCoreDataCrash) {
      self.viewModel.showCoreDataCrashAlert()
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
