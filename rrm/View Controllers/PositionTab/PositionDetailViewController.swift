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
    @IBOutlet var modifyRecruiterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusPickerView.dataSource = self
        statusPickerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setToolbarHidden(true, animated: true)
        
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
        
        if let recruiterID = position.recruiterID {
            let positionRecruiter = dataStore?.getPositionRecruiter(id: recruiterID)
            if let recruiter = positionRecruiter {
                modifyRecruiterButton.setTitle("\(recruiter.printableName)", for: .normal)
                position.recruiterID = recruiter.id
            }
        } else {
             modifyRecruiterButton.setTitle("Add Recruiter", for: .normal)
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
        
        if let dataStore = dataStore {
            dataStore.updatePosition(position: position)
        }
        
        self.navigationController?.setToolbarHidden(false, animated: true)
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
        case "ModifyRecruiterSegue"?:
            let recruiterTableView = segue.destination as! RecruiterTableViewController
            recruiterTableView.dataStore = dataStore
            recruiterTableView.position = position
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
}
