//
//  CategoriaRequester.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 28/09/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CategoriaRequester {
    
    
    func getCategoria(handlerFinish: @escaping ((_ ready:Bool, _ success:Bool)->())){
        let parameters = ["": ""]
        
        Endpoints.shared.makeRequest(apiUrl: Endpoints.shared.categoria(), method: .get, parameters: parameters, callbackSuccess: {(info:Data?) in
            var categorias: Array<Categoria>?
            if let responseData =  info{
                let decoder = JSONDecoder()
                categorias = try? decoder.decode(Array<Categoria>.self, from: responseData)
            }
            EventosSingleton.shared.categorias = categorias
            
            handlerFinish(true,true)
        }){ (error) in
            print("Error getCategoria")
            handlerFinish(true,false)
            
        }
    }
    
    func getPreferenciasCategoria(idUsuario:String,handlerFinish: @escaping ((_ ready:Bool, _ success:Bool)->())){
        let parameters = ["": ""]
        
        Endpoints.shared.makeRequest(apiUrl: Endpoints.shared.getPreferenciasDeCategorias(idUsuario), method: .get, parameters: parameters, callbackSuccess: {(info:Data?) in
            var categorias: Array<Categoria>?
            if let responseData =  info{
                let decoder = JSONDecoder()
                categorias = try? decoder.decode(Array<Categoria>.self, from: responseData)
            }
            UsuarioSingleton.shared.categoriasPref = categorias!
            
            handlerFinish(true,true)
        }){ (error) in
            print("Error getPreferenciasCategoria")
            handlerFinish(true,false)
            
        }
    }
    
    func postPreferenciasCategorias(idUsuario:String, idCategorias: Array<String>, handlerFinish: @escaping ((_ ready:Bool, _ success:Bool)->())){
        let jsonObj : JSON = ["usuario": idUsuario, "categorias": idCategorias]
        let parameters = ["data": jsonObj]
        
        Endpoints.shared.makeRequest(apiUrl: Endpoints.shared.preferenciasCategorias, method: .post, parameters: parameters, callbackSuccess: {(info:Data?) in
            handlerFinish(true,true)
        }){ (error) in
            print("Error postPreferenciasCategorias")
            handlerFinish(true,false)
        }
    }
    
}
