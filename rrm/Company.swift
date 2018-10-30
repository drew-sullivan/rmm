//
//  Company.swift
//  rrm
//
//  Created by Drew Sullivan on 10/28/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import Foundation

class Company {
    var name: String
    var location: String
    
    init(name: String, location: String) {
        self.name = name
        self.location = location
    }
    
    convenience init(random: Bool = false) {
        if random {
            let names = ["Google", "Apple", "Home Advisor", "RandomStartup", "Ultimate Software", "Twitter"]
            let locations = ["Boulder, CO", "Denver, CO", "Mountain View, CA", "Cupertino, CA", "San Jose, CA"]
            
            let randomName = names[Int(arc4random_uniform(UInt32(names.count)))]
            let randomLocation = locations[Int(arc4random_uniform(UInt32(locations.count)))]
            
            self.init(name: randomName, location: randomLocation)
        } else {
            self.init(name: "", location: "")
        }
    }
}
