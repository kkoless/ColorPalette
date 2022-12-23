//
//  CGFloat+Extensions.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 23.12.2022.
//

import Foundation

extension CGFloat {
    func rounded(toDecimalPlaces n: Int) -> CGFloat {
        let multiplier = pow(10, CGFloat(n))
        return (multiplier * self).rounded() / multiplier
    }
}
