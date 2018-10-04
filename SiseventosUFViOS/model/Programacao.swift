//
//  Programacao.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 31/08/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import Foundation

struct Programacao: Codable {
    
    var idprog: String
    var horainicioprog:String
    var horafimprog:String
    var datainicioprog:String
    var datafimprog: String
    var descricaoprog: String
    
    // MAPEAMENTO VARIAVEL/CHAVE
    enum CodingKeys: String, CodingKey {
        // case <variavel> = "<chave do JSON>"
        case idprog
        case horainicioprog
        case horafimprog
        case datainicioprog
        case datafimprog
        case descricaoprog
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.idprog = try values.decode(String.self, forKey: .idprog)
        self.horainicioprog = try values.decode(String.self, forKey: .horainicioprog)
        self.horafimprog = try values.decode(String.self, forKey: .horafimprog)
        self.datainicioprog = try values.decode(String.self, forKey: .datainicioprog)
        self.datafimprog = try values.decode(String.self, forKey: .datafimprog)
        self.descricaoprog = try values.decode(String.self, forKey: .descricaoprog)
    }
    
}
