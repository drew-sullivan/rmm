//
//  PositionTableViewCell.swift
//  rrm
//
//  Created by Drew Sullivan on 11/10/18.
//  Copyright © 2018 Drew Sullivan, DMA. All rights reserved.
//

import UIKit

class PositionTableViewCell: UITableViewCell {
    
    @IBOutlet var statusView: UIView!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var companyNameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var appliedLabel: UILabel!
    @IBOutlet var recruiterLabel: UILabel!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    func update(with image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            logoImageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            logoImageView.image = nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        update(with: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        update(with: nil)
    }
    
}
