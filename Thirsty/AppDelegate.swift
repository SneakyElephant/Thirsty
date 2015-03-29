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
        
        let barViewController = BarMapViewController()
        let barNavController = UINavigationController(rootViewController: barViewController)
        barNavController.navigationBar.translucent = false
        let eventViewController = EventListViewController()
        let eventNavController = UINavigationController(rootViewController: eventViewController)
        eventNavController.navigationBar.translucent = false
        let favoritesViewController = FavoritesViewController()
        let favoritesNavController = UINavigationController(rootViewController: favoritesViewController)
        favoritesNavController.navigationBar.translucent = false
        
        tabBarController = UITabBarController()
        tabBarController?.tabBar.translucent = false
        tabBarController?.viewControllers = [barNavController, eventNavController, favoritesNavController]
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = tabBarController!
        window?.backgroundColor = UIColor.orangeColor()
        window?.makeKeyAndVisible()
        
        return true
    }
}

