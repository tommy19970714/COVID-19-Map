//
//  NewsCell.swift
//  CoronaMap
//
//  Created by Toshiki Tomihira on 2020/02/09.
//  Copyright © 2020 Toshiki Tomihira. All rights reserved.
//

import UIKit
import SDWebImage

class NewsTablewViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var thumbnailView: UIImageView!
    
    func setup(article: Article) {
        title.text = article.title
        date.text = article.publishedAt
        
        thumbnailView.sd_setImage(with: article.urlToImage)
    }
}
