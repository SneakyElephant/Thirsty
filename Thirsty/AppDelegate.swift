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
        let barViewController = BarMapViewController()
        let eventViewController = EventListViewController()
        let favoritesViewController = FavoritesViewController()
        
        tabBarController = UITabBarController()
        tabBarController?.viewControllers = [barViewController, eventViewController, favoritesViewController]
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = tabBarController!
        window?.backgroundColor = UIColor.orangeColor()
        window?.makeKeyAndVisible()
        
        return true
    }
}

