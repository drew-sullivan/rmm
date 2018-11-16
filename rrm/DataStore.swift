//
//  dataStore.swift
//  rrm
//
//  Created by Drew Sullivan on 10/26/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DataStore {
    
    var recruiters = [Recruiter]()
    var sections: [[Recruiter]] = []
    var sortedLastNameFirstLetters: [String] = []
    
    var filteredRecruiters = [Recruiter]()
    var positions = [Position]()
    
    var imageCache = NSCache<NSString, UIImage>()
    
    let rootRef = Database.database().reference()
    let recruitersRef: DatabaseReference
    let positionsRef: DatabaseReference
    
    init() {
        recruitersRef = rootRef.child("recruiters")
        positionsRef = rootRef.child("positions")
        
//        for _ in 0..<25 {
//            generateRecruiter()
//        }
        
        for r in recruiters {
            for p in r.positions {
                p.recruiterID = r.id
                positions.append(p)
            }
        }
        
        positions.sort { $0.status > $1.status }
        determineSections()
    }
    
    // MARK: - Sample data
    @discardableResult func generateRecruiter() -> Recruiter {
        let generatedRecruiter = Recruiter(random: true)
        let updatedRecruiters = addNewRecruiterAlphabetically(recruiters: recruiters, newRecruiter: generatedRecruiter)
        recruiters = updatedRecruiters
        determineSections()
        return generatedRecruiter
    }
    
    // MARK: - Caching
    func cacheImage(_ image: UIImage, forKey key: String) {
        imageCache.setObject(image, forKey: key as NSString)
    }
    
    func retrieveImageFromCache(by key: String) -> UIImage? {
        return imageCache.object(forKey: key as NSString)
    }
    
    func deleteImageFromCache(by key: String) {
        imageCache.removeObject(forKey: key as NSString)
    }

    // MARK: - data fetching
    func fetchLogo(by companyName: String, completion: @escaping (UIImage) -> Void) {
        if let image = self.retrieveImageFromCache(by: companyName) {
            OperationQueue.main.addOperation {
                completion(image)
            }
            return
        }
        ClearbitAPI.getCompanyLogoURL(from: companyName) { (image) in
            self.cacheImage(image, forKey: companyName)
            completion(image)
        }
    }
    
    // MARK: - CRUD - Recruiter
    func addRecruiter(_ recruiter: Recruiter) {
        recruiters.append(recruiter)
        determineSections()
        
        let singleRecRef = recruitersRef.child(recruiter.id.uuidString)
        let fbRec = recruiter.toDict()
        singleRecRef.setValue(fbRec)
    }
    
    func deleteRecruiter(_ recruiter: Recruiter) {
        if let index = recruiters.index(of: recruiter) {
            recruiters.remove(at: index)
        }
        determineSections()
        
        recruitersRef.child(recruiter.id.uuidString).removeValue()
    }
    
    func updateRecruiter(_ recruiter: Recruiter) {
        let singleRecRef = recruitersRef.child(recruiter.id.uuidString)
        singleRecRef.setValue(recruiter.toDict())
    }
    
    // MARK: - CRUD - Position
    func addPosition(_ position: Position) {
        positions.append(position)
        positions.sort { $0.status > $1.status }
        
        let singlePositionRef = positionsRef.child(position.id.uuidString)
        singlePositionRef.setValue(position.toDict())
    }
    
    func deletePosition(_ position: Position) {
        for recruiter in recruiters {
            if recruiter.positions.contains(position) {
                if let index = recruiter.positions.index(of: position) {
                    recruiter.positions.remove(at: index)
                }
            }
        }
        if let index = positions.index(of: position) {
            positions.remove(at: index)
        }
        
        positionsRef.child(position.id.uuidString).removeValue()
    }
    
    func updatePosition(position: Position) {
        let singlePositionRef = positionsRef.child(position.id.uuidString)
        singlePositionRef.setValue(position.toDict())
    }
    
    // MARK: - Fetch position data
    func fetchPositionData(completion: @escaping ([Position]) -> Void) {
        positionsRef.observe(.value, with: { snapshot in
            print(snapshot)
            var fetchedPositions = [Position]()

            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot {
                    let position = self.processSnapshot(childSnapshot: childSnapshot)
                    fetchedPositions.append(position!)
                }
            }
            completion(fetchedPositions)
        })
    }
    
    // MARK: - Updating data for UI
    func sortPositions() {
        positions.sort { $0.status > $1.status }
    }
    
    func updateDataForUI() {
        determineSections()
    }
    
    // MARK: - Helpers
    private func processSnapshot(childSnapshot: DataSnapshot) -> Position? {
        guard let value = childSnapshot.value as? [String: Any] else { return nil }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
            let p = try JSONDecoder().decode(Position.self, from: jsonData)
            return p
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
    
    private func determineSections() {
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
    
    private func addNewRecruiterAlphabetically(recruiters: [Recruiter], newRecruiter: Recruiter) -> [Recruiter] {
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
    
    private func getNameRelationshipStatus(oldPerson oldName: String, newPerson newName: String) -> NameRelationshipStatus {
        if oldName == newName {
            return NameRelationshipStatus.equal
        } else if oldName > newName {
            return NameRelationshipStatus.olderNameIsGreater
        } else {
            return NameRelationshipStatus.newerNameIsGreater
        }
    }
}
