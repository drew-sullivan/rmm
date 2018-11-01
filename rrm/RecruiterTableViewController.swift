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
    
    // MARK: - Outlets
    
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var editButton: UIBarButtonItem!
    
    // MARK: - Actions
    
    @IBAction func addNewRecruiter(_ sender: UIBarButtonItem) {
        recruiterStore.generateRecruiter()
        tableView.reloadData()
    }
    
    @IBAction func toggleEditingMode(_ sender: UIBarButtonItem) {
        if isEditing {
            sender.title = "Edit"
            setEditing(false, animated: true)
        } else {
            sender.title = "Done"
            setEditing(true, animated: true)
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recruiterStore.update()
        tableView.reloadData()
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showRecruiter"?:
            if let indexPath = tableView.indexPathForSelectedRow {
                let recruiter = recruiterStore.sections[indexPath.section][indexPath.row]
                let recruiterDetailViewController = segue.destination as! RecruiterDetailViewController
                recruiterDetailViewController.recruiter = recruiter
            }
        case "newRecruiterForm"?:
            let newRecruiterFormViewController = segue.destination as! NewRecruiterFormViewController
            newRecruiterFormViewController.recruiterStore = recruiterStore
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    // MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecruiterTableViewCell", for: indexPath)
        let recruiter = recruiterStore.sections[indexPath.section][indexPath.row]
        cell.textLabel?.text = "\(recruiter.lastName), \(recruiter.firstName)"
        let utility = RRMUtilities()
        if let dateLastContacted = recruiter.positions.last?.dateContacted {
            cell.detailTextLabel?.text = "Date last contacted: \(utility.parseDateToString(date: dateLastContacted))"
        } else {
            cell.detailTextLabel?.text = "Date last contacted: \(utility.parseDateToString(date: Date()))"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitle = recruiterStore.sortedLastNameFirstLetters[section]
        return sectionTitle
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let sectionTitles = recruiterStore.sortedLastNameFirstLetters
        return sectionTitles
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let numSections = recruiterStore.sections.count
        return numSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numRows = recruiterStore.sections[section].count
        return numRows
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recruiter = recruiterStore.sections[indexPath.section][indexPath.row]
            
            let title = "Delete \(recruiter.firstName) \(recruiter.lastName)?"
            let message = "Are you sure?"
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
                action -> Void in
                self.recruiterStore.deleteRecruiter(recruiter)
                self.tableView.reloadData()
            }
            
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true)
        }
    }
}
