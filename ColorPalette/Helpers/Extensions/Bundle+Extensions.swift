//
//  Bundle+Extensions.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 17.02.2023.
//

import Foundation

extension Bundle {
  var releaseVersionNumber: String? {
    infoDictionary?["CFBundleShortVersionString"] as? String
  }

  var buildVersionNumber: String? {
    infoDictionary?["CFBundleVersion"] as? String
  }

  var releaseVersionNumberPretty: String {
    "v \(releaseVersionNumber ?? "") (\(buildVersionNumber ?? ""))"
  }
}
