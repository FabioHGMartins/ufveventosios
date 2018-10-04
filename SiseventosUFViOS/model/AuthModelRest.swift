//
//  AuthModelRest.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 10/09/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import Foundation
import UIKit

struct AuthModelRest: Codable {
    var email : String
    var senha : String
    
    enum CodingKeys: String, CodingKey {
        case email
        case senha
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.email = try values.decode(String.self, forKey: .email)
        self.senha = try values.decode(String.self, forKey: .senha)
    }
}
