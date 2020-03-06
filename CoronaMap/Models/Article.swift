//
//  Article.swift
//  CoronaMap
//
//  Created by Toshiki Tomihira on 2020/02/09.
//  Copyright © 2020 Toshiki Tomihira. All rights reserved.
//

import Foundation

struct Article: Codable {
//    let author: String
    let title: String?
    let description: String?
    let url: URL
    let urlToImage: URL?
    let publishedAt: String?
//    let content: String
}
