//
//  ProductDetailCell.swift
//  MySunless
//
//  Created by Daydream Soft on 14/04/22.
//

import UIKit

class ProductDetailCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var lblUserInfo: UILabel!
    @IBOutlet var imgUserInfo: UIImageView!
    @IBOutlet var btnUserInfo: UIButton!
    @IBOutlet var lblCustomer: UILabel!
    @IBOutlet var btnCustomer: UIButton!
    @IBOutlet var imgCustomer: UIImageView!
    @IBOutlet var lblInvoiceID: UILabel!
    @IBOutlet var btnInvoice: UIButton!
    @IBOutlet var lblQty: UILabel!
    @IBOutlet var lblSellPrice: UILabel!
    @IBOutlet var lblOrderDate: UILabel!
    @IBOutlet var lblCostPrice: UILabel!
    @IBOutlet var lblProfit: UILabel!
    
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
        
        lblUserInfo.text = model?.username?.capitalized
        lblCustomer.text = model?.custname?.capitalized
        lblInvoiceID.text = model?.invoiceNumber
        lblQty.text = model?.prodcutQuality
        var date = model?.orderTime
        date?.removeLast(11)
        lblOrderDate.text = date
        lblSellPrice.text = "$" + (model?.productFianlPrice ?? "")
        lblCostPrice.text = "$" + (model?.productCostPrice ?? "") + " (Total)"
        lblProfit.text = "$" + (model?.profit ?? "")
      //  lblTax.text = "$" + (model?.productTaxPrice ?? "")
        
      //  btnProduct.tag = index
        btnCustomer.tag = index
        btnUserInfo.tag = index
        btnInvoice.tag = index
    }

    @IBAction func btnUserInfoClick(_ sender: UIButton) {
    }
    
    @IBAction func btnCustomerClick(_ sender: UIButton) {
    }
    
    @IBAction func btnInvoiceClick(_ sender: UIButton) {
    }
    
}
