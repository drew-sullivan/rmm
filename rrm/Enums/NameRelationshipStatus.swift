//
//  NameRelationshipStatus.swift
//  rrm
//
//  Created by Drew Sullivan on 10/31/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import Foundation

enum NameRelationshipStatus: String, Codable {
    case equal
    case olderNameIsGreater
    case newerNameIsGreater
}
