//
//  View+Add.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 11/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import SwiftUI

extension View {
  /// Add SearchBar View as Modifier into parent View.
  ///
  func add(_ searchBar: SearchBarItem) -> some View {
    return self.modifier(SearchBarModifier(searchBar: searchBar))
  }
}
