//
//  AppDelegate.swift
//  Alias
//
//  Created by Maxim Vagin on 02.05.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if UserDefaults.standard.bool(forKey: "isLaunchedBefore") == false {
            SettingsManager.shared.setDefaultValues()
            UserDefaults.standard.set(true, forKey: "isLaunchedBefore")
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }

}
