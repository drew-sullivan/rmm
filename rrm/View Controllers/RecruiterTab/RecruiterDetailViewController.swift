//
//  RecruiterDetailViewController.swift
//  rrm
//
//  Created by Drew Sullivan on 10/26/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import UIKit

class RecruiterDetailViewController: UIViewController, UITextFieldDelegate {
    
    var dataStore: DataStore!
    var recruiter: Recruiter!
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var employerTextField: UITextField!
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var emailAddressTextField: UITextField!
        
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(recruiter.firstName) \(recruiter.lastName)"
        
        firstNameTextField.text = recruiter.firstName
        lastNameTextField.text = recruiter.lastName
        employerTextField.text = recruiter.employer
        phoneNumberTextField.text = recruiter.phoneNumber
        emailAddressTextField.text = recruiter.emailAddress.trimmingCharacters(in: .whitespaces).lowercased()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        recruiter.firstName = firstNameTextField.text!.titlecased()
        recruiter.lastName = lastNameTextField.text!.titlecased()
        recruiter.employer = employerTextField.text!.titlecased()
        recruiter.phoneNumber = phoneNumberTextField.text!
        recruiter.emailAddress = emailAddressTextField.text!
        dataStore.updateRecruiter(recruiter)
        
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
