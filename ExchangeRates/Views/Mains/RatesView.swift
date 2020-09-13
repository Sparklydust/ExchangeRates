//
//  RatesView.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 09/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import SwiftUI
import Combine

//  MARK: RatesView
/// Populates the exchanges rates in real time.
///
struct RatesView: View {

  @EnvironmentObject var viewModel: RatesViewModel
  @EnvironmentObject var searchBar: SearchBarItem

  var body: some View {
    NavigationView {
      ZStack(alignment: .center) {
        VStack {
          if viewModel.showTryAgainButton {
            TryAgainButton(action: { self.viewModel.tryAgainUpstreamRatesTimer() })
          }
          else {
            List(viewModel.newRates.sorted(by: <)
              .filter { searchBar.text.isEmpty
                ? true
                : $0.key.contains(searchBar.text.uppercased()) }, id: \.key) { data in
                  NavigationLink(destination: DetailsView(data: data)) {
                    RatesCell(data: data)
                  }
            }
            .listStyle(PlainListStyle())
          }
          FetchRatesDateItem()
        }
        .add(searchBar)
        .navigationBarTitle(Localized.rates, displayMode: .large)

        if viewModel.isLoading {
          Spinner(isAnimating: viewModel.isLoading,
                  style: .large, color: .systemBlue)
        }
      }
    }
    .onAppear {
      self.viewModel.connectUpstreamRatesTimer()
    }
    .onReceive(viewModel.ratesTimer.connectedPublisher) { _ in
      self.viewModel.downloadLiveRates()
    }
    .onDisappear {
      self.viewModel.disconnectUpstreamRatesTimer()
    }
    .alert(isPresented: $viewModel.showNetworkAlert) {
      self.viewModel.showNetworkErrorAlert()
    }
  }
}

// MARK: - Previews
struct Rates_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      RatesView()

      RatesView()
        .preferredColorScheme(.dark)
    }
  }
}
