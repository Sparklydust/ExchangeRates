//
//  SearchBarItem.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 11/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import SwiftUI

//  MARK: SearchBarItem
/// Search bar made from UIKit off to UIViewRepresentable and
/// set to be used on SwiftUI Views.
///
class SearchBarItem: NSObject, ObservableObject {

  @Published var text = String()

  let searchController = UISearchController(searchResultsController: nil)

  override init() {
    super.init()
    self.searchController.obscuresBackgroundDuringPresentation = false
    self.searchController.searchResultsUpdater = self
  }
}

extension SearchBarItem: UISearchResultsUpdating {

  func updateSearchResults(for searchController: UISearchController) {

    // Publish search bar text changes.
    if let searchBarText = searchController.searchBar.text {
      self.text = searchBarText
    }
  }
}
