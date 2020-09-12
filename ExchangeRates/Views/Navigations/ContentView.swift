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

  @EnvironmentObject var viewModel: RatesViewModel

  @State var selection: TabItem = .rates

  var body: some View {
    TabView(selection: $selection) {

      RatesView()
        .tabItem {
          Text(Localized.rates)
          Image.rates
      }
      .tag(TabItem.rates)

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
