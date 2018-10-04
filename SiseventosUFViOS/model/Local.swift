//
//  Local.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 31/08/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import Foundation

struct Local:Codable {

    var id:String
    var descricao:String
    var lat:String
    var lng:String
    
    enum CodingKeys: String, CodingKey {
        case id
        case descricao
        case lat
        case lng
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(String.self, forKey: .id)
        self.descricao = try values.decode(String.self, forKey: .descricao)
        self.lat = try values.decode(String.self, forKey: .lat)
        self.lng = try values.decode(String.self, forKey: .lng)
    }
    
}
