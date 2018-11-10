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
    var phoneNumber: String
    var emailAddress: String
    var positions: [Position]
    var printableName: String {
        return "\(firstName) \(lastName)"
    }
    
    init(firstName: String, lastName: String, employer: String, phoneNumber: String, emailAddress: String, positions: [Position]) {
        self.firstName = firstName
        self.lastName = lastName
        self.employer = employer
        self.phoneNumber = phoneNumber
        self.emailAddress = emailAddress
        self.positions = positions
    }
    
    convenience init(random: Bool = false) {
        if random {
            let potentialFirstNames = ["Dan", "Autumn", "Willow", "James", "John", "Alicia"]
            let potentialLastNames = ["Evans", "Smith", "Ashkenasi", "Johnson", "Ross", "Jackson"]
            let potentialEmployers = ["CyberCoders", "Integrity Power Search", "TechUServ", "Initrode", "Initech"]
            
            let randFirstName = potentialFirstNames[Int(arc4random_uniform(UInt32(potentialFirstNames.count)))]
            let randLastName = potentialLastNames[Int(arc4random_uniform(UInt32(potentialFirstNames.count)))]
            let randEmployer = potentialEmployers[Int(arc4random_uniform(UInt32(potentialEmployers.count)))]
            let randPhoneNumber = "(\(Int(arc4random_uniform(UInt32(899))) + 100))-\(Int(arc4random_uniform(UInt32(899))) + 100)-\(Int(arc4random_uniform(UInt32(10000))))"
            let randEmailAddress = "\(randFirstName).\(randLastName)@\(randEmployer.trimmingCharacters(in: .whitespaces)).com"
            
            let numRandPositions = Int(arc4random_uniform(UInt32(3)))
            var randPositions = [Position]()
            for _ in 0..<numRandPositions {
                randPositions.append(Position(random: true))
            }
            
            self.init(firstName: randFirstName, lastName: randLastName, employer: randEmployer, phoneNumber: randPhoneNumber, emailAddress: randEmailAddress, positions: randPositions)
        } else {
            self.init(firstName: "", lastName: "", employer: "", phoneNumber: "", emailAddress: "", positions: [])
        }
    }
    
    func getFirstLetterOfFirstName() -> String {
        return String(self.firstName[firstName.startIndex])
    }
    
    func getFirstLetterOfLastName() -> String {
        return String(self.lastName[lastName.startIndex])
    }
    
    func deletePosition(position: Position) {
        if let index = positions.index(of: position) {
            positions.remove(at: index)
        }
    }
    
    func addPosition(position: Position) {
        positions.insert(position, at: 0)
    }
}
