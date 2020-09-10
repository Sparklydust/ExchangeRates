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

  @EnvironmentObject var viewModel: RatesViewModel

  var body: some View {
    NavigationView {
      ZStack(alignment: .center) {
        if viewModel.isLoading {
          Spinner(isAnimating: viewModel.isLoading, style: .large, color: .blue)
        }
        VStack {
          if viewModel.showTryAgainButton {
            TryAgainButton(action: { self.viewModel.tryAgainUpstreamTimer() })
          }
          else {
            List(viewModel.newRates.sorted(by: <), id: \.key) { data in
              NavigationLink(destination: Text("DetailsView")) {
                RatesCell(symbol: data.key,
                          price: data.value)
              }
            }
            .listStyle(PlainListStyle())
          }
          HStack(alignment: .center) {
            Spacer()
            Text("\(viewModel.date.formatted())")
              .font(.footnote)
              .fontWeight(.medium)
            Spacer()
          }
          .padding(.vertical, 8)
        }
        .navigationBarTitle(Localized.market, displayMode: .large)
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
