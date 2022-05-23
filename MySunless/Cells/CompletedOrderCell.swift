//
//  CompletedOrderCell.swift
//  MySunless
//
//  Created by iMac on 22/02/22.
//

import UIKit
import iOSDropDown

class CompletedOrderCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var imgCustomer: UIImageView!
    @IBOutlet var lblUser: UILabel!
    @IBOutlet var lblCustomer: UILabel!
    @IBOutlet var lblType: UILabel!
    @IBOutlet var lblTypeTitle: UILabel!
    @IBOutlet var lblInvoice: UILabel!
    @IBOutlet var dropDownStatus: DropDown!
    @IBOutlet var lblSubTotal: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var btnView: UIButton!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var lblInvoiceTitleTop: NSLayoutConstraint!    //35
    
    var delegate: CompletedOrderProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
        imgUser.layer.cornerRadius = imgUser.frame.size.height / 2
        imgCustomer.layer.cornerRadius = imgCustomer.frame.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @IBAction func btnUserImgClick(_ sender: UIButton) {
    }
    
    @IBAction func btnCustomerImgClick(_ sender: UIButton) {
    }
    
    @IBAction func btnEditClick(_ sender: UIButton) {
        delegate?.editOrder(index: sender.tag)
    }
    
}
