//
//  UsuarioRequester.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 08/09/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UsuarioRequester {
    
    var view:UIViewController?
    
    //usar callback handleFinish pois é necessário esperar o retorno da aPi antes de poder definir se o login foi feito de forma correta ou não
    func login(user: String, senha: String, handleFinish:@escaping ((ready:Bool,success:Bool))->()){
        self.postUsuarioAuth(user: user, senha: senha, callbackSuccess: { (responseObject) in
            if let usuario = responseObject {
                UsuarioSingleton.shared.usuario = usuario
                print(UsuarioSingleton.shared.usuario)
                AppControl.preferences.set(true, forKey: "logado")
                AppControl.preferences.set(usuario.id, forKey: "id")
                AppControl.preferences.set(usuario.nome, forKey: "nome")
                AppControl.preferences.set(usuario.email, forKey: "email")
                AppControl.preferences.set(usuario.senha, forKey: "senha")
                AppControl.preferences.set(usuario.matricula, forKey: "matricula")
                AppControl.preferences.set(usuario.nascimento, forKey: "nascimento")
                AppControl.preferences.set(usuario.sexo, forKey: "sexo")
                AppControl.preferences.set(usuario.googleId, forKey: "googleId")
                AppControl.preferences.set(usuario.foto, forKey: "foto")
                
                let categoriasRequester = CategoriaRequester()
                categoriasRequester.getPreferenciasCategoria(idUsuario: usuario.id) { (ready,success) in
                    if (ready) {
                        if (success) {
                            
                        }
                    }
                }
                
                handleFinish((ready: true, success: true))
            } else {
                Alerta.alerta("Credenciais inválidas", msg: "Por favor insira uma combinação válida de usuário e senha.", view: self.view!)
                handleFinish((ready: true, success: false))
            }
        }, callbackFailure: { (error) in
            Alerta.alerta("Erro da rede", msg: "Aconteceu um erro inesperado na rede. Por favor, tente novamente.", view: self.view!)
            handleFinish((ready: true, success: false))
        })
    }
    
    //o callback handlefinish é usado para esperar o retorno da api antes de decidir se foi um sucesso ou não
    func cadastrarUsuario(usuario: Usuario, handleFinish:@escaping ((ready: Bool, success:Bool))->()){
        self.postUsuario(usuario: usuario, callbackSuccess: {
            self.login(user: usuario.email, senha: usuario.senha) { (ready, success) in
                if(ready) {
                    handleFinish((ready: true, success: success))
                }
            }
        }, callbackFailure: {
            Alerta.alerta("Usuário inválido", msg: "O email indicado já foi cadastrado. Por favor, insira um novo email.", view: self.view!)
            handleFinish((ready: true,success: false))
        })
    }
    
    func postUsuarioAuth(user: String, senha: String, callbackSuccess: @escaping ((_ responseObject: Usuario?)->()), callbackFailure: @escaping ((_ error: Usuario)->())){
        let jsonObj : JSON = ["usuario": user,"senha": Seguranca.duploMD5(senha)]
        let parameters = ["data": jsonObj]
        
        Endpoints.shared.makeRequest(apiUrl: Endpoints.shared.authUsuario, method: .post, parameters: parameters, callbackSuccess: {(info:Data?) in
            var usuario: Usuario?
            if let responseData =  info{
                let decoder = JSONDecoder()
                usuario = try? decoder.decode(Usuario.self, from: responseData)
            }
            callbackSuccess(usuario)
            
        }){ (error) in
            print("Error postUsuarioAuth")
        }
    }
    
    
    func postUsuario(usuario: Usuario, callbackSuccess: @escaping (()->()), callbackFailure: @escaping (()->())) {
        let jsonObj: JSON = ["nome": usuario.nome,
                             "email": usuario.email,
                             "senha": Seguranca.duploMD5(usuario.senha),
                             "sexo": usuario.sexo, // ajustar
                             "nascimento": usuario.nascimento]
        let parameters = ["data" : jsonObj]

        Endpoints.shared.makeRequest(apiUrl: Endpoints.shared.setUsuario, method: .post, parameters: parameters, callbackSuccess: { (info:Data?) in
            if let responseData =  info{
                let stringInt = String.init(data: responseData, encoding: String.Encoding.utf8)
                if let num = Int.init(stringInt!) {
                    print(num)
                    callbackSuccess()
                } else {
                    callbackFailure()
                }
            }
        }){ (error) in
            print("Error postUsuario \(error)")
        }
    }
    
    init(_ view: UIViewController) {
        self.view = view
    }
    
}
