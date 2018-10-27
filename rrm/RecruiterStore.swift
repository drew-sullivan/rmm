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
    
    init() {
        for _ in 0..<5 {
            recruiters.append(Recruiter(random: true))
        }
    }
    
    @discardableResult func generateRecruiter() -> Recruiter {
        let generatedRecruiter = Recruiter(random: true)
        recruiters.append(generatedRecruiter)
        return generatedRecruiter
    }
}
