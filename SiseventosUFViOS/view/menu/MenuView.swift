//
//  MenuView.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 23/09/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import UIKit
import KYDrawerController

class MenuView: UIViewController {
    
    @IBOutlet var inicioBt:UIButton?
    @IBOutlet var editarPerfilBt:UIButton?
    @IBOutlet var notificacoesBt:UIButton?
    @IBOutlet var sobreBt:UIButton?
    @IBOutlet var sairBt:UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)


    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.left {
            if let drawerController = parent as? KYDrawerController {
                drawerController.setDrawerState(.closed, animated: true)
            }
        }
    }
    
    func inicio() {
        if let drawerController = parent as? KYDrawerController {
            let principalView = PrincipalView()
            (drawerController.mainViewController as! UINavigationController).pushViewController(principalView, animated: true)
            drawerController.setDrawerState(.closed, animated: true)
        }
    }
    
    func editarPerfil() {
        
    }
    
    func notificacoes() {
    
    }
    
    func sobre() {
    
    }
    
    func sair() {
    
    }

}
