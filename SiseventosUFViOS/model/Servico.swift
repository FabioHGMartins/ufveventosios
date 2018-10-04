//
//  Servico.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 31/08/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import Foundation
struct Servico:Codable {
    
    var id:String
    var descricao: String
    
    // MAPEAMENTO VARIAVEL/CHAVE
    enum CodingKeys: String, CodingKey {
        // case <variavel> = "<chave do JSON>"
        case id = "id"
        case descricao = "descricao"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(String.self, forKey: .id)
        self.descricao = try values.decode(String.self, forKey: .descricao)
    }
    
}
