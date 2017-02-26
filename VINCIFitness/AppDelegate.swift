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
        let map_gray_image = resizeImage(image: UIImage(named: "map_icon_gray.png")!, newWidth: 40)
        let map_red_image = resizeImage(image: UIImage(named: "map_icon_red.png")!, newWidth: 40)
        let profile_gray_image = resizeImage(image: UIImage(named:"profile_icon_gray.png")!, newWidth: 45)
        let profile_red_image = resizeImage(image: UIImage(named:"profile_icon_red.png")!, newWidth: 45)
        
        let mapTabItem = UITabBarItem(title: "", image: map_gray_image, selectedImage: map_red_image)
        let profileTabItem = UITabBarItem(title: "", image: profile_gray_image, selectedImage: profile_red_image)
        
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
    func resizeImage(image: UIImage, newWidth: CGFloat
        ) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight + 7))
        image.draw(in: CGRect(x: 0, y: 7, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysOriginal)
        UIGraphicsEndImageContext()
        
//        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
//        let context = UIGraphicsGetCurrentContext()
//        context!.interpolationQuality = .high
//        let flipVertical =  __CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height)
//        context!.concatenate(flipVertical)
//        context?.draw(image.cgImage!, in: newRect)
//        let newImage = UIImage(cgImage: context!.makeImage()!)
//        UIGraphicsEndImageContext()
        return newImage!
        
        }



}
extension UIImage{
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }

}

