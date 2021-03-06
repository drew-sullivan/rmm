//
//  Recruiter.swift
//  rrm
//
//  Created by Drew Sullivan on 10/26/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Recruiter: NSObject, Codable {
    var id: UUID
    var firstName: String
    var lastName: String
    var employer: String
    var phoneNumber: String
    var emailAddress: String
    
    var printableName: String {
        return "\(firstName) \(lastName)"
    }
    
    init(firstName: String, lastName: String, employer: String, phoneNumber: String, emailAddress: String) {
        self.id = UUID()
        self.firstName = firstName
        self.lastName = lastName
        self.employer = employer
        self.phoneNumber = phoneNumber
        self.emailAddress = emailAddress
    }
    
    @discardableResult func toDict() -> [String: Any] {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        let jsonData = try! jsonEncoder.encode(self)
                
        let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
        
        if let object = json as? [String: Any] {
            return object
        } else {
            print("JSON is invalid")
        }
        return [:]
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
            
            self.init(firstName: randFirstName, lastName: randLastName, employer: randEmployer, phoneNumber: randPhoneNumber, emailAddress: randEmailAddress)
        } else {
            self.init(firstName: "", lastName: "", employer: "", phoneNumber: "", emailAddress: "")
        }
    }
    
    func getFirstLetterOfFirstName() -> String {
        return String(self.firstName[firstName.startIndex])
    }
    
    func getFirstLetterOfLastName() -> String {
        return String(self.lastName[lastName.startIndex])
    }
}
