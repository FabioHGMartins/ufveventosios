//
//  SobreView.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 27/06/19.
//  Copyright © 2019 Fabio Martins. All rights reserved.
//

import UIKit
import KYDrawerController


class SobreView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sobre"
        
        self.navigationItem.hidesBackButton = true
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        navigationController?.navigationBar.barTintColor = UIColor(hexFromString: "890505")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Menu",
            style: UIBarButtonItemStyle.plain,
            target: self,
            action: #selector(abrirMenu)
        )
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            if let drawerController = parent as? KYDrawerController {
                drawerController.setDrawerState(.closed, animated: true)
            }
        }
    }
    
    @objc func abrirMenu(_ sender: UIBarButtonItem) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }

}
