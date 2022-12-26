//
//  Consts.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 01.12.2022.
//

import Foundation
import UIKit

struct Consts {
    struct API {
        static let baseUrl = URL(string: "")!
        static let tokenHeader = "apiKey"
    }
    
    struct Constraints {
        static let top = UIApplication.shared.windows.first?.safeAreaInsets.top
        static let bottom = UIApplication.shared.windows.first?.safeAreaInsets.bottom
    }
}
