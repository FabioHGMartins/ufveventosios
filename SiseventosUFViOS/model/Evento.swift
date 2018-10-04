//
//  Evento.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 31/08/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import Foundation

struct Evento: Codable {
    
    var id:String!
    var denominacao: String!
    var horainicio: String!
    var horafim: String!
    var datainicio: String!
    var datafim: String!
    var descricao_evento: String!
    var participantes: String!
    var publico: String!
    var teminscricao:String!
    var valorinscricao:String!
    var linklocalinscricao:String!
    var mostrarparticipantes: String!
    
    var programacoes: Array<Programacao>!
    var categorias: Array<Categoria>!
    var locais: Array<Local>!
    var servicos: Array<Servico>!
    
    enum CodingKeys: String, CodingKey {
        case id
        case denominacao
        case horainicio
        case horafim
        case datainicio
        case datafim
        case descricao_evento
        case participantes
        case publico
        case teminscricao
        case valorinscricao
        case linklocalinscricao
        case mostrarparticipantes
        case programacoes
        case categorias
        case locais
        case servicos
    }
    
    init() {
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(String.self, forKey: .id)
        self.denominacao = try values.decode(String.self, forKey: .denominacao)        
        self.horainicio = try values.decode(String.self, forKey: .horainicio)
        self.horafim = try values.decode(String.self, forKey: .horafim)
        self.datainicio = try values.decode(String.self, forKey: .datainicio)
        self.datafim = try values.decode(String.self, forKey: .datafim)
        self.descricao_evento = try values.decode(String.self, forKey: .descricao_evento)
        self.participantes = try values.decode(String.self, forKey: .participantes)
        self.publico = try values.decode(String.self, forKey: .publico)
        self.teminscricao = try values.decode(String.self, forKey: .teminscricao)
        self.valorinscricao = try values.decode(String.self, forKey: .valorinscricao)
        self.linklocalinscricao = try values.decode(String.self, forKey: .linklocalinscricao)
        self.mostrarparticipantes = try values.decode(String.self, forKey: .mostrarparticipantes)
        self.programacoes = try values.decode(Array<Programacao>.self, forKey: .programacoes)
        self.categorias = try values.decode(Array<Categoria>.self, forKey: .categorias)
        self.locais = try values.decode(Array<Local>.self, forKey: .locais)
        self.servicos = try values.decode(Array<Servico>.self, forKey: .servicos)
    }
    
}
