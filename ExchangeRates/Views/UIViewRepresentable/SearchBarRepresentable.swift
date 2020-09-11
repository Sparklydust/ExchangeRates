//
//  SearchBarRepresentable.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 11/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import SwiftUI

//  MARK: SearchBarRepresentable
/// UIkit search bar item to be implemented in SwiftUI views.
///
final class SearchBarRepresentable: UIViewControllerRepresentable {

  let onResolve: (UIViewController) -> Void

  init(onResolve: @escaping (UIViewController) -> Void) {
    self.onResolve = onResolve
  }

  func makeUIViewController(context: Context) -> ParentResolverViewController {
    ParentResolverViewController(onResolve: onResolve)
  }

  func updateUIViewController(_ uiViewController: ParentResolverViewController, context: Context) { }
}

class ParentResolverViewController: UIViewController {

  let onResolve: (UIViewController) -> Void

  init(onResolve: @escaping (UIViewController) -> Void) {
    self.onResolve = onResolve
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("Use init(onResolve:) to instantiate ParentResolverViewController.")
  }

  override func didMove(toParent parent: UIViewController?) {
    super.didMove(toParent: parent)

    if let parent = parent {
      onResolve(parent)
    }
  }
}
