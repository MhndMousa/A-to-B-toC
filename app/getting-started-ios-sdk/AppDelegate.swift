//
//  AppDelegate.swift
//  getting-started-ios-sdk
//
//  Created by Smartcar on 11/19/18.
//  Copyright © 2018 Smartcar. All rights reserved.
//

import UIKit
import SmartcarAuth
import NMAKit

let credentials = (
    appId: "q4G07fhnTRal97SUTOuC",
    appCode: "4hx7ttY6GuuDTRps9ITThQ",
    licenseKey:"fVaieGywF9OTS8fA8SGG2Uov7ZC7eHfDoGAb0LiRy8sVXrAhIYg0lfogQjLJj3WGF7NsNDMIE+EIP3bwLJfdwoM+eU+4DldeS41WrTtlufhbtDZo0p4IOLDvcOH1sDca93Ln5UDg8IJM6rM6HeintE7YBTMUsfhrb05kwN/r/RMLDR1mKeo+iB/qmuDvmriGJJB1NajrMtpnemhU5Ffu1GIVedILwNWynvrAoNewKUdjAve3xyvtg9AKtpea3B7JvaCHuVTeKqx1byj8D3PZ0JnpYI+WM9O7WnOyj+uhe5KHomrNUJvwWX7UF/k3u7bzjFpRn0MaqCxwepw3cqcNdvBTBV2PzoAPUiJNGX8D0Tql2in77x6ZmhzCP4zDjJN8QO1xy22l+BWAmw6zNVVgJwEhcR1o0GmXNlG04hN7bJ/7SDgGhVdaTQaRvl9M0IpaYlCUN7yfxc6sk7iCdoq7GXcsozgBM4IM49aLMOqZAqh/COtljL//e+ZDocvXehGp36lS2rDG8aKe0O0TBWWJavx5Fltnw+UAOiWjSrqmChg7C442a/FHFbgDTSrUKWl+A0nzt4YOUvbXobyEnuXG76K0tZiSkrtk+ctOAk6V+6PeiZ+ei5Gpb6zekSFWBnGOAr1I89dSvq+0oIouxN/DCVL8wf4Wxk/yNMkamGfxCfA="
)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var smartcar: SmartcarAuth?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        NMAApplicationContext.set(appId: "SAaFyFdFleRmQgD95PoD", appCode: "QQ2wJpW5XWScyRYLWKDhEQ")
        NMAApplicationContext.setAppId(credentials.appId, appCode: credentials.appCode, licenseKey: credentials.licenseKey)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        window!.rootViewController?.presentedViewController?.dismiss(animated: true , completion: nil)
        smartcar!.handleCallback(with: url)
        
        return true
    }
    
}

