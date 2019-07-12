//
//  SplashScreen.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 27/06/19.
//  Copyright © 2019 Fabio Martins. All rights reserved.
//

import UIKit

class SplashScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.splashTimeOut(sender:)), userInfo: nil, repeats: false)
    }
    
    @objc func splashTimeOut(sender : Timer){
        let loginView = LoginView(nibName: "LoginView", bundle: nil)
        let nav = MyNavigationController()
        nav.pushViewController(loginView, animated: false)
        AppDelegate.sharedInstance().window?.rootViewController = nav
    }

}
