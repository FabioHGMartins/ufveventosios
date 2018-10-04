//
//  API.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 31/08/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

final class Endpoints {
    
    static public let shared = Endpoints()
    
    // ---- HEADERS ----
    static var headers: HTTPHeaders {
        return [
            "Authorization" : "Basic 45dfd94be4b30d5844d2bcca2d997db0",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
    }
    
    // ---- ENDPOINTS ----
    
    // URL BASE
    
    let baseUrl = "http://www.siseventos.ufv.br/API/api.php/"
    
    // GET
    
    func eventosPorUsuario (_ idUsuario: String, _ offset: Int, _ limit: Int) -> String {
        return "evento/categoria/personalizado/idusuario/\(idUsuario)/indexinicial/\(offset)/indexfinal/\(limit)"
    }
    
    func eventos (_ offset: Int, _ limit: Int) -> String {
        return "evento/indexinicial/\(offset)/indexfinal/\(limit)"
    }
    
    func getPreferenciasDeNotificacoes (_ idUsuario: String) -> String {
        return "preferencias_notificacoes/\(idUsuario)"
    }
    
    func getPreferenciasDeCategorias (_ idUsuario: String) -> String {
        return "preferencias_categorias/\(idUsuario)"
    }
    
    func categoria() -> String {
        return "categoria"
    }
    
    // POST
    
    let getCalendar = "getcalendar"
    let recuperaSenha = "email"
    let authUsuario = "usuario_auth"
    let setUsuario = "usuario"
    let setUsuarioGoogle = "usuario_google"
    let setDispositivo = "dispositivos"
    let getAgendaNotificacoes = "agenda_notificacoes"
    let addAgenda = "calendar"
    let deleteAgenda = "deletecalendar"
    let preferenciasCategorias = "preferencias_categorias"
    
    // PUT
    
    func updateUsuario(_ idUsuario: String) -> String {
        return "usuario/{idUsuario}"
    }
    
    func updateNotificacoes() -> String {
        return "notificacoes"
    }
    
    func updateAgenda() -> String {
        return "agenda"
    }
    
    func updatePreferenciasDeNotificacoes (_ idUsuario: String) -> String {
        return "preferencias_notificacoes/\(idUsuario)"
    }
    
    func updatePreferenciasDeCategorias (_ idUsuario: String) -> String {
        return "preferencias_categorias/\(idUsuario)"
    }
    
    
    // ---- FUNCAO PARA REQUISICAO À API ----
    func makeRequest(apiUrl : String, method: HTTPMethod, parameters:Parameters?, callbackSuccess:@escaping (Data?) -> (), callbackFailure:@escaping (Data?) -> ()){
        let url = baseUrl + apiUrl
        
        Alamofire.request(url, method: method, parameters: parameters, headers: Endpoints.headers)
            .validate()
            .responseString { (response) in
                switch response.result{
                    case .success:
                        print("Sucesso no request")
                        callbackSuccess(response.data)
                        break;
                    
                    case .failure(let error):
                        print("Falha no request: \(error)")
                        callbackFailure(response.data)
                        break;
                }
        }
        
    }
    
    
    //RESTO
    
    private init() {
        
    }
    
}

