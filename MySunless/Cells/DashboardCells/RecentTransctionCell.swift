//
//  RecentTransctionCell.swift
//  MySunless
//
//  Created by Daydream Soft on 20/04/22.
//

import UIKit

class RecentTransctionCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblStrUserName: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblStrType: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblInvoice: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblStrSubTotal: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    var model = RecentTransaction(dictionary: [:])

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(index:  Int) {
        if index == 0 {
            lblStrUserName.isHidden = false
            lblStrType.isHidden = false
            lblStrSubTotal.isHidden = false
        } else {
            lblStrUserName.isHidden = true
            lblStrType.isHidden = true
            lblStrSubTotal.isHidden = true
        }
        lblUserName.text = (model?.firstname ?? "") + " " + (model?.lastname ?? "")
        //lblCustomerName.text = (model?.firstName ?? "") + " " + (model?.lastName ?? "")
        if model?.paymentType == nil || model?.paymentType == "" {
            lblType.text = "--"
        } else {
            lblType.text = model?.paymentType
        }
       
        //lblInvoice.text = model?.invoiceNumber
        //lblStatus.text = model?.orderPayment_status
        lblSubTotal.text = model?.totalOrderAmount
//        var date = model?.orderdate
//        date?.removeLast(9)
//        lblDate.text = date
    }

}
