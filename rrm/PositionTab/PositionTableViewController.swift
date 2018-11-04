//
//  PositionTableViewController.swift
//  rrm
//
//  Created by Drew Sullivan on 11/4/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import UIKit

class PositionTableViewController: UITableViewController {
    
    var dataStore: RecruiterStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "PositionCell")
        
        let position = dataStore.positions[indexPath.row]
        
        cell.textLabel?.text = "\(position.title) @ \(position.company.name)"
        cell.detailTextLabel?.text = "Status: \(position.status.rawValue)"
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStore.positions.count
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
}
