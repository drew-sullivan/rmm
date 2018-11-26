//
//  PositionTableViewController.swift
//  rrm
//
//  Created by Drew Sullivan on 11/4/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import UIKit

class PositionTableViewController: UITableViewController {
    
    var dataStore: DataStore!
    var positions: [Position]?
    
    @IBOutlet var editButton: UIBarButtonItem!
    
    @IBAction func toggleEditingMode(_ sender: UIBarButtonItem) {
        if isEditing {
            sender.title = "Edit"
            setEditing(false, animated: true)
        } else {
            sender.title = "Done"
            setEditing(true, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 150
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initializeData()
    }
    
    private func initializeData() {
        dataStore.initializeRecruiterData { (recruiterDataInitialized) in
            self.dataStore.fetchPositionData { (fetchedPositions) in
                self.positions = fetchedPositions
                self.positions?.sort { $0.status > $1.status }
                
                self.tableView.reloadData()
                
                if let count = self.positions?.count, count < 1 {
                    self.editButton.isEnabled = false
                }
            }
        }
    }
    
    // MARK: - UITableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PositionPositionCell", for: indexPath) as! PositionTableViewCell
        
        if let position = positions?[indexPath.row] {
            cell.statusView.backgroundColor = position.status.backgroundColor()
            cell.titleLabel.text = "\(position.title)"
            cell.companyNameLabel.text = "\(position.company.name)"
            cell.locationLabel.text = "\(position.company.location)"
            let utility = RRMUtilities()
            cell.appliedLabel.text = "\(utility.parseDateToString(date: position.dateApplied))"
            
            if let recruiterID = position.recruiterID {
                let positionRecruiter = dataStore.getPositionRecruiter(id: recruiterID)
                if let positionRecruiter = positionRecruiter {
                    cell.recruiterLabel.text = "Recruiter: \(positionRecruiter.printableName)"
                }
            }
            
            dataStore.fetchLogo(by: position.company.name) { (image) in
                cell.update(with: image)
            }
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = positions?.count {
            return count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let position = positions?[indexPath.row] {
                let title = "Delete \(position.title) @ \(position.company.name)?"
                let message = "Are you sure?"
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
                    action -> Void in
                    self.dataStore.deletePosition(position)
                    self.tableView.reloadData()
                }
                
                alertController.addAction(deleteAction)
                
                present(alertController, animated: true)
            }
        }
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "PositionNewPosition"?:
            let newPositionForm = segue.destination as! NewPositionViewController
            newPositionForm.dataStore = dataStore
        case "PositionPositionDetails"?:
            let positionDetailViewController = segue.destination as! PositionDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                let position = positions?[indexPath.row]
                positionDetailViewController.dataStore = dataStore
                positionDetailViewController.position = position
            }
            
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
}
