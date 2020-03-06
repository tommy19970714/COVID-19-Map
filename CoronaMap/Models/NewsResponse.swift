//
//  NewsResponse.swift
//  CoronaMap
//
//  Created by Toshiki Tomihira on 2020/02/09.
//  Copyright © 2020 Toshiki Tomihira. All rights reserved.
//

import Foundation

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
