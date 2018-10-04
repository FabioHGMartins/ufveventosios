//
//  Categoria.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 31/08/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import Foundation
struct Categoria:Codable, Equatable {
    
    var id:String
    var nome: String
    
    // MAPEAMENTO VARIAVEL/CHAVE
    enum CodingKeys: String, CodingKey {
        // case <variavel> = "<chave do JSON>"
        case id = "id"
        case nome = "nome"
    }
    
    static func == (lhs:Categoria, rhs:Categoria) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(String.self, forKey: .id)
        self.nome = try values.decode(String.self, forKey: .nome)
    }
    
    init(_ id: String, _ nome: String) {
        self.id = id
        self.nome = nome
    }
    
}
