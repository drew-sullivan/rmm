//
//  NewPositionViewController.swift
//  rrm
//
//  Created by Drew Sullivan on 11/3/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import UIKit

class NewPositionViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var recruiter: Recruiter!
    var pickerOptions = [String]()
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var companyTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var salaryTextField: UITextField!
    @IBOutlet var statusPickerView: UIPickerView!
    
    @IBAction func backgroundTapped(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitForm(_ sender: Any) {
        let company = Company(name: companyTextField.text!,
                              location: locationTextField.text!)
        let position = Position(status: PositionStatus(rawValue: pickerOptions[statusPickerView.selectedRow(inComponent: 0)])!,
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
        
        for status in PositionStatus.allCases {
            pickerOptions.append(status.rawValue)
        }
        
        statusPickerView.dataSource = self
        statusPickerView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - UIPickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions[row]
    }
}
