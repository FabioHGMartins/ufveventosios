//
//  Dispositivo.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 31/08/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import Foundation

struct Dispositivo: Codable {
    
    var id:String
    var token:String
    var agenda:String
    var notificacoes:String
    
    enum CodingKeys: String, CodingKey {
        // case <variavel> = "<chave do JSON>"
        case id
        case token
        case agenda
        case notificacoes
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(String.self, forKey: .id)
        self.token = try values.decode(String.self, forKey: .token)
        self.agenda = try values.decode(String.self, forKey: .agenda)
        self.notificacoes = try values.decode(String.self, forKey: .notificacoes)
    }
    
    
}
