//
//  PositionStatus.swift
//  rrm
//
//  Created by Drew Sullivan on 11/4/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import Foundation

enum PositionStatus: String, CaseIterable {
    case inactive = "Inactive"
    case resumeSubmitted = "Resume Submitted"
    case phoneScreenScheduled = "Phone Screen Scheduled"
    case onSiteScheduled = "On-Site Scheduled"
    case waitingForResponse = "Waiting for Response"
    case offerReceived = "Offer Received"
    
    static func ==(lhs: PositionStatus, rhs: PositionStatus) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    static func <(lhs: PositionStatus, rhs: PositionStatus) -> Bool {
        return lhs.hashValue < rhs.hashValue
    }
    
    static func >(lhs: PositionStatus, rhs: PositionStatus) -> Bool {
        return lhs.hashValue > rhs.hashValue
    }
}
