//
//  DispositivoRequester.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 14/07/19.
//  Copyright © 2019 Fabio Martins. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DispositivoRequester {
    
    func setDispositivo(idUsuario: String, token: String, handlerFinish: @escaping ((_ ready:Bool, _ success:Bool)->())) {
        let jsonObj: JSON = ["usuario": idUsuario,
                             "token": token]
        let parameters = ["data": jsonObj]
        
        Endpoints.shared.makeRequest(apiUrl: Endpoints.shared.setDispositivo, method: .post, parameters: parameters, callbackSuccess: { (info:Data?) in
            if let responseData =  info{
                let stringInt = String.init(data: responseData, encoding: String.Encoding.utf8)
                if let num = Int.init(stringInt!) {
                    print("setDispositivo deu bom")
                    handlerFinish(true,true)
                } else {
                    print("setDispositivo deu ruim")
                    handlerFinish(true,false)
                }
            }
        }){ (error) in
            print("Error setDispositivo \(error)")
            handlerFinish(true,false)
        }
    }
    
    func getAgendaNotificacoes(idUsuario: String, token: String, handlerFinish: @escaping ((_ ready:Bool, _ success:Bool)->())) {
        let jsonObj: JSON = ["usuario": idUsuario,
                             "token": token]
        let parameters = ["data": jsonObj]
        
        Endpoints.shared.makeRequest(apiUrl: Endpoints.shared.getAgendaNotificacoes, method: .post, parameters: parameters, callbackSuccess: { (info:Data?) in
            var dispositivo: Dispositivo?
            if let responseData =  info{
                let decoder = JSONDecoder()
                dispositivo = try? decoder.decode(Dispositivo.self, from: responseData)
                UsuarioSingleton.shared.agenda = dispositivo?.agenda
                UsuarioSingleton.shared.notificacoes = dispositivo?.notificacoes
                print("getAgendaNotificacoes deu bom")
                handlerFinish(true,true)
            }
        }){ (error) in
            print("Error getAgendaNotificacoes \(error)")
            handlerFinish(true,false)
        }
    }
}
