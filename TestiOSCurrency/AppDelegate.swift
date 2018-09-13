//
//  AppDelegate.swift
//  TestiOSCurrency
//
//  Created by Dmitry Grebenschikov on 08/09/2018.
//  Copyright © 2018 dd-team. All rights reserved.
//

import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var container = Container()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GlobalAsslembly.configure()
        
        guard let vc = GlobalAsslembly.resolve(CurrencyViewProtocol.self) as? UIViewController else { return true }
        
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }


}

