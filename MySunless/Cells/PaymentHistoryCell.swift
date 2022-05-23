//
//  Payment HistoryCell.swift
//  MySunless
//
//  Created by Daydream Soft on 14/04/22.
//

import UIKit
import Kingfisher

struct PaymentDetail {
    let ChequeNumber: String?
    let Bank: String?
    let submitdate: String?
    let Amount: String?
    
    init(dict: [String:Any]) {
        self.ChequeNumber = dict["ChequeNumber"] as? String
        self.Bank = dict["Bank"] as? String
        self.submitdate = dict["submitdate"] as? String
        self.Amount = dict["Amount"] as? String
    }
}

class PaymentHistoryCell: UITableViewCell {
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var lblUserInfo: UILabel!
    @IBOutlet var imgUserInfo: UIImageView!
    @IBOutlet var btnUserInfo: UIButton!
    @IBOutlet var lblCustomer: UILabel!
    @IBOutlet var btnCustomer: UIButton!
    @IBOutlet var imgCustomer: UIImageView!
    @IBOutlet var lblInvoice: UILabel!
    @IBOutlet var btnInvoice: UIButton!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var lblPayment: UILabel!
    @IBOutlet var lblOrderDate: UILabel!
    @IBOutlet var lblAmount: UILabel!
    
    var model = PaymentList(dictionary: [:])
    var paymentType = String()
    var chequeNo = String()
    var bank = String()
    var submitDate = String()
    var amount = String()
    var delegate: PaymentHistoryCellProtocol?
   
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
        imgCustomer.layer.cornerRadius = imgCustomer.frame.size.height / 2
        imgUserInfo.layer.cornerRadius = imgUserInfo.frame.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(index: Int) {
        let userImgUrl = URL(string: model?.userimg ?? "")
        imgUserInfo.kf.setImage(with: userImgUrl)
        let clientImgUrl = URL(string: model?.profileImg ?? "")
        imgCustomer.kf.setImage(with: clientImgUrl)
        lblUserInfo.text = model?.username?.capitalized
        lblCustomer.text = model?.client_Fullname
        lblInvoice.text = model?.invoiceNumber
        lblStatus.text = model?.payment_status
        
        let paymentDetail = PaymentDetail(dict: model?.paymentDetail ?? [:])
        chequeNo = "Cheque No.: " + (paymentDetail.ChequeNumber ?? "")
        bank = "Bank: " + (paymentDetail.Bank ?? "")
        submitDate = "Submit Date: " + (paymentDetail.submitdate ?? "")
        amount = "Amount: $" + (paymentDetail.Amount ?? "")
        paymentType = model?.paymentType ?? ""
        if paymentType == "Cash" {
            lblPayment.text = paymentType
        } else if paymentType == "Cheque" {
            lblPayment.text = paymentType + "\n" + chequeNo + "\n" + bank + "\n" + submitDate + "\n" + amount
        }
        
        lblOrderDate.text = model?.orderdate
        lblAmount.text = "$" + (model?.amount ?? "")
        btnUserInfo.tag = index
        btnCustomer.tag = index
        btnInvoice.tag = index
    }
 
    @IBAction func btnUserImgClick(_ sender: UIButton) {
        delegate?.showUserDetail()
    }
    
    @IBAction func btnClientImgClick(_ sender: UIButton) {
        delegate?.showClientDetail(clientId: model?.clientid ?? 0)
    }
    
    @IBAction func btnInvoiceClick(_ sender: UIButton) {
        delegate?.viewInvoice(orderId: Int(model?.orderId ?? "") ?? 0)
    }
}
