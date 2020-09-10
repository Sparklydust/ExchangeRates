//
//  TryAgainButton.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 10/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import SwiftUI

//  MARK: TryAgainButton
/// Button populated to user when cancel on Alert is tapped
/// after network call error from MarketView.
///
struct TryAgainButton: View {

  var action: () -> Void

  var body: some View {
    ZStack {
      Button(action: { self.action() }) {
        Text(Localized.tryAgain)
          .font(.subheadline)
          .fontWeight(.medium)
          .foregroundColor(.blue)
      }
    }
  }
}

// MARK: - Previews
struct TryAgainButton_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      TryAgainButton(action: { })

      TryAgainButton(action: { })
        .preferredColorScheme(.dark)
    }
  }
}
