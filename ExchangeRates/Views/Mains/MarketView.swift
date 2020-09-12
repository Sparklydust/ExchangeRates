//
//  MarketView.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 09/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import SwiftUI
import Combine

//  MARK: MarketView
/// Populates the exchanges rates in real time.
///
struct MarketView: View {

  @EnvironmentObject var viewModel: MarketViewModel
  @EnvironmentObject var searchBar: SearchBarItem

  var body: some View {
    NavigationView {
      ZStack(alignment: .center) {
        VStack {
          if viewModel.showTryAgainButton {
            TryAgainButton(action: { self.viewModel.tryAgainUpstreamTimer() })
          }
          else {
            List(viewModel.newRates.sorted(by: <)
              .filter { searchBar.text.isEmpty
                ? true
                : $0.key.contains(searchBar.text.uppercased()) }, id: \.key) { data in
                  NavigationLink(destination: DetailsView(symbol: data.key, price: data.value)) {
                    RatesCell(symbol: data.key,
                              price: data.value)
                  }
            }
            .listStyle(PlainListStyle())
          }
          FetchRatesDateItem()
        }
        .add(searchBar)
        .navigationBarTitle(Localized.market, displayMode: .large)

        if viewModel.isLoading {
          Spinner(isAnimating: viewModel.isLoading, style: .large, color: .blue)
        }
      }
    }
    .onAppear {
      self.viewModel.downloadLiveRates()
    }
    .onReceive(viewModel.timer) { _ in
      self.viewModel.downloadLiveRates()
    }
    .onDisappear {
      self.viewModel.disconnectUpstreamTimer()
    }
    .alert(isPresented: $viewModel.showNetworkAlert) {
      self.viewModel.showNetworkErrorAlert()
    }
  }
}

// MARK: - Previews
struct MarketView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      MarketView()

      MarketView()
        .preferredColorScheme(.dark)
    }
  }
}
