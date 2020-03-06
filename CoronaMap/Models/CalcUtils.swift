//
//  CalcUtils.swift
//  CoronaMap
//
//  Created by Toshiki Tomihira on 2020/02/04.
//  Copyright © 2020 Toshiki Tomihira. All rights reserved.
//

import Foundation

class CalcUtils {
    static func absoluteDistance(confirm: Int) -> Double {
        let unit: Double = 150000
        return log10(Double(confirm) + 1) * unit
    }

    static func relativeDistance(delta: Double, confirm: Int) -> Double {
        let unitM: Double = 2 * Double.pi * 6378150 / 10000
        let unit: Double = unitM * delta
        return log2(Double(confirm) + 1) * unit / 3
    }
}
