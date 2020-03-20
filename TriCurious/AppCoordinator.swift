//
//  AppCoordinator.swift
//  TriCurious
//
//  Created by Duff Neubauer on 3/19/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import UIKit

protocol Module {
    var rootViewController: UIViewController { get }
}

extension UIViewController : Module {
    var rootViewController: UIViewController { self }
}

class AppCoordinator {
    private var tabBarVC: UITabBarController

    init() {
        let triathlonStore = TriathlonOrg()

        let rankings = RankingsModule(store: triathlonStore)
        rankings.rootViewController.tabBarItem = .init(
            title: "Rankings",
            image: UIImage(systemName: "person.3"),
            selectedImage: UIImage(systemName: "person.3.fill"))

        let news: Module = NewsViewController()
        news.rootViewController.tabBarItem = .init(
            title: "News",
            image: UIImage(systemName: "antenna.radiowaves.left.and.right"),
            selectedImage: nil)

        let watch: Module = WatchViewController()
        watch.rootViewController.tabBarItem = .init(
            title: "Watch",
            image: UIImage(systemName: "tv"),
            selectedImage: UIImage(systemName: "tv.fill"))

        let events: Module = EventsViewController()
        events.rootViewController.tabBarItem = .init(
            title: "Events",
            image: UIImage(systemName: "calendar"),
            selectedImage: nil)

        tabBarVC = UITabBarController()
        tabBarVC.viewControllers = [
            rankings.rootViewController,
            news.rootViewController,
            watch.rootViewController,
            events.rootViewController
        ]
    }
}

extension AppCoordinator : Module {
    var rootViewController: UIViewController { tabBarVC }
}
