//
//  SubscriptionListCell.swift
//  MySunless
//
//  Created by iMac on 15/11/21.
//

import UIKit

class SubscriptionListCell: UITableViewCell {
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var expandImageView: UIImageView!
    @IBOutlet var lblInvoiceID: UILabel!
    @IBOutlet var lblPackageType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
