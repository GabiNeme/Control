//
//  CreditCardTableViewCell.swift
//  Control
//
//  Created by Gabriela Neme on 27/07/20.
//  Copyright © 2020 Gabriela Neme. All rights reserved.
//

import UIKit

class CreditCardTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconColorImageView: UIImageView!
    
    @IBOutlet weak var invoiceValueLabel: UILabel!
    @IBOutlet weak var payedValueLabel: UILabel!
    
    static let identifier = "creditCardCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.contentView.autoresizingMask = .flexibleHeight
        
        //iconColorImageView.layer.cornerRadius = 25
    }

    static func nib() -> UINib {
        return UINib(nibName: "CreditCardTableViewCell", bundle: nil)
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
