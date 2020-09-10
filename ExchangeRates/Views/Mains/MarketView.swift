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

  @State var subscriptions = Set<AnyCancellable>()

  @State var rates: RatesData!
  @State var showNetworkAlert = false

  var body: some View {
    NavigationView {
      VStack {
        Text("MarketView")
      }
      .navigationBarTitle(Localized.market)
    }
    .onAppear {
      self.downloadLiveRates()
    }
    .alert(isPresented: $showNetworkAlert) {
      Alert(title: Text(Localized.networkErrorTitle),
            message: Text(Localized.networkErrorMessage),
            dismissButton: .none)
    }
  }
}

extension MarketView {
  func downloadLiveRates() {
    NetworkRequest<RatesData>(.live).download()
      .sink(
        receiveCompletion: { completion in
          switch completion {
          case .failure:
            print(NetworkEndpoint.live.url)
            self.showNetworkAlert = true
          case .finished:
            break }},
        receiveValue: { data in
          self.rates = data
          print(self.rates.quotes) })
      .store(in: &subscriptions)
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
