//
//  SceneDelegate.swift
//  TriCurious
//
//  Created by Duff Neubauer on 2/28/20.
//  Copyright © 2020 Duff Neubauer. All rights reserved.
//

import Combine
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var cancellable: AnyCancellable?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let x = TriathlonOrg()
        cancellable = x.athletes(id: 47630).receive(on: RunLoop.main).sink(receiveCompletion: { result in
            print(result)
        }) { athlete in
            print(athlete)

            let vc = AthleteBioViewController()
            vc.athlete = AthleteViewModel(
                athlete: athlete,
                interactor: DefaultRankingsListInteractor(store: TriathlonOrg()))

            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
        }

//        let interactor = DefaultRankingsListInteractor(store: TriathlonOrg())
//        let presenter = RankingsListPresenter(interactor: interactor)
//        let rootVC = RankingsListViewController()
//        rootVC.presenter = presenter
//
//        window?.rootViewController = rootVC
//
//        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

