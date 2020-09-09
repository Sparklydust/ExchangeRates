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
/// the tab bar.
///
struct ContentView: View {

  var body: some View {
    Text("ExchangeRates")
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
