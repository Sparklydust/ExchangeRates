//
//  Spinner.swift
//  ExchangeRates
//
//  Created by Roland Lariotte on 10/09/2020.
//  Copyright © 2020 Roland Lariotte. All rights reserved.
//

import SwiftUI

//  MARK: Spinner
/// Representing the UIKit Activity Controller for Views.
///
struct Spinner: UIViewRepresentable {

  let isAnimating: Bool
  let style: UIActivityIndicatorView.Style
  let color: UIColor

  func makeUIView(context: UIViewRepresentableContext<Spinner>) -> UIActivityIndicatorView {
    let spinner = UIActivityIndicatorView(style: style)
    spinner.hidesWhenStopped = true
    spinner.color = color
    return spinner
  }

  func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Spinner>) {
    isAnimating
      ? uiView.startAnimating()
      : uiView.stopAnimating()
  }
}
