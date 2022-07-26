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
    var model = SelectPackage()
    
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
//        switch index {
//        case 0:
//            lblPackageName.text = "Monthly"
//            lblPrice.text = "$19.99"
//            lblValidityDays.text = "30"
//            lblEmployeeLimit.text = "Unlimited"
//            lblClientsLimit.text = "Unlimited"
//            lblPackageDesc.text = "- Full access to all features. - Unlimited Employees sub-accounts. - Unlimited customer profiles. Valid for 30 days."
//        default:
//            print("Default")
//        }
        
        lblPackageName.text = model.name
        lblPrice.text = model.price
        lblValidityDays.text = model.validity
        
        switch model.id {
        case "24":
            lblEmployeeLimit.text = "0"
            lblClientsLimit.text = "50"
            lblPackageDesc.text = "Great for new technicians who started to grow their client base - 50 client profiles - Access to all Mysunless features"
        case "25":
            lblEmployeeLimit.text = "0"
            lblClientsLimit.text = "125"
            lblPackageDesc.text = "Made for businesses with a strong list of clients. - 125 client limit - access to all Mysunless features"
        case "19":
            lblEmployeeLimit.text = "Unlimited"
            lblClientsLimit.text = "Unlimited"
            lblPackageDesc.text = "- Full access to all features. - Unlimited Employees sub-accounts. - Unlimited customer profiles. Valid for 30 days."
        case "21":
            lblEmployeeLimit.text = "Unlimited"
            lblClientsLimit.text = "Unlimited"
            lblPackageDesc.text = "- Full access to all features. - Unlimited Employees sub-accounts. - Unlimited customer profiles. Valid 365 days after purchase."
        default:
            print("Default")
        }
        
//        if ("\(parent.dictActivePackage.package_id)" == model.id) {
//            btnPurchase.setTitle("Active", for: .normal)
//            btnPurchase.backgroundColor = UIColor.init("#149A14")
//            btnPurchase.isUserInteractionEnabled = false
//        } else {
//            btnPurchase.setTitle("Purchase", for: .normal)
//            btnPurchase.backgroundColor = UIColor.init("#15B0DA")
//            btnPurchase.isUserInteractionEnabled = true
//        }
        
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
