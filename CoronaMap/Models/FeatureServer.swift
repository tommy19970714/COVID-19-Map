//
//  FeatureServer.swift
//  CoronaMap
//
//  Created by Toshiki Tomihira on 2020/02/04.
//  Copyright © 2020 Toshiki Tomihira. All rights reserved.
//

import Foundation

struct FeatureServer: Codable {
    let objectIdFieldName: String
    let globalIdFieldName: String
    let geometryType: String
    let features: [Feature]
}
