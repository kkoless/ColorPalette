//
//  Array+Extensions.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 17.02.2023.
//

import Foundation

extension Array where Element: Hashable {
    func removingDuplicates<T: Hashable>(byKey key: (Element) -> T)  -> [Element] {
        var result = [Element]()
        var seen = Set<T>()
        
        for value in self {
            if seen.insert(key(value)).inserted {
                result.append(value)
            }
        }
        
        return result
    }
}
