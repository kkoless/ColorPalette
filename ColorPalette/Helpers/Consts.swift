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
        static let baseUrl = URL(string: "http://127.0.0.1:8000/api")!
        static let googleUrl = URL(string: "https://customsearch.googleapis.com/")!
        static let tokenHeader = "Authorization"
        static let googleSearchAPIKey = "AIzaSyChm0R0hmc0bDP-wQcn7tLrWMPRGa1kRiw"
    }
    
    struct Constraints {
        static let top = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0.0
        static let bottom = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0
        static let screenWidth = UIScreen.main.bounds.width
        static let screenHeight = UIScreen.main.bounds.height
    }
}
