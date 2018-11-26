//
//  FirebaseConvertible.swift
//  rrm
//
//  Created by Drew Sullivan on 11/15/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import Foundation

class FirebaseConverter {
    @discardableResult static func toDict(instanceOf classInstance: Any) -> [String: Any] {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        let jsonData = try! jsonEncoder.encode(classInstance)
        
        let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
        
        if let object = json as? [String: Any] {
            return object
        } else {
            print("JSON is invalid")
        }
        return [:]
    }
}
