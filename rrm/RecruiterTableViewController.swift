//
//  RecruiterTableViewController.swift
//  rrm
//
//  Created by Drew Sullivan on 10/26/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import UIKit

class RecruiterTableViewController : UITableViewController {
    
    let recruiterStore = RecruiterStore()
    var recruiters = [Recruiter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("recruiterTableViewController")
        tableView.dataSource = recruiterStore
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showRecruiter"?:
            if let row = tableView.indexPathForSelectedRow?.row {
                let recruiter = recruiters[row]
                let recruiterDetailViewController = segue.destination as! RecruiterDetailViewController
                recruiterDetailViewController.recruiter = recruiter
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
}
