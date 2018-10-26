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
}
