//
//  Colors.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 30.10.2024.
//

import Foundation
import SwiftUI

public extension Color {
   
  /// main colors
  static let primaryColor: Color = Color("primaryColor")
  static let secondaryColor: Color = Color("secondaryColor")
  static let accentColor: Color = Color("accentColor")
  static let lightGray: Color = .init(red: 200/255, green: 200/255, blue: 200/255)
    
  /// chart colors
  static let greenColor: Color = Color("greenColor")
  static let redColor: Color = Color("redColor")

  /// shadow
  static let shadow: Color = Color.black.opacity(0.24)
}
