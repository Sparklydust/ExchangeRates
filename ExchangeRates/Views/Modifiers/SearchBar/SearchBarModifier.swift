//
//  SearchBarModifier.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 11/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import SwiftUI

//  MARK: SearchBarModifier
/// Create the SearchBarRepresentable as a View Modifier to
/// be able to be implemented where needed in Views.
///
struct SearchBarModifier: ViewModifier {

  let searchBar: SearchBarItem

  func body(content: Content) -> some View {
    content
      .overlay(
        SearchBarRepresentable { viewController in
          viewController.navigationItem.searchController = self.searchBar.searchController
        }
        .frame(width: 0, height: 0)
    )
  }
}
