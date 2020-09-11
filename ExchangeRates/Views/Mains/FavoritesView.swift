//
//  FavoritesView.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 09/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import SwiftUI

//  MARK: FavoritesView
/// Populates user favorites saved rates.
///
struct FavoritesView: View {

  @EnvironmentObject var viewModel: FavoritesViewModel

  @FetchRequest(
    entity: Rate.entity(),
    sortDescriptors: [NSSortDescriptor(keyPath: \Rate.symbol, ascending: true)])
  var savedRates: FetchedResults<Rate>

  var body: some View {
    NavigationView {
      ZStack(alignment: .center) {
        VStack {
          if savedRates.isEmpty {
            EmptyFavoritesMessage()
          }
          else {
            if viewModel.showTryAgainButton {
              TryAgainButton(action: { self.viewModel.tryAgainUpstreamTimer() })
            }
            else {
              List {
                ForEach(viewModel.newFavoriteRates.sorted(by: <), id: \.key) { data in
                  RatesCell(symbol: data.key,
                            price: data.value)
                }
                .onDelete { indexSet in
                  self.viewModel.deleteFavorite(from: self.savedRates,
                                                at: indexSet)
                }
              }
            }
          }
        }
        .navigationBarTitle(Localized.favorites, displayMode: .large)
        .navigationBarItems(trailing: EditButton())

        if viewModel.isLoading {
          Spinner(isAnimating: viewModel.isLoading, style: .large, color: .blue)
        }
      }
    }
    .onAppear {
      self.viewModel.downloadFavoritesLiveRates()
    }
    .onReceive(viewModel.timer) { _ in
      self.viewModel.downloadFavoritesLiveRates()
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
struct FavoritesView_Previews: PreviewProvider {

  static var previews: some View {
    Group {
      FavoritesView()

      FavoritesView()
        .preferredColorScheme(.dark)
    }
  }
}
