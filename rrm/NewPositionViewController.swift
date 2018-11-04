//
//  NewPositionViewController.swift
//  rrm
//
//  Created by Drew Sullivan on 11/3/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import UIKit

class NewPositionViewController: UIViewController, UITextFieldDelegate {
    
    var recruiter: Recruiter!
    
    @IBOutlet var isActiveSwitch: UISwitch!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var companyTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var salaryTextField: UITextField!
    
    @IBAction func backgroundTapped(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitForm(_ sender: Any) {
        let company = Company(name: companyTextField.text!,
                              location: locationTextField.text!)
        let position = Position(isActive: isActiveSwitch.isOn,
                                dateContacted: Date(),
                                company: company,
                                title: titleTextField.text!,
                                salary: salaryTextField.text!)
        recruiter.addPosition(position: position)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
