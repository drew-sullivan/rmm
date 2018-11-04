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
    
    var filteredRecruiters = [Recruiter]()
    
    var positions = [Position]()
    
    init() {
        for _ in 0..<5 {
            generateRecruiter()
        }
        for r in recruiters {
            for p in r.positions {
                positions.append(p)
            }
        }
        positions.sort { $0.status > $1.status }
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
    
    func deletePosition(_ position: Position) {
        if let recruiter = position.recruiter {
            if let index = recruiter.positions.index(of: position) {
                recruiter.positions.remove(at: index)
            }
        }
        if let index = positions.index(of: position) {
            positions.remove(at: index)
        }
    }
    
    func update() {
        determineSections()
    }
    
    fileprivate func determineSections() {
        let recruiterList: [Recruiter]
        if filteredRecruiters.count > 0 {
            recruiterList = filteredRecruiters
        } else {
            recruiterList = recruiters
        }
        let lastNameFirstLetters = recruiterList.map { $0.getFirstLetterOfLastName() }
        let uniqueLastNameFirstLetters = Set<String>(lastNameFirstLetters)
        sortedLastNameFirstLetters = uniqueLastNameFirstLetters.sorted()
        
        sections = sortedLastNameFirstLetters.map { letter in
            return recruiterList
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
