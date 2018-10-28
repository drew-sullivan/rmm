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
    
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var editButton: UIBarButtonItem!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecruiterTableViewCell", for: indexPath)
        let recruiter = recruiterStore.sections[indexPath.section][indexPath.row]
        cell.textLabel?.text = "\(recruiter.lastName), \(recruiter.firstName)"
        let utility = RRMUtilities()
        cell.detailTextLabel?.text = "Date last contacted: \(utility.parseDateToString(date: (recruiter.positions.last?.dateContacted)!))"
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
}
