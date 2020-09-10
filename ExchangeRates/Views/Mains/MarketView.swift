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

  @State var showNetworkAlert = false
  @State var showTryAgainButton = false
  @State var isLoading = false

  @State var oldRates = [String: Double]()
  @State var newRates = [String: Double]()

  @State var rateArrow = Image(systemName: "arrow.up")
  @State var rateColor: Color = .blue

  let timer = Timer.publish(every: 61, on: .main, in: .common).autoconnect()

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
            List(newRates.sorted(by: <), id: \.key) { data in
              NavigationLink(destination: Text("DetailsView")) {
                RatesCell(symbol: data.key,
                          price: data.value,
                          rateArrow: self.rateArrow,
                          rateColor: self.rateColor)
              }
            }
            .listStyle(PlainListStyle())
          }
        }
        .navigationBarTitle(Localized.market, displayMode: .large)
      }
    }
    .onAppear {
      self.downloadLiveRates()
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
    showActivityIndicator(true)
    NetworkRequest<RatesData>(.live).download()
      .sink(
        receiveCompletion: { completion in
          switch completion {
          case .failure(let error):
            print(error)
            self.showNetworkAlert = true
          case .finished:
            self.showActivityIndicator(false)
            break }},
        receiveValue: { data in
          withAnimation(.easeInOut) {
            self.resetOldRatesNewRates()
            self.newRates = data.quotes
          }
          print(data.quotes.sorted(by: <)) })
      .store(in: &subscriptions)
  }

  func showActivityIndicator(_ action: Bool) {
    isLoading = action
  }

  func resetOldRatesNewRates() {
    oldRates = newRates
    newRates = [String: Double]()
  }

  func cancelUpstreamTimer() {
    self.isLoading = false
    showTryAgainButton = true
    disconnectUpstreamTimer()
  }

  func disconnectUpstreamTimer() {
    timer.upstream
      .connect()
      .cancel()
  }

  func tryAgainUpstreamTimer() {
    showTryAgainButton = false
    timer.upstream
      .connect()
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
