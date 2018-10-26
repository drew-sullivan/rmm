//
//  ContactType.swift
//  rrm
//
//  Created by Drew Sullivan on 10/26/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import Foundation

enum ContactType: UInt32 {
    case linkedIn
    case email
    case phone
    
    private static let _count: ContactType.RawValue = {
        // find the maximum enum value
        var maxValue: UInt32 = 0
        while let _ = ContactType(rawValue: maxValue) {
            maxValue += 1
        }
        return maxValue
    }()
    
    static func randomContactType() -> ContactType {
        // pick and return a new value
        let rand = arc4random_uniform(_count)
        return ContactType(rawValue: rand)!
    }
}
