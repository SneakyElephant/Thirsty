//
//  AppDelegate.swift
//  Thirsty
//
//  Created by Stephen Thomas on 3/29/15.
//  Copyright (c) 2015 Final Boss Software. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var tabBarController: UITabBarController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        ParseManager.setup()
        StyleManager.updateUIStyle()
        
        let barNavController = UINavigationController(rootViewController: BarMapViewController())
        let eventNavController = UINavigationController(rootViewController: EventListViewController())
        let favoritesNavController = UINavigationController(rootViewController: FavoritesViewController())
        
        tabBarController = UITabBarController()
        tabBarController?.viewControllers = [barNavController, eventNavController, favoritesNavController]
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = tabBarController!
        window?.makeKeyAndVisible()
        
        return true
    }
}

