//
//  PositionDetailViewController.swift
//  rrm
//
//  Created by Drew Sullivan on 11/3/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import UIKit

class PositionDetailViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var dataStore: DataStore?
    var position: Position!
    var pickerOptions = [String]()
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var companyTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var salaryTextField: UITextField!
    @IBOutlet var dateCreatedLabel: UILabel!
    @IBOutlet var statusPickerView: UIPickerView!
    @IBOutlet var recruiterLabel: UILabel!
    @IBOutlet var newRecruiterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusPickerView.dataSource = self
        statusPickerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let utility = RRMUtilities()
        for status in PositionStatus.allCases {
            pickerOptions.append(status.rawValue)
        }
        
        if let row = pickerOptions.index(of: position!.status.rawValue) {
            statusPickerView.selectRow(row, inComponent: 0, animated: true)
        }
        titleTextField.text = position.title
        companyTextField.text = position.company.name
        locationTextField.text = position.company.location
        salaryTextField.text = utility.formatStringToCurrency(position.salary)
        dateCreatedLabel.text = utility.parseDateToString(date: position.dateApplied)
        
        if let recruiter = position.recruiter {
            recruiterLabel.text = "\(recruiter.firstName) \(recruiter.lastName)"
            newRecruiterButton.isEnabled = false
        } else {
            recruiterLabel.text = ""
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        let utility = RRMUtilities()
        
        position.status = PositionStatus(rawValue: pickerOptions[statusPickerView.selectedRow(inComponent: 0)])!
        position.title = titleTextField.text!
        position.company.name = companyTextField.text!
        position.company.location = locationTextField.text!
        position.salary = utility.formatStringToCurrency(salaryTextField.text!)
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
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "PositionNewRecruiter"?:
            let newRecruiterFormViewController = segue.destination as! NewRecruiterFormViewController
            newRecruiterFormViewController.position = position
            newRecruiterFormViewController.dataStore = dataStore
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
}
