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
    
    @IBAction func inicio() {
        if let drawerController = parent as? KYDrawerController {
            let principalView = PrincipalView()
            (drawerController.mainViewController as! UINavigationController).pushViewController(principalView, animated: true)
            drawerController.setDrawerState(.closed, animated: true)
        }
    }
    
    @IBAction func editarPerfil() {
        if let drawerController = parent as? KYDrawerController {
            let editarPerfilView = EditarPerfilView()
            (drawerController.mainViewController as! UINavigationController).pushViewController(editarPerfilView, animated: true)
            drawerController.setDrawerState(.closed, animated: true)
        }
    }
    
    @IBAction func notificacoes() {
        if let drawerController = parent as? KYDrawerController {
            let notificacoesView = NotificacoesView()
            (drawerController.mainViewController as! UINavigationController).pushViewController(notificacoesView, animated: true)
            drawerController.setDrawerState(.closed, animated: true)
        }
    
    }
    
    @IBAction func sobre() {
        if let drawerController = parent as? KYDrawerController {
            let sobreView = SobreView(nibName: "SobreView", bundle: nil)
            (drawerController.mainViewController as! UINavigationController).pushViewController(sobreView, animated: true)
            drawerController.setDrawerState(.closed, animated: true)
        }
    }
    
    @IBAction func sair() {
        let loginView = LoginView(nibName: "LoginView", bundle: nil)
        AppControl.preferences.set(false, forKey: "logado")
        AppControl.preferences.set(nil, forKey: "email")
        AppControl.preferences.set(nil, forKey: "senha")
        self.present(loginView, animated: true, completion: nil)
    }

}
