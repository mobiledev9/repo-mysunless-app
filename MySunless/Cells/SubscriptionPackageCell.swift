//
//  SubscriptionPackageCell.swift
//  MySunless
//
//  Created by iMac on 27/05/22.
//

import UIKit

class SubscriptionPackageCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var btnPurchase: UIButton!
    @IBOutlet var lblPackageName: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblValidityDays: UILabel!
    @IBOutlet var lblEmployeeLimit: UILabel!
    @IBOutlet var lblClientsLimit: UILabel!
    @IBOutlet var lblPackageDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
        btnPurchase.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(index: Int) {
        lblPackageName.text = "Monthly"
        lblPrice.text = "$19.99"
        lblValidityDays.text = "30"
        lblEmployeeLimit.text = "Unlimited"
        lblClientsLimit.text = "Unlimited"
        lblPackageDesc.text = "- Full access to all features. - Unlimited Employees sub-accounts. - Unlimited customer profiles. Valid for 30 days."
        btnPurchase.tag = index
    }

//    @IBAction func btnPurchaseClick(_ sender: UIButton) {
//        
//    }
    
}
