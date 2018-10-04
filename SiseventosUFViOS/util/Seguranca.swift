//
//  Seguranca.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 10/09/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import Foundation


struct Seguranca {
    
    static func MD5(_ string: String) -> String {
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
    
    static func duploMD5(_ string:String) -> String {
        return MD5(MD5(string))
    }

    
}
