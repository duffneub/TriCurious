//
//  AppCoordinator.swift
//  TriCurious
//
//  Created by Duff Neubauer on 3/19/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import UIKit

protocol ViewControllerRepresentable {
    var viewController: UIViewController { get }
}

extension UIViewController : ViewControllerRepresentable {
    var viewController: UIViewController { self }
}

class AppCoordinator : ViewControllerRepresentable {
    private var tabBarVC: UITabBarController

    var viewController: UIViewController { tabBarVC }

    init() {
        let triathlonStore = TriathlonOrg()

        let rankings = RankingsCoordinator(store: triathlonStore)
        rankings.viewController.tabBarItem = .init(
            title: "Rankings",
            image: UIImage(systemName: "person.3"),
            selectedImage: UIImage(systemName: "person.3.fill"))

        let news: ViewControllerRepresentable = NewsViewController()
        news.viewController.tabBarItem = .init(
            title: "News",
            image: UIImage(systemName: "antenna.radiowaves.left.and.right"),
            selectedImage: nil)

        let watch: ViewControllerRepresentable = WatchViewController()
        watch.viewController.tabBarItem = .init(
            title: "Watch",
            image: UIImage(systemName: "tv"),
            selectedImage: UIImage(systemName: "tv.fill"))

        let events: ViewControllerRepresentable = EventsViewController()
        events.viewController.tabBarItem = .init(
            title: "Events",
            image: UIImage(systemName: "calendar"),
            selectedImage: nil)

        tabBarVC = UITabBarController()
        tabBarVC.viewControllers = [
            rankings.viewController,
            news.viewController,
            watch.viewController,
            events.viewController
        ]
    }
}
