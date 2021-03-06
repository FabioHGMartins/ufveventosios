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

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}

class UsuarioRequester {
    
    var view:UIViewController?
    
    //usar callback handleFinish pois é necessário esperar o retorno da aPi antes de poder definir se o login foi feito de forma correta ou não
    func login(user: String, senha: String, handleFinish:@escaping ((ready:Bool,success:Bool))->()){
        self.postUsuarioAuth(user: user, senha: senha, callbackSuccess: { (responseObject) in
            if let usuario = responseObject {
                
                UsuarioSingleton.shared.usuario = usuario
                AppControl.preferences.set(true, forKey: "logado")
                
                if(user == "login_anonimo@anonimo.com"){
                    AppControl.preferences.set(user, forKey: "email")
                }else{
                    AppControl.preferences.set(usuario.email, forKey: "email")
                }
                
                AppControl.preferences.set(senha, forKey: "senha")
                
                let categoriasRequester = CategoriaRequester()
                categoriasRequester.getPreferenciasCategoria(idUsuario: usuario.id) { (ready,success) in
                    if (ready) {
                        if (success) {
                            
                        }
                    }
                }
                
                categoriasRequester.getPreferenciasNotificacoes(idUsuario: usuario.id) { (ready,success) in
                    if (ready) {
                        if (success) {
                            
                        }
                    }
                }
                
                let dispositivoRequester = DispositivoRequester()
                dispositivoRequester.setDispositivo(idUsuario: usuario.id, token: UsuarioSingleton.shared.token!, handlerFinish: { (ready, success) in
                    if (ready) {
                        if (success) {
                            
                        }
                    }
                })
                
                dispositivoRequester.getAgendaNotificacoes(idUsuario: usuario.id, token: UsuarioSingleton.shared.token!, handlerFinish: { (ready, success) in
                    if (ready) {
                        if (success) {
                            
                        }
                    }
                })
                
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
    
    func loginComGoogle(nome: String, email: String, googleId: String, handleFinish:@escaping ((ready:Bool,success:Bool))->()){
        self.setUsuarioGoogle(nome: nome, email: email, googleId: googleId, callbackSuccess: { (responseObject) in
            if let idUsuario = responseObject {
                var usuario = Usuario(id: String(idUsuario), nome: nome, email: email, senha: "", nascimento: "", sexo: "", matricula: "", foto: "", googleId: googleId)
                UsuarioSingleton.shared.usuario = usuario
                print(usuario)
                
                
                AppControl.preferences.set(true, forKey: "logado")
                AppControl.preferences.set(usuario.nome, forKey: "nome")
                AppControl.preferences.set(usuario.email, forKey: "email")
                AppControl.preferences.set(usuario.googleId, forKey: "googleId")
                
                print(UsuarioSingleton.shared.usuario)
                
                let categoriasRequester = CategoriaRequester()
                categoriasRequester.getPreferenciasCategoria(idUsuario: (usuario.id)!) { (ready,success) in
                    if (ready) {
                        if (success) {
                            
                        }
                    }
                }
                
                categoriasRequester.getPreferenciasNotificacoes(idUsuario: (usuario.id)!) { (ready,success) in
                    if (ready) {
                        if (success) {
                            
                        }
                    }
                }
                
                let dispositivoRequester = DispositivoRequester()
                dispositivoRequester.setDispositivo(idUsuario: (usuario.id)!, token: UsuarioSingleton.shared.token!, handlerFinish: { (ready, success) in
                    if (ready) {
                        if (success) {
                            
                        }
                    }
                })
                
                dispositivoRequester.getAgendaNotificacoes(idUsuario: (usuario.id)!, token: UsuarioSingleton.shared.token!, handlerFinish: { (ready, success) in
                    if (ready) {
                        if (success) {
                            
                        }
                    }
                })
                
                handleFinish((ready: true, success: true))
                
                handleFinish((ready: true, success: true))
            } else {
                Alerta.alerta("Erro", msg: "", view: self.view!)
                handleFinish((ready: true, success: false))               
            }
            
        }, callbackFailure: {
            handleFinish((ready: true,success: false))
        })
    }
    
    func postRecuperaSenha(email: String, handleFinish:@escaping ((ready: Bool, success:Bool))->()) {
        let parameters = ["email": email]
        Endpoints.shared.makeRequest(apiUrl: Endpoints.shared.authUsuario, method: .post, parameters: parameters, callbackSuccess: {(info:Data?) in
            handleFinish((true,true))
        }){ (error) in
            print("Error postRecuperaSenha")
            handleFinish((true,false))
        }
    }
    
    //o callback handlefinish é usado para esperar o retorno da api antes de decidir se foi um sucesso ou não
    func cadastrarUsuario(usuario: Usuario, handleFinish:@escaping ((ready: Bool, success:Bool))->()){
        self.postUsuario(usuario: usuario, callbackSuccess: {
            print("Cadastrou")
            self.login(user: usuario.email, senha: usuario.senha) { (ready, success) in
                if(ready) {
                    print("Login")
                    handleFinish((ready: true, success: success))
                }
            }
        }, callbackFailure: {
            Alerta.alerta("Usuário inválido", msg: "O email indicado já foi cadastrado. Por favor, insira um novo email.", view: self.view!)
            print("problema ao cadastrar usuário")
            
            handleFinish((ready: true,success: false))
        })
    }
    
    func atualizarUsuario(usuario: Usuario, att: Bool, usuarioAtual: String, senhaAtual: String, handleFinish:@escaping ((ready: Bool, success:Bool))->()){
        if (att) {
            self.postUsuarioAuth(user: usuarioAtual, senha: senhaAtual, callbackSuccess: { (responseObject) in
                if let usuario = responseObject {
                    handleFinish((ready: true, success: true))
                } else {
                    Alerta.alerta("Credenciais inválidas", msg: "Por favor insira uma combinação válida para o usuário e senha atuais.", view: self.view!)
                    handleFinish((ready: true, success: false))
                }
            }, callbackFailure: { (error) in
                Alerta.alerta("Erro da rede", msg: "Aconteceu um erro inesperado na rede. Por favor, tente novamente.", view: self.view!)
                handleFinish((ready: true, success: false))
            })
        }
        self.putUsuario(usuario: usuario, callbackSuccess: { () in
            AppControl.preferences.set(true, forKey: "logado")
            AppControl.preferences.set(usuario.email, forKey: "email")
            AppControl.preferences.set(usuario.senha, forKey: "senha")
            UsuarioSingleton.shared.usuario = usuario
            UsuarioSingleton.shared.usuario?.senha = Seguranca.duploMD5(usuario.senha)
            print(UsuarioSingleton.shared.usuario)
        }, callbackFailure: {
            Alerta.alerta("Erro de conexão", msg: "Aconteceu algo inesperado na conexão, tente novamente.", view: self.view!)
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
    
    func setUsuarioGoogle(nome: String, email : String, googleId: String, callbackSuccess:@escaping (_ responseObject: Int?)->(), callbackFailure: @escaping (()->())) {
        let jsonObj: JSON = ["nome": nome,
                             "email": email,
                             "googleId": googleId]
        let parameters = ["data" : jsonObj]
        Endpoints.shared.makeRequest(apiUrl: Endpoints.shared.setUsuarioGoogle, method: .post, parameters: parameters, callbackSuccess: {(info:Data?) in
            if let responseData =  info{
                if let stringInt = String(data: responseData, encoding: String.Encoding.utf8){
                    print(stringInt)
                    
                    //TODO: fazer a conversão de string vinda de dados para INT
                    callbackSuccess(Int(stringInt))
                    
                    /*if let num = Int.init(stringInt!) {
                        callbackSuccess(num)
                    } else {
                        callbackFailure()
                    }*/
                    
                }else{
                    callbackFailure()
                }
            }
        }){ (error) in
            print("Error setUsuarioGoogle")
            print(error)
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
                if let stringInt = String(data: responseData, encoding: String.Encoding.utf8){
                    print ("Retorno do cadastro", stringInt.isInt, stringInt) //retirar teste futuramente
                    callbackSuccess()
                    
                    /*if let num = Int.init(stringInt!) {
                        print(num)
                        callbackSuccess()
                    } else {
                        callbackFailure()
                    }*/
                    
                }else{
                    callbackFailure()
                }
            }
        }){ (error) in
            print("Error postUsuario \(error)")
        }
    }
    
    
    
    func putUsuario(usuario: Usuario, callbackSuccess: @escaping (()->()), callbackFailure: @escaping (()->())){
        let jsonObj: JSON = ["nome": usuario.nome,
                             "email": usuario.email,
                             "senha": Seguranca.duploMD5(usuario.senha),
                             "sexo": usuario.sexo, // ajustar
                             "nascimento": usuario.nascimento]
        let parameters = ["data": jsonObj]
        
        Endpoints.shared.makeRequest(apiUrl: Endpoints.shared.updateUsuario(usuario.id), method: .put, parameters: parameters, callbackSuccess: {(info:Data?) in
            callbackSuccess()
        }){ (error) in
            print("Error putUsuario")
            callbackFailure()
        }
    }
    
    init(_ view : UIViewController? = nil) {
        self.view = view
    }
    
}
