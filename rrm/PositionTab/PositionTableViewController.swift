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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataStore.updatePositions()
        tableView.reloadData()
    }
    
    // MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PositionPositionCell", for: indexPath)
        
        let position = dataStore.positions[indexPath.row]
        
        cell.textLabel?.text = "\(position.title) @ \(position.company.name)"
        cell.detailTextLabel?.text = "Status: \(position.status.rawValue)"
        cell.backgroundColor = position.status.backgroundColor()
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStore.positions.count
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let position = dataStore.positions[indexPath.row]
            
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "PositionNewPosition"?:
            let newPositionForm = segue.destination as! NewPositionViewController
            newPositionForm.dataStore = dataStore
        case "PositionPositionDetails"?:
            let positionDetailViewController = segue.destination as! PositionDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                let position = dataStore.positions[indexPath.row]
                positionDetailViewController.position = position
            }
            
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
}