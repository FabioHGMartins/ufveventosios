//
//  LoginView.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 07/09/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import UIKit
import KYDrawerController

class LoginView: UIViewController {
    
    @IBOutlet var loginBt:UIButton?
    @IBOutlet var cadastrarBt: UIButton?
    @IBOutlet var esqueciSenhaBt: UIButton?
    @IBOutlet var emailTf:UITextField?
    @IBOutlet var senhaTf:UITextField?
    
    @IBOutlet var emailTfErro: UITextView?
    @IBOutlet var senhaTfErro: UITextView?
    
    @IBOutlet var progress:UIActivityIndicatorView?

    var requester:UsuarioRequester!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
        let voltarBt = UIBarButtonItem()
        voltarBt.title = "Voltar"
        self.navigationItem.backBarButtonItem = voltarBt
        
        self.progress!.isHidden = true
        
        configUserDefaults()
        requester = UsuarioRequester(self)
    
    }
    
    @IBAction func cadastrarUsuario() {
        let cadastrarView = CadastrarUsuarioView()
        self.navigationController?.pushViewController(cadastrarView, animated: true)
    }
    
    @IBAction func login() {
        if(validaCampos()) {
            let senha = (senhaTf?.text)!
            let email = (emailTf?.text)!
            self.progress!.isHidden = false
            self.progress!.startAnimating()
            
            requester.login(user: email, senha: senha) { (ready, success) in
                if(ready) {
                    self.progress!.stopAnimating()
                    self.progress!.isHidden = true
                    if (success) {
                        let principalView = PrincipalView(nibName:"PrincipalView", bundle: nil)
                        let menuView = MenuView(nibName:"MenuView", bundle: nil)
                        let drawerKYController     = KYDrawerController(drawerDirection: .left, drawerWidth: 280)
                        drawerKYController.mainViewController = UINavigationController(
                            rootViewController: principalView
                        )
                        drawerKYController.drawerViewController = menuView
                        self.present(drawerKYController, animated: true, completion: nil)
                    }
                }
            }

        }
    }
    
    
    func validaCampos() -> Bool {
        var l = true
        if (emailTf?.text?.isEmpty)! {
            emailTfErro?.isHidden = false
            l = false
        } else {
            emailTfErro?.isHidden = true
        }
        if (senhaTf?.text?.isEmpty)! {
            senhaTfErro?.isHidden = false
            l = false
        } else {
            senhaTfErro?.isHidden = true
        }
        return l
    }
    
    func configUserDefaults() {
        if AppControl.preferences.object(forKey: "logado") == nil {
            AppControl.preferences.set(false, forKey: "logado")
        }
        if AppControl.preferences.object(forKey: "token") == nil {
            AppControl.preferences.set("falso", forKey: "token")
            
        }
        if AppControl.preferences.object(forKey: "agenda") == nil {
            
        }
        if AppControl.preferences.object(forKey: "notificacoes") == nil {
            
        }
        if AppControl.preferences.object(forKey: "firebasetoken") == nil {
            
        }
        
        
        AppControl.preferences.synchronize()
    }
}
