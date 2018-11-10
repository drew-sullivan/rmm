//
//  Position.swift
//  rrm
//
//  Created by Drew Sullivan on 10/26/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import Foundation

class Position: NSObject {
    var status: PositionStatus
    var dateApplied: Date
    var company: Company
    var title: String
    var salary: String
    var recruiter: Recruiter?
    
    init(status: PositionStatus, dateApplied: Date, company: Company, title: String, salary: String) {
        self.status = status
        self.dateApplied = dateApplied
        self.company = company
        self.title = title
        self.salary = salary
    }
    
    convenience init(random: Bool = false) {
        if random {
            let randomStatus = PositionStatus.allCases[Int(arc4random_uniform(UInt32(PositionStatus.allCases.count)))]
            
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
            
            let randomCompany = Company(random: true)
            
            let possibleTitles = ["Android Developer", "iOS Developer", "Web Developer", "Front-End Developer"]
            let randomTitle = possibleTitles[Int(arc4random_uniform(UInt32(possibleTitles.count)))]
            
            let highBound = 105000
            let wiggleRoom = 10000
            let randomSalary = Int(arc4random_uniform(UInt32(wiggleRoom))) + highBound
            
            self.init(status: randomStatus,
                      dateApplied: randomDate!,
                      company: randomCompany,
                      title: randomTitle,
                      salary: "\(randomSalary)")
        }
        else {
            self.init(status: .inactive,
                      dateApplied: Date(),
                      company: Company(random: true),
                      title: "",
                      salary: "0")
        }
    }
    
    
}
