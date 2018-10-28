//
//  RecruiterStore.swift
//  rrm
//
//  Created by Drew Sullivan on 10/26/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import UIKit

class RecruiterStore {
    
    var recruiters = [Recruiter]()
    var sections: [[Recruiter]] = []
    var sortedLastNameFirstLetters: [String] = []
    
    init() {
        for _ in 0..<5 {
            generateRecruiter()
        }
        determineSections()
    }
    
    @discardableResult func generateRecruiter() -> Recruiter {
        let generatedRecruiter = Recruiter(random: true)
        recruiters.append(generatedRecruiter)
        determineSections()
        return generatedRecruiter
    }
    
    func deleteRecruiter(_ recruiter: Recruiter) {
        if let index = recruiters.index(of: recruiter) {
            recruiters.remove(at: index)
        }
        determineSections()
    }
    
    fileprivate func determineSections() {
        let lastNameFirstLetters = recruiters.map { $0.getFirstLetterOfLastName() }
        let uniqueLastNameFirstLetters = Set<String>(lastNameFirstLetters)
        sortedLastNameFirstLetters = uniqueLastNameFirstLetters.sorted()
        
        sections = sortedLastNameFirstLetters.map { letter in
            return recruiters
                .filter { $0.getFirstLetterOfLastName() == letter }
                .sorted {
                    if $0.lastName != $1.lastName {
                        return $0.lastName < $1.lastName
                    } else {
                        return $0.firstName < $1.firstName
                    }
            }
        }
    }
}
