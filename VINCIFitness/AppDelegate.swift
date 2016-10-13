//
//  AppDelegate.swift
//  VINCIFitness
//
//  Created by David Xu on 8/15/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let onBoardingViewController = OnboardViewController(nibName: "OnboardViewController", bundle: nil)
        
        GMSServices.provideAPIKey("AIzaSyAb0c3wy-NC6lp_KZbCDgYj5mk9mMMXjCc")
        GMSPlacesClient.provideAPIKey("AIzaSyAb0c3wy-NC6lp_KZbCDgYj5mk9mMMXjCc")
        //make it the root view of the app
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = onBoardingViewController
        window?.makeKeyAndVisible()
        
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    func initTabBarController() -> UITabBarController{
        let tabViewController = UITabBarController()
        var mapNavigationController = UINavigationController()
        var profileNavigationController = UINavigationController()
        //set up view controller
        let mapViewController = MapViewController(nibName: "MapViewController", bundle: nil)
        mapNavigationController = UINavigationController(rootViewController: mapViewController)
        let profileViewController = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        profileNavigationController = UINavigationController(rootViewController: profileViewController)
        let viewControllers = [mapNavigationController,profileNavigationController]
        tabViewController.viewControllers = viewControllers
        
        //set up tab bar item
        let mapTabItem = UITabBarItem(title: "Map", image: nil, selectedImage: nil)
        let profileTabItem = UITabBarItem(title: "Profile", image: nil, selectedImage: nil)
        mapNavigationController.tabBarItem = mapTabItem
        profileNavigationController.tabBarItem = profileTabItem
        
        return tabViewController
    }

    func applicationWillResignActive(_ application: UIApplication) {
       FBSDKAppEvents.activateApp()
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

