//
//  File.swift
//  rrm
//
//  Created by Drew Sullivan on 10/28/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import Foundation

extension String {
    func titlecased() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func titlecased() {
        self = self.titlecased()
    }
}
