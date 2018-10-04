//
//  EventosRequester.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 23/09/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class EventosRequester {
    
    func getEventos(offset:Int, limit:Int, handlerFinish: @escaping ((_ ready:Bool, _ success:Bool)->())) {
        let parameters = ["":""]
        Endpoints.shared.makeRequest(apiUrl: Endpoints.shared.eventos(offset, limit), method: .get, parameters: parameters, callbackSuccess:{ (info:Data?) in
            
            var eventos: Array<Evento>?
            if let responseData = info {
                print(responseData)
                let decoder = JSONDecoder()
                do {
                    try eventos = decoder.decode(Array<Evento>.self, from: responseData)
                } catch {
                    print(error)
                }
                
            }
            
            EventosSingleton.shared.eventos = eventos
            handlerFinish(true,true)
            
        }) { (error) in
            print("Error getEventos \(String(describing: error))")
            handlerFinish(true,false)
        }
    }
    
}
