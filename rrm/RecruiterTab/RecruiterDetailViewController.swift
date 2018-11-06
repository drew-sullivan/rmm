//
//  RecruiterDetailViewController.swift
//  rrm
//
//  Created by Drew Sullivan on 10/26/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import UIKit

class RecruiterDetailViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var recruiter: Recruiter!
    
    @IBOutlet var positionTableView: UITableView!
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var employerTextField: UITextField!
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var emailAddressTextField: UITextField!
    
    @IBOutlet var editButton: UIBarButtonItem!
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func addNewPosition(_ sender: UIBarButtonItem) {
        recruiter.positions.insert(Position(random: true), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        positionTableView.insertRows(at: [indexPath], with: .fade)
    }
    
    @IBAction func toggleEditingMode(_ sender: UIBarButtonItem) {
        if positionTableView.isEditing {
            sender.title = "Edit"
            positionTableView.setEditing(false, animated: true)
        } else {
            sender.title = "Done"
            positionTableView.setEditing(true, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(recruiter.firstName) \(recruiter.lastName)"
        
        firstNameTextField.text = recruiter.firstName
        lastNameTextField.text = recruiter.lastName
        employerTextField.text = recruiter.employer
        phoneNumberTextField.text = recruiter.phoneNumber
        emailAddressTextField.text = recruiter.emailAddress.trimmingCharacters(in: .whitespaces).lowercased()
        
        positionTableView.dataSource = self
        positionTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        positionTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        recruiter.firstName = firstNameTextField.text!.titlecased()
        recruiter.lastName = lastNameTextField.text!.titlecased()
        recruiter.employer = employerTextField.text!.titlecased()
        recruiter.phoneNumber = phoneNumberTextField.text!
        recruiter.emailAddress = emailAddressTextField.text!
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "NewPosition"?:
            let newPositionViewController = segue.destination as! NewPositionViewController
            newPositionViewController.recruiter = recruiter
        case "RecruiterPositionDetail"?:
            let positionDetailViewController = segue.destination as! PositionDetailViewController
            if let indexPath = positionTableView.indexPathForSelectedRow {
                let position = recruiter.positions[indexPath.row]
                positionDetailViewController.position = position
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recruiter.positions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PositionCell", for: indexPath)
        
        let position = recruiter.positions[indexPath.row]
        
        cell.textLabel?.text = position.company.name
        cell.detailTextLabel?.text = "\(position.title)"
        cell.backgroundColor = position.status.backgroundColor()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let position = recruiter.positions[indexPath.row]
            
            let title = "Delete position \"\(position.title)\"?"
            let message = "Are you sure?"
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
                action -> Void in
                self.recruiter.deletePosition(position: position)
                self.positionTableView.reloadData()
            }
            
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true)
        }
    }
}
