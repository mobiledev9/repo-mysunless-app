//
//  ProductsListCell.swift
//  MySunless
//
//  Created by Daydream Soft on 28/03/22.
//

import UIKit
import Kingfisher
import SCLAlertView

class ProductsListCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var stockView: UIView!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblProductPrice: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblStock: UILabel!
    @IBOutlet var lblBarCode: UILabel!
    @IBOutlet var lblCategory: UILabel!
    @IBOutlet var lblBrand: UILabel!
    @IBOutlet var lblProductDescription: UILabel!
    @IBOutlet var lblProductCost: UILabel!
    @IBOutlet var switchStatus: UISwitch!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var btnView: UIButton!
    @IBOutlet var lblTaxTitle: UILabel!
    @IBOutlet var vw_taxValue: UIView!
    @IBOutlet var lblTax: UILabel!
    
    var model = ShowProducts(dictionary: [:])
    var delegate: ProductListProtocol?
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
        stockView.layer.cornerRadius = stockView.frame.height/3
        vw_taxValue.layer.cornerRadius = vw_taxValue.frame.height/3
        imgView.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func showSCLAlert(alertMainTitle: String, alertTitle: String) {
        let alert = SCLAlertView()
        alert.addButton("Yes, delete it!", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(deleteClick(_:)))
        alert.addButton("Cancel", backgroundColor: UIColor.init("#E95268"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertMainTitle, subTitle: alertTitle)
    }
    
    func setCell(index: Int, salesTax: String) {
        let imgUrl = URL(string: model?.productImage ?? "")
        imgView.kf.setImage(with: imgUrl)
        lblProductPrice.text = "$\(model?.sellingPrice ?? 0)"
        lblTitle.text = model?.productTitle
        lblStock.text = "\(model?.noofPorduct ?? 0)"
        if model?.sales_tax == "1" {
            lblTaxTitle.isHidden = false
            vw_taxValue.isHidden = false
            lblTax.text = salesTax
        } else if model?.sales_tax == "0" {
            lblTaxTitle.isHidden = true
            vw_taxValue.isHidden = true
            lblTax.text = ""
        }
        if model?.isactive == 1 {
            switchStatus.setOn(true, animated: false)
        } else if model?.isactive == 0 {
            switchStatus.setOn(false, animated: false)
        }
        lblBarCode.text = model?.barcode
        lblCategory.text = model?.category
        lblBrand.text = model?.brand
        lblProductDescription.text = model?.productDescription
        lblProductCost.text = "$\(model?.companyCost ?? 0)"
        switchStatus.tag = index
        btnEdit.tag = index
        btnView.tag = index
        btnDelete.tag = index
    }
    
    @IBAction func switchStatusChanged(_ sender: UISwitch) {
        delegate?.UpdateProdStatusAPI(productId: model?.id ?? 0)
    }
    
    @IBAction func btnEditClick(_ sender: UIButton) {
        delegate?.editProduct(barcode: model?.barcode ?? "")
    }
    
    @IBAction func btnDeleteClick(_ sender: UIButton) {
        showSCLAlert(alertMainTitle: "Temporary Delete?", alertTitle: "Once deleted, it will move to Archive list!")
    }
    
    @objc func deleteClick(_ sender: UIButton) {
        delegate?.callDeleteProductAPI(productId: model?.id ?? 0)
    }

    @IBAction func btnViewClick(_ sender: UIButton) {
        delegate?.viewProduct(productId: model?.id ?? 0)
    }
    
   


}
