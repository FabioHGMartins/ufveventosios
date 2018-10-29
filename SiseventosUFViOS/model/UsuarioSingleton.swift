//
//  UsuarioSingleton.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 16/09/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import Foundation

final class UsuarioSingleton {
    
    static public let shared = UsuarioSingleton()

    var usuario: Usuario?
    var categoriasPref: Array<Categoria>? = Array<Categoria>()
    var categoriasUpdate: Bool = true
    
    var token : String?
    var agenda : String?
    var notificacoes : String?
    
    private init() {
        usuario = nil
        token = nil
        agenda = nil
        notificacoes = nil
    }
    
}
