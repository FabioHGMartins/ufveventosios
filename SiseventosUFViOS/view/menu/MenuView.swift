//
//  MenuView.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 23/09/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import UIKit
import KYDrawerController
import GoogleSignIn

class MenuView: UIViewController {
    
    @IBOutlet var nomeUsuarioLb: UILabel?
    @IBOutlet var inicioBt:UIButton?
    @IBOutlet var editarPerfilBt:UIButton?
    @IBOutlet var notificacoesBt:UIButton?
    @IBOutlet var sobreBt:UIButton?
    @IBOutlet var sairBt:UIButton?
    
    @IBOutlet var iconEditarPerfil:UIImageView?
    @IBOutlet var iconNotificacoes:UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        nomeUsuarioLb?.text = UsuarioSingleton.shared.usuario?.nome
        
        configuraMenuParaUserAnonimo()
    }
    
    func configuraMenuParaUserAnonimo(){
        print("\n\nConigurar menu para usuário anonimo entrou\n\n")
        
        if UsuarioSingleton.shared.usuario?.email == "login_anonimo@anonimo.com" {
            editarPerfilBt?.isHidden = true
            iconEditarPerfil?.isHidden = true
            
            notificacoesBt?.isHidden = true
            iconNotificacoes?.isHidden = true
            
            sairBt?.setTitle("Login", for: .normal)
        }
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
            if(UsuarioSingleton.shared.usuario?.googleId == "") {
                let editarPerfilView = EditarPerfilView()
                (drawerController.mainViewController as! UINavigationController).pushViewController(editarPerfilView, animated: true)
                drawerController.setDrawerState(.closed, animated: true)
            } else {
                Alerta.alerta("Funcionalidade Indisponível", msg: "Essa funcionalidade está indisponível para usuário logados com conta Google", view: self)
            }
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
        //let loginView = LoginView(nibName: "LoginView", bundle: nil)
        AppControl.preferences.set(false, forKey: "logado")
        AppControl.preferences.set(nil, forKey: "email")
        AppControl.preferences.set(nil, forKey: "nome")
        if(UsuarioSingleton.shared.usuario?.googleId == nil) {
            GIDSignIn.sharedInstance().signOut()
            AppControl.preferences.set(nil, forKey: "googleId")
        } else {
            AppControl.preferences.set(nil, forKey: "senha")
        }
        //self.present(loginView, animated: true, completion: nil)
        
        if let drawerController = parent as? KYDrawerController {
            let loginView = LoginView()
            (drawerController.mainViewController as! UINavigationController).pushViewController(loginView, animated: true)
            drawerController.setDrawerState(.closed, animated: true)
        }
        
    }

}
