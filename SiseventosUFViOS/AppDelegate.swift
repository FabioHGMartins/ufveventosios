//
//  AppDelegate.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 31/08/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:[UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = UIColor.white
        
        GMSServices.provideAPIKey("AIzaSyC2vzuwOgPqc-bKKZZ_OykqsTYx6qRTTe8")
        
        let loginView = LoginView(nibName: "LoginView", bundle: nil)
        
        let nav = UINavigationController()
        
        nav.pushViewController(loginView, animated: false)
        
        self.window!.rootViewController = nav
        self.window!.makeKeyAndVisible()
        
        return true
    }


}

