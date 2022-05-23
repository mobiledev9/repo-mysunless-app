//
//  ProductReportCell.swift
//  MySunless
//
//  Created by Daydream Soft on 13/04/22.
//

import UIKit
import Kingfisher

class ProductReportCell: UITableViewCell {
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var lblUserInfo: UILabel!
    @IBOutlet var lblCategory: UILabel!
    @IBOutlet var lblCustomer: UILabel!
    @IBOutlet var lblInvoiceID: UILabel!
    @IBOutlet var btnInvoiceID: UIButton!
    @IBOutlet var lblProduct: UILabel!
    @IBOutlet var btnProduct: UIButton!
    @IBOutlet var lblQuantity: UILabel!
    @IBOutlet var lblOrderDate: UILabel!
    @IBOutlet var lblSellPrice: UILabel!
    @IBOutlet var lblCostPrice: UILabel!
    @IBOutlet var lblProfitLose: UILabel!
    @IBOutlet var lblTax: UILabel!
    @IBOutlet var btnUserInfo: UIButton!
    @IBOutlet var btnCustomer: UIButton!
    @IBOutlet var imgCustomer: UIImageView!
    @IBOutlet var imgUserInfo: UIImageView!
    
    var model = ProductReport(dictionary: [:])

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
        let imgUserUrl = URL(string: model?.userimg ?? "")
        imgUserInfo.kf.setImage(with: imgUserUrl)
        let imgClientUrl = URL(string: model?.profileImg ?? "")
        imgCustomer.kf.setImage(with: imgClientUrl)
        
        lblUserInfo.text = model?.username
        lblCategory.text = model?.category
        lblCustomer.text = model?.custname
        lblInvoiceID.text = model?.invoiceNumber
        lblProduct.text = model?.productTitle
        lblQuantity.text = model?.prodcutQuality
        var date = model?.orderTime
        date?.removeLast(11)
        lblOrderDate.text = date
        lblSellPrice.text = "$" + (model?.productFianlPrice ?? "")
        lblCostPrice.text = "$" + (model?.productCostPrice ?? "") + " (Total)"
        lblProfitLose.text = "$" + (model?.profit ?? "")
        lblTax.text = "$" + (model?.productTaxPrice ?? "")
        
        btnProduct.tag = index
        btnCustomer.tag = index
        btnUserInfo.tag = index
        btnInvoiceID.tag = index
    }

    @IBAction func btnUserImgClick(_ sender: UIButton) {
    }
    
    @IBAction func btnClientImgClick(_ sender: UIButton) {
    }
    
    @IBAction func btnInvoiceClick(_ sender: UIButton) {
    }
    
    @IBAction func btnProductClick(_ sender: UIButton) {
    }
    
}
