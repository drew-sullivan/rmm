//
//  NewRecruiterFormViewController.swift
//  rrm
//
//  Created by Drew Sullivan on 10/28/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import UIKit

class NewRecruiterFormViewController: UIViewController, UITextFieldDelegate {
    
    var recruiterStore: RecruiterStore!
    
    @IBOutlet var firstNameLabel: UITextField!
    @IBOutlet var lastNameLabel: UITextField!
    @IBOutlet var employerLabel: UITextField!
    @IBOutlet var phoneNumberLabel: UITextField!
    @IBOutlet var emailAddressLabel: UITextField!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var submitButton: UIBarButtonItem!
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func cancelCreatingNewRecruiter(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitForm(_ sender: Any) {
        view.endEditing(true)
        let recruiter = Recruiter(firstName: firstNameLabel.text!.capitalized,
                                  lastName: lastNameLabel.text!.capitalized,
                                  employer: employerLabel.text!.capitalized,
                                  phoneNumber: phoneNumberLabel.text!,
                                  emailAddress: emailAddressLabel.text!)
        recruiterStore.addRecruiter(recruiter)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
