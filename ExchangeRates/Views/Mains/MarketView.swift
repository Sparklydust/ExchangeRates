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
  @State var showTryAgainButton = false
  @State var isLoading = false

  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

  var body: some View {
    NavigationView {
      ZStack(alignment: .center) {
        if isLoading {
          Spinner(isAnimating: isLoading, style: .large, color: .blue)
        }
        VStack {
          if showTryAgainButton {
            TryAgainButton(action: { self.tryAgainUpstreamTimer() })
          }
          else {
            Text("MarketView")
          }
        }
        .navigationBarTitle(Localized.market)
      }
    }
    .onReceive(timer) { _ in
      self.downloadLiveRates()
    }
    .onDisappear {
      self.disconnectUpstreamTimer()
    }
    .alert(isPresented: $showNetworkAlert) {
      Alert(title: Text(Localized.networkErrorTitle),
            message: Text(Localized.networkErrorMessage),
            primaryButton: .cancel {
              self.cancelUpstreamTimer() },
            secondaryButton: .default(Text(Localized.tryAgain)) {
              self.tryAgainUpstreamTimer()
        })
    }
  }
}

extension MarketView {
  func downloadLiveRates() {
    isLoading = true
    NetworkRequest<RatesData>(.live).download()
      .sink(
        receiveCompletion: { completion in
          switch completion {
          case .failure:
            print(NetworkEndpoint.live.url)
            self.showNetworkAlert = true
          case .finished:
            self.isLoading = false
            break }},
        receiveValue: { data in
          self.rates = data
          print(self.rates.quotes) })
      .store(in: &subscriptions)
  }

  func cancelUpstreamTimer() {
    self.isLoading = false
    showTryAgainButton = true
    disconnectUpstreamTimer()
  }

  func disconnectUpstreamTimer() {
    timer.upstream.connect().cancel()
  }

  func tryAgainUpstreamTimer() {
    showTryAgainButton = false
    timer.upstream.connect()
      .store(in: &self.subscriptions)
    downloadLiveRates()
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
