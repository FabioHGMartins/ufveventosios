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
    
    @IBOutlet var labd2m:UIImageView?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //mantem a proporcao do logo labd2m
        labd2m?.contentMode = UIViewContentMode.scaleAspectFill
        
        self.title = "Sobre"
        
        //back button white color
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
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
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white //opcao MENU branca na barra de navegacao
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
