//
//  MyNavigationController.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 29/11/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import UIKit

class MyNavigationController : UINavigationController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        // delega para o view controller atual (o último do array) a decisao da orientacao suportada para o view controller que esta sendo exibido no momento
        return self.topViewController!.supportedInterfaceOrientations
    }
}

