//
//  SubscriptionInfoCell.swift
//  MySunless
//
//  Created by Daydream Soft on 09/06/22.
//

import UIKit

class SubscriptionInfoCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var lblInvoiceID: UILabel!
    @IBOutlet weak var lblPackageName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDateOfBuy: UILabel!
    @IBOutlet weak var lblDateOfExpire: UILabel!
    @IBOutlet weak var lblPaymentType: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    var model = SubscriptionList(dict: [:])
    var delegate: SubscriptionInfoProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setCell(index: Int) {
        lblInvoiceID.text = model.InvoiceID
        lblPackageName.text = model.PackageType
        lblAmount.text = "$" + model.amount
        lblDateOfBuy.text = model.paytime
        lblDateOfExpire.text = model.packend
        lblPaymentType.text = model.PaymentType
        lblStatus.text = model.status
        
        btnView.tag = index
    }

    @IBAction func btnViewClick(_ sender: UIButton) {
        delegate?.viewInvoice()
    }
    
}
