//
//  MainTabViewController.swift
//  CoronaMap
//
//  Created by Toshiki Tomihira on 2020/02/09.
//  Copyright © 2020 Toshiki Tomihira. All rights reserved.
//
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    func setup() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let firstController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let newsNavigation = storyboard.instantiateViewController(withIdentifier: "NewsNavigationVIewController") as! UINavigationController
        
        firstController.tabBarItem = UITabBarItem(title: "Map", image: UIImage.init(systemName: "map"), tag: 0)
        newsNavigation.tabBarItem = UITabBarItem(title: "News", image: UIImage.init(systemName: "star"), tag: 1)
        viewControllers = [firstController, newsNavigation]
    }
 
}
