//
//  Alerta.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 16/09/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import Foundation
import UIKit

class Alerta {
    
    static func alerta (_ title : String, msg : String, view: UIViewController ) {
        let alert = UIAlertController(title: title, message : msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        view.present(alert, animated: true, completion: nil)
        
    }
    
}
