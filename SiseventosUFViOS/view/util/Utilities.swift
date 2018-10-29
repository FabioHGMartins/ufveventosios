//
//  Utilities.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 22/10/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import Foundation
//class Utilities {
//
//}



func formatarData(valor: String, formatoAtual: String, formatoNovo:String) -> String{
    let atual = DateFormatter()
    atual.dateFormat = formatoAtual
    
    let novo = DateFormatter()
    novo.dateFormat = formatoNovo    
    
    let valorNovo:String = novo.string(from: atual.date(from: valor)!)
    return "\(valorNovo)"
}
