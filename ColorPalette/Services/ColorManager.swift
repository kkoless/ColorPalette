//
//  ColorManager.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 23.12.2022.
//

import Foundation

final class ColorManager {
  let colors: [AppColor]
  
  lazy var moodColors: [String : [AppColor]] = {
    var dist = [String: [AppColor]]()
    
    MoodType.allCases.forEach { type in
      dist[type.rawValue] = colors.filter { appColor in
        if !type.associationColors.filter({ appColor.name.lowercased().contains($0) }).isEmpty {
          return true
        } else {
          return false
        }
      }
    }
    
    return dist
  }()
  
  static let shared = ColorManager()
  
  private init() {
    colors = ([AppColor].parse(jsonFile: "colors") ?? []).removingDuplicates(byKey: { $0.hex })
    print("\(self) INIT")
  }
  
  deinit {
    print("\(self) DEINIT")
  }
}

