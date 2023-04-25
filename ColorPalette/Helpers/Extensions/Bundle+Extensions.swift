//
//  Bundle+Extensions.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 17.02.2023.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
    var releaseVersionNumberPretty: String {
        return "v \(releaseVersionNumber ?? "") (\(buildVersionNumber ?? ""))"
    }
}
