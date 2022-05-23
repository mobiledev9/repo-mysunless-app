//
//  SubscriptionDataCell.swift
//  MySunless
//
//  Created by iMac on 15/11/21.
//

import UIKit

class SubscriptionDataCell: UITableViewCell {

    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var lblPurchaseDate: UILabel!
    @IBOutlet var lblExpirationDate: UILabel!
    @IBOutlet var lblPaymentType: UILabel!
    @IBOutlet var lblStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
