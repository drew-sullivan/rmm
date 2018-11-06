//
//  PositionStatus.swift
//  rrm
//
//  Created by Drew Sullivan on 11/4/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import Foundation
import UIKit

enum PositionStatus: String, CaseIterable {
    case inactive = "Inactive"
    case resumeSubmitted = "Resume Submitted"
    case phoneScreenScheduled = "Phone Screen Scheduled"
    case onSiteScheduled = "On-Site Scheduled"
    case waitingForResponse = "Waiting for Response"
    case offerReceived = "Offer Received"
    
    private var sortOrder: Int {
        switch self {
        case .inactive:
            return 0
        case .resumeSubmitted:
            return 1
        case .phoneScreenScheduled:
            return 2
        case .onSiteScheduled:
            return 3
        case .waitingForResponse:
            return 4
        case .offerReceived:
            return 5
        }
    }
    
    func backgroundColor() -> UIColor {
        switch self {
        case .inactive:
            return UIColor(rgb: 0xffffd9)
        case .resumeSubmitted:
            return UIColor(rgb: 0xedf8b1)
        case .phoneScreenScheduled:
            return UIColor(rgb: 0xc7e9b4)
        case .onSiteScheduled:
            return UIColor(rgb: 0x7fcdbb)
        case .waitingForResponse:
            return UIColor(rgb: 0x41b6c4)
        case .offerReceived:
            return UIColor(rgb: 0x1d91c0)
        }
    }
    
    static func ==(lhs: PositionStatus, rhs: PositionStatus) -> Bool {
        return lhs.sortOrder == rhs.sortOrder
    }
    
    static func <(lhs: PositionStatus, rhs: PositionStatus) -> Bool {
        return lhs.sortOrder < rhs.sortOrder
    }
    
    static func >(lhs: PositionStatus, rhs: PositionStatus) -> Bool {
        return lhs.sortOrder > rhs.sortOrder
    }
}
