//
//  RecruiterDetailViewController.swift
//  rrm
//
//  Created by Drew Sullivan on 10/26/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import UIKit

class RecruiterDetailViewController: UIViewController {
    
    var recruiter: Recruiter!
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var employerTextField: UITextField!
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var emailAddressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(recruiter.firstName) \(recruiter.lastName)"
        
        firstNameTextField.text = recruiter.firstName
        lastNameTextField.text = recruiter.lastName
        employerTextField.text = recruiter.employer
        phoneNumberTextField.text = recruiter.phoneNumber
        emailAddressTextField.text = recruiter.emailAddress
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
}
