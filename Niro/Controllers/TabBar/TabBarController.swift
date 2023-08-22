//
//  TabBarController.swift
//  Niro
//
//  Created by Mohamed Adel on 01/08/2023.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        let vc1 = MoviesCollectionViewController(collectionViewLayout: layout)
        let navController1  = UINavigationController(rootViewController: vc1)
        
        let vc2 = SearchTableViewController()
        let navController2  = UINavigationController(rootViewController: vc2)
        
        let vc3 = AccountViewController()
        let navController3  = UINavigationController(rootViewController: vc3)
        
        navController1.tabBarItem.image = UIImage(systemName: "square.stack")
        navController2.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        navController3.tabBarItem.image = UIImage(systemName: "person")
        
        setViewControllers([navController1, navController2, navController3], animated: true)
        
    }

    
}
