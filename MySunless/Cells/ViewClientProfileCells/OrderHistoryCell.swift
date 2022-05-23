//
//  OrderHistoryCell.swift
//  MySunless
//
//  Created by Daydream Soft on 23/03/22.
//

import UIKit
import Kingfisher

class OrderHistoryCell: UITableViewCell {
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblOrderDate: UILabel!
    @IBOutlet var lblInvoice: UILabel!
    @IBOutlet var lblPaymentType: UILabel!
    @IBOutlet var lblSubTotal: UILabel!
    @IBOutlet var lblBeforeNoteTime: UILabel!
    @IBOutlet var btnUserImg: UIButton!
    @IBOutlet var btnView: UIButton!
    @IBOutlet var lblUsername: UILabel!
    
    var model = OrderHistory(dictionary: [:])
    var delegate: OrderHistoryProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
        imgView.layer.cornerRadius = imgView.frame.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(index: Int) {
        let imgUrl = URL(string: model?.userimg ?? "")
        imgView.kf.setImage(with: imgUrl)
        lblUsername.text = model?.username
        lblOrderDate.text = AppData.sharedInstance.convertToUTC(dateToConvert: model?.orderdate ?? "")
        lblInvoice.text = model?.invoiceNumber
        lblPaymentType.text = model?.paymentType
        lblSubTotal.text = "$" + (model?.paymentAmount ?? "")
        lblBeforeNoteTime.text = model?.timediff
        btnView.tag = index
        btnUserImg.tag = index
    }

    @IBAction func btnUserImgClick(_ sender: UIButton) {
        delegate?.showUserDetail()
    }
    
    @IBAction func btnViewClick(_ sender: UIButton) {
    }
}
