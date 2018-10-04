//
//  EventosSingleton.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 23/09/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import Foundation

class EventosSingleton {
    static public let shared = EventosSingleton()
    
    var eventos:Array<Evento>! = Array<Evento>()
    var categorias:Array<Categoria>! = Array<Categoria>()

    private init() {
        
    }
}
