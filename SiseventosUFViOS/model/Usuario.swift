//
//  Usuario.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 31/08/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import Foundation
struct Usuario:Codable {
    
    var id:String!
    var nome: String!
    var email: String!
    var senha: String!
    var nascimento: String!
    var sexo: String!
    var matricula : String!
    var foto : String!
    var googleId: String!
    
    
    // MAPEAMENTO VARIAVEL/CHAVE
    enum CodingKeys: String, CodingKey {
        // case <variavel> = "<chave do JSON>"
        case id
        case nome
        case email
        case senha
        case nascimento
        case sexo
        case foto
        case googleId
        
    }
    
    init(id: String = "", nome : String, email: String, senha: String, nascimento: String, sexo: String, matricula : String = "", foto: String = "", googleId: String = "") {
        self.id = id
        self.nome = nome
        self.email = email
        self.senha = senha
        self.nascimento = nascimento
        self.sexo = sexo
        self.matricula = matricula
        self.foto = foto
        self.googleId = googleId
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(String.self, forKey: .id)
        self.nome = try values.decode(String.self, forKey: .nome)
        self.email = try values.decode(String.self, forKey: .email)
        self.senha = try values.decode(String.self, forKey: .senha)
        self.nascimento = try values.decode(String.self, forKey: .nascimento)
        self.sexo = try values.decode(String.self, forKey: .sexo)
        self.matricula = ""
        self.foto = try values.decode(String.self, forKey: .foto)
        self.googleId = try values.decode(String.self, forKey: .googleId)
    }
    
}
