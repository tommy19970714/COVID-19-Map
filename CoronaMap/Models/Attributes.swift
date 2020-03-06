//
//  Attributes.swift
//  CoronaMap
//
//  Created by Toshiki Tomihira on 2020/02/04.
//  Copyright © 2020 Toshiki Tomihira. All rights reserved.
//

import Foundation

struct Attributes: Codable {
    let OBJECTID: Int
    let Country_Region: String
    let Last_Update: Int64
    let Lat: Double
    let Long_: Double
    let Confirmed: Int
    let Deaths: Int
    let Recovered: Int
}
