//
//  RecruiterStore.swift
//  rrm
//
//  Created by Drew Sullivan on 10/26/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import UIKit

class RecruiterStore : NSObject, UITableViewDataSource {
    
    var recruiters = [Recruiter]()
    
    override init() {
        for _ in 0..<5 {
            recruiters.append(Recruiter(random: true))
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recruiters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "RecruiterTableViewCell")
        let recruiter = recruiters[indexPath.row]
        cell.textLabel?.text = "\(recruiter.lastName), \(recruiter.firstName)"
        let utility = RRMUtilities()
        cell.detailTextLabel?.text = "Date last contacted: \(utility.parseDateToString(date: (recruiter.positions.last?.dateContacted)!))"
        return cell
    }
}
