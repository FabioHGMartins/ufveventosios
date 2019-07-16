//
//  EsqueciSenhaView.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 15/07/19.
//  Copyright © 2019 Fabio Martins. All rights reserved.
//

import UIKit

class EsqueciSenhaView: UIViewController {
    
    @IBOutlet var recuperarSenhaBt: UIButton?
    @IBOutlet var emailTf: UITextField?
    @IBOutlet var emailTfErro: UITextView?
    
    var requester:UsuarioRequester!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.title = "Recuperar Senha"
        let voltarBt = UIBarButtonItem()
        voltarBt.title = "Voltar"
        self.navigationItem.backBarButtonItem = voltarBt
        
        requester = UsuarioRequester(self)
        
    }
    
    @IBAction func recuperarSenha () {
        if(validaCampos()) {
            let email = emailTf?.text
            requester.postRecuperaSenha(email: email!, handleFinish: { (ready, success) in
                if(ready) {
                    if (success) {
                        let loginView = LoginView()
                        self.navigationController?.pushViewController(loginView, animated: true)
                        Alerta.alerta("Operação feita com sucesso!", msg: "Por favor, verifique o seu email", view: self)
                    } else {
                        Alerta.alerta("Ocorreu um erro na requisição.", msg: "Por favor, tente novamente", view: self)
                        
                    }
                }
            })
        }
    }
    
    
    func validaCampos() -> Bool {
        var l = true
        if (emailTf?.text?.isEmpty)! {
            emailTfErro?.isHidden = false
            l = false
        } 
        return l
    }

}
