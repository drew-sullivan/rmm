//
//  PositionDetailViewController.swift
//  rrm
//
//  Created by Drew Sullivan on 11/3/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import UIKit

class PositionDetailViewController: UIViewController {
    
    var position: Position!
    
    @IBOutlet var isActiveSwitch: UISwitch!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var companyTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var salaryTextField: UITextField!
    @IBOutlet var dateCreatedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(position.title), \(position.company.name)"
        let utility = RRMUtilities()
        
        isActiveSwitch.isOn = position.isActive
        titleTextField.text = position.title
        companyTextField.text = position.company.name
        locationTextField.text = position.company.location
        salaryTextField.text = utility.formatStringToCurrency(position.salary)
        dateCreatedLabel.text = utility.parseDateToString(date: position.dateContacted)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let utility = RRMUtilities()
        
        position.isActive = isActiveSwitch.isOn
        position.title = titleTextField.text!
        position.company.name = companyTextField.text!
        position.company.location = locationTextField.text!
        position.salary = utility.formatStringToCurrency(salaryTextField.text!)
    }
}
