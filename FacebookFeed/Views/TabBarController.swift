//
//  TabBarController.swift
//  FacebookFeed
//
//  Created by Abraham Gonzalez on 11/20/18.
//  Copyright © 2018 Abraham Gonzalez. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        
        let newsFeed = FeedController(collectionViewLayout: layout)
        newsFeed.title = "News Feed"
        newsFeed.tabBarItem.image = UIImage(named: "news_feed_icon")
        
        let requests = RequestsController()
        requests.title = "Requests"
        requests.tabBarItem.image = UIImage(named: "requests_icon")
        
        let messenger = UIViewController()
        messenger.title = "Messenger"
        messenger.tabBarItem.image = UIImage(named: "messenger_icon")
        
        let notifications = UIViewController()
        notifications.title = "Notifications"
        notifications.tabBarItem.image = UIImage(named: "globe_icon")
        
        let more = UIViewController()
        more.title = "More"
        more.tabBarItem.image = UIImage(named: "more_icon")
        
        
        
        let controllers = [newsFeed, requests, messenger, notifications, more].map { (controller) -> UINavigationController in
            let nc = UINavigationController(rootViewController: controller)
            return nc
        }
        
        
        viewControllers = controllers
        
        /*   Setting the tab bar to be opaque instead of default translucent
         */
        //tabBar.isTranslucent = false
        
        /*   Modifying the top border line of tab bar to make it thinner
         */
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0.5)
        topBorder.backgroundColor = UIColor(red: 229/255, green: 231/255, blue: 235/255, alpha: 1).cgColor
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true              // hides the top border line of tab bar
    }
    
}
