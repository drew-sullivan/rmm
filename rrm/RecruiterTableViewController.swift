//
//  RecruiterTableViewController.swift
//  rrm
//
//  Created by Drew Sullivan on 10/26/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import UIKit

class RecruiterTableViewController: UITableViewController {
    
    var recruiterStore: RecruiterStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showRecruiter"?:
            if let row = tableView.indexPathForSelectedRow?.row {
                let recruiter = recruiterStore.recruiters[row]
                let recruiterDetailViewController = segue.destination as! RecruiterDetailViewController
                recruiterDetailViewController.recruiter = recruiter
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recruiterStore.recruiters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecruiterTableViewCell", for: indexPath)
        let recruiter = recruiterStore.recruiters[indexPath.row]
        cell.textLabel?.text = "\(recruiter.lastName), \(recruiter.firstName)"
        let utility = RRMUtilities()
        cell.detailTextLabel?.text = "Date last contacted: \(utility.parseDateToString(date: (recruiter.positions.last?.dateContacted)!))"
        return cell
    }
    
}
