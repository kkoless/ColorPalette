//
//  URL+Extensions.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 11.04.2023.
//

import Foundation

extension URL: Identifiable {
  public var id: Int {
    hashValue
  }
}
