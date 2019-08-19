//
//  LoginView.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 07/09/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import UIKit
import KYDrawerController
import GoogleSignIn

class LoginView: UIViewController, UITextFieldDelegate, GIDSignInUIDelegate {
    
    @IBOutlet var loginBt:UIButton?
    @IBOutlet var cadastrarBt: UIButton?
    @IBOutlet var esqueciSenhaBt: UIButton?
    @IBOutlet var emailTf:UITextField?
    @IBOutlet var senhaTf:UITextField?
    
    @IBOutlet var emailTfErro: UITextView?
    @IBOutlet var senhaTfErro: UITextView?
    
    @IBOutlet var progress:UIActivityIndicatorView?

    var requester:UsuarioRequester!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.title = "Login"
        
        //back button white color
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.hidesBackButton = true
        
        /*let voltarBt = UIBarButtonItem()
        voltarBt.title = "Voltar"
        self.navigationItem.backBarButtonItem = voltarBt*/
        
        
        
        navigationController?.navigationBar.barTintColor = UIColor(hexFromString: "890505")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        self.progress!.isHidden = true
        
        requester = UsuarioRequester(self)
        configUserDefaults()
    }
    
    @IBAction func entrarSemLogin(){
        print("\n\nEntrei sem login\n\n")
        
        requester.login(user: "login_anonimo@anonimo.com", senha: "9anONimo123") { (ready, success) in
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
    
    @IBAction func cadastrarUsuario() {
        let cadastrarView = CadastrarUsuarioView()
        self.navigationController?.pushViewController(cadastrarView, animated: true)
    }
    
    @IBAction func esqueciMinhaSenha() {
        let esqueciSenhaView = EsqueciSenhaView()
        self.navigationController?.pushViewController(esqueciSenhaView, animated: true)        
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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == emailTf) {
            senhaTf?.becomeFirstResponder()
            return true
        } else {
            login()
            return true
        }
        return false
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
        if (AppControl.preferences.object(forKey: "logado") == nil) {
            AppControl.preferences.set(false, forKey: "logado")
        } else if (AppControl.preferences.bool(forKey: "logado")){
            let email = AppControl.preferences.string(forKey: "email")
            self.progress!.isHidden = false
            self.progress!.startAnimating()
            if let googleId = AppControl.preferences.string(forKey: "googleId") {
                let nome = AppControl.preferences.string(forKey: "nome")
                requester.loginComGoogle(nome: nome!, email: email!, googleId: googleId) { (ready, success) in
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
            } else {
                let senha = AppControl.preferences.string(forKey: "senha")
                requester.login(user: email!, senha: senha!) { (ready, success) in
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
