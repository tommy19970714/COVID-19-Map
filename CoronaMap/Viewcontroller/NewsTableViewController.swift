//
//  NewsViewController.swift
//  CoronaMap
//
//  Created by Toshiki Tomihira on 2020/02/09.
//  Copyright © 2020 Toshiki Tomihira. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GoogleNewsAPI().headlines(callback: { _articles, error in
            self.articles = _articles
            self.tableView.reloadData()
            
            GoogleNewsAPI().everything(callback: { __articles, _error in
                self.articles = _articles + __articles
                self.tableView.reloadData()
            })
            
            
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection
    section: Int) -> Int {
        return articles.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTablewViewCell
        cell.setup(article: articles[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NewsWebViewController") as! NewsWebViewController
        controller.firstPageUrl = articles[indexPath.row].url
        present(controller, animated: true, completion: nil)
        
        
    }
}
