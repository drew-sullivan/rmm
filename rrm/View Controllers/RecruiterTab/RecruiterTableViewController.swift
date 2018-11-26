//
//  RecruiterTableViewController.swift
//  rrm
//
//  Created by Drew Sullivan on 10/26/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import UIKit

class RecruiterTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var dataStore: DataStore!
    var position: Position!
    let searchController = UISearchController(searchResultsController: nil)
    
    var selectedRecruiterIndexPath: IndexPath?
    
    // MARK: - Outlets
    
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var editButton: UIBarButtonItem!
    
    // MARK: - Actions
    
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
        
        dataStore.initializeRecruiterData { (isDone) in
            print("Recruiter Table View: data initialized")
            self.tableView.reloadData()
            
        }
        
        // Set up the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Recruiters"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataStore.updateDataForUI()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let indexPath = selectedRecruiterIndexPath {
            let recruiterID = dataStore.sections[indexPath.section][indexPath.row].id;
            position.recruiterID = recruiterID
            dataStore.updatePosition(position: position)
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showRecruiter"?:
            if let indexPath = tableView.indexPathForSelectedRow {
                let recruiter = dataStore.sections[indexPath.section][indexPath.row]
                let recruiterDetailViewController = segue.destination as! RecruiterDetailViewController
                recruiterDetailViewController.recruiter = recruiter
                recruiterDetailViewController.dataStore = dataStore
            }
        case "newRecruiterForm"?:
            let newRecruiterFormViewController = segue.destination as! NewRecruiterFormViewController
            newRecruiterFormViewController.dataStore = dataStore
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    // MARK: - Helpers
    
    private func isFiltering() -> Bool {
        let filteringStatus = searchController.isActive && !searchBarIsEmpty()
        return filteringStatus
    }
    
    // MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecruiterTableViewCell", for: indexPath)
        let recruiter = dataStore.sections[indexPath.section][indexPath.row];
        if let positionRecruiterID = position.recruiterID {
            if recruiter.id == positionRecruiterID {
                cell.accessoryType = .checkmark
            }
        }
        cell.textLabel?.text = "\(recruiter.lastName), \(recruiter.firstName)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitle = dataStore.sortedLastNameFirstLetters[section]
        return sectionTitle
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let sectionTitles = dataStore.sortedLastNameFirstLetters
        return sectionTitles
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let numSections = dataStore.sections.count
        return numSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numRows = dataStore.sections[section].count
        return numRows
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recruiter = dataStore.sections[indexPath.section][indexPath.row]
            
            let title = "Delete \(recruiter.firstName) \(recruiter.lastName)?"
            let message = "Are you sure?"
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
                action -> Void in
                self.dataStore.deleteRecruiter(recruiter)
                self.tableView.reloadData()
            }
            
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let sr = selectedRecruiterIndexPath {
            tableView.cellForRow(at: sr)?.accessoryType = .none
        }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        selectedRecruiterIndexPath = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        dataStore.filteredRecruiters = dataStore.recruiters.filter { recruiter -> Bool in
            return recruiter.lastName.lowercased().contains(searchText.lowercased()) ||
                   recruiter.firstName.lowercased().contains(searchText.lowercased())
        }
        dataStore.updateDataForUI()
        tableView.reloadData()
    }
}
