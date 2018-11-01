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
        let updatedRecruiters = addNewRecruiterAlphabetically(recruiters: recruiters, newRecruiter: generatedRecruiter)
        recruiters = updatedRecruiters
        determineSections()
        return generatedRecruiter
    }
    
    func addRecruiter(_ recruiter: Recruiter) {
        recruiters.append(recruiter)
        determineSections()
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
            return recruiters.filter { $0.getFirstLetterOfLastName() == letter }
        }
    }
    
    func addNewRecruiterAlphabetically(recruiters: [Recruiter], newRecruiter: Recruiter) -> [Recruiter] {
        var recruiterAdded = false
        var newList = [Recruiter]()
        guard recruiters.count > 0 else {
            newList.append(newRecruiter)
            return newList
        }
        for r in recruiters {
            if !recruiterAdded {
                let lastNameRelationshipStatus = getNameRelationshipStatus(oldPerson: r.lastName, newPerson: newRecruiter.lastName)
                if lastNameRelationshipStatus == .olderNameIsGreater {
                    newList.append(newRecruiter)
                    recruiterAdded = true
                } else if lastNameRelationshipStatus == .equal {
                    let firstNameRelationshipStatus = getNameRelationshipStatus(oldPerson: r.firstName, newPerson: newRecruiter.firstName)
                    if firstNameRelationshipStatus == .olderNameIsGreater || firstNameRelationshipStatus == .equal {
                        newList.append(newRecruiter)
                        recruiterAdded = true
                    }
                }
            }
            newList.append(r)
        }
        if !recruiterAdded {
            newList.append(newRecruiter)
        }
        return newList
    }
    
    fileprivate func getNameRelationshipStatus(oldPerson oldName: String, newPerson newName: String) -> NameRelationshipStatus {
        if oldName == newName {
            return NameRelationshipStatus.equal
        } else if oldName > newName {
            return NameRelationshipStatus.olderNameIsGreater
        } else {
            return NameRelationshipStatus.newerNameIsGreater
        }
    }
}
