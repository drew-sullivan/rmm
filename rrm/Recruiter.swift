//
//  Recruiter.swift
//  rrm
//
//  Created by Drew Sullivan on 10/26/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import Foundation

class Recruiter: NSObject {
    var firstName: String
    var lastName: String
    var employer: String
    var positions = [Position]()
    init(firstName: String, lastName: String, employer: String, position: Position) {
        self.firstName = firstName
        self.lastName = lastName
        self.employer = employer
        self.positions.append(position)
    }
    
    convenience init(random: Bool = false) {
        if random {
            let potentialFirstNames = ["Dan", "Autumn", "Willow", "James", "John", "Alicia"]
            let potentialLastNames = ["Evans", "Smith", "Ashkenasi", "Johnson", "Ross", "Jackson"]
            let potentialEmployers = ["CyberCoders", "Integrity Power Search", "TechUServ", "Initrode", "Initech"]
            
            let randFirstName = potentialFirstNames[Int(arc4random_uniform(UInt32(potentialFirstNames.count)))]
            let randLastName = potentialLastNames[Int(arc4random_uniform(UInt32(potentialFirstNames.count)))]
            let randEmployer = potentialEmployers[Int(arc4random_uniform(UInt32(potentialEmployers.count)))]
            let randPosition = Position(random: true)
            
            self.init(firstName: randFirstName, lastName: randLastName, employer: randEmployer, position: randPosition)
        } else {
            self.init(firstName: "", lastName: "", employer: "", position: Position(random: true))
        }
    }
    
    func getFirstLetterOfFirstName() -> String {
        return String(self.firstName[firstName.startIndex])
    }
    
    func getFirstLetterOfLastName() -> String {
        return String(self.lastName[lastName.startIndex])
    }
}
