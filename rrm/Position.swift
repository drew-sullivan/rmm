//
//  Position.swift
//  rrm
//
//  Created by Drew Sullivan on 10/26/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import Foundation

class Position {
    var dateContacted: Date
    var contactType: ContactType
    var title: String
    var salaryLow: Int
    var salaryHigh: Int
    init(dateContacted: Date, contactType: ContactType, title: String, salaryLow: Int, salaryHigh: Int) {
        self.dateContacted = dateContacted
        self.contactType = contactType
        self.title = title
        self.salaryLow = salaryLow
        self.salaryHigh = salaryHigh
    }
    
    convenience init(random: Bool = false) {
        if random {
            let numDaysBack = 180
            let day = arc4random_uniform(UInt32(numDaysBack)) + 1
            let hour = arc4random_uniform(23)
            let minute = arc4random_uniform(59)
            
            let today = Date(timeIntervalSinceNow: 0)
            let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
            var offsetComponents = DateComponents()
            offsetComponents.day = -Int(day - 1)
            offsetComponents.hour = Int(hour)
            offsetComponents.minute = Int(minute)
            
            let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0))
            
            let randomContactType = ContactType.randomContactType()
            
            let possibleTitles = ["Android Developer", "iOS Developer", "Web Developer", "Front-End Developer"]
            let randomTitle = possibleTitles[Int(arc4random_uniform(UInt32(possibleTitles.count)))]
            
            let lowBound = 85000
            let highBound = 105000
            let wiggleRoom = 10000
            let randomSalaryLow = Int(arc4random_uniform(UInt32(wiggleRoom))) + lowBound
            let randomSalaryHigh = Int(arc4random_uniform(UInt32(wiggleRoom))) + highBound
            
            self.init(dateContacted: randomDate!,
                      contactType: randomContactType,
                      title: randomTitle,
                      salaryLow: randomSalaryLow,
                      salaryHigh: randomSalaryHigh)
        }
        else {
            self.init(dateContacted: Date(),
                      contactType: ContactType.email,
                      title: "",
                      salaryLow: 0,
                      salaryHigh: 0)
        }
    }
    
    
}
