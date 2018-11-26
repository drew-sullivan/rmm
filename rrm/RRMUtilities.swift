//
//  RRMUtilities.swift
//  rrm
//
//  Created by Drew Sullivan on 10/26/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import UIKit

class RRMUtilities: NSObject {
    
    func parseDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
    
    func formatStringToCurrency(_ value: String?) -> String {
        guard value != nil else { return "$0.00" }
        let cleanedSalaryString = getCleanSalaryString(value!)
        let doubleValue = Double(cleanedSalaryString) ?? 0.0
        let formatter = NumberFormatter()
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = (value!.contains(".00")) ? 0 : 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .currencyAccounting
        return formatter.string(from: NSNumber(value: doubleValue)) ?? "$\(doubleValue)"
    }
    
    private func getCleanSalaryString(_ salaryString: String) -> String {
        var salaryStringCopy = salaryString
        if salaryStringCopy.hasPrefix("$") {
            salaryStringCopy.remove(at: salaryString.startIndex)
        }
        if salaryStringCopy.contains(",") {
            if let index = salaryStringCopy.firstIndex(of: ",") {
                salaryStringCopy.remove(at: index)
            }
        }
        return salaryStringCopy
    }
}
