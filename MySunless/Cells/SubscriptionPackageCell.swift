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
    
    var parent = SubscriptionPackageVC()
    
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
        switch index {
        case 0:
            lblPackageName.text = "Monthly"
            lblPrice.text = "$19.99"
            lblValidityDays.text = "30"
            lblEmployeeLimit.text = "Unlimited"
            lblClientsLimit.text = "Unlimited"
            lblPackageDesc.text = "- Full access to all features. - Unlimited Employees sub-accounts. - Unlimited customer profiles. Valid for 30 days."
        default:
            print("Default")
        }
        btnPurchase.tag = index
        
        parent.packageName = lblPackageName.text ?? ""
        parent.amount = lblPrice.text ?? ""
        parent.amount.removeFirst()
        parent.packageDesc = lblPackageDesc.text ?? ""
        parent.packagetype = lblPackageName.text ?? ""
    }

//    @IBAction func btnPurchaseClick(_ sender: UIButton) {
//        
//    }
    
}
