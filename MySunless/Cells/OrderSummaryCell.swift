//
//  OrderSummaryCell.swift
//  MySunless
//
//  Created by iMac on 15/04/22.
//

import UIKit

class OrderSummaryCell: UITableViewCell {
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var vw_item: UIView!
    @IBOutlet var txtItem: UITextField!
    @IBOutlet var vw_qty: UIView!
    @IBOutlet var txtQty: UITextField!
    @IBOutlet var vw_price: UIView!
    @IBOutlet var txtPrice: UITextField!
    @IBOutlet var vw_discount: UIView!
    @IBOutlet var txtDiscount: UITextField!
    @IBOutlet var vw_discountinmod: UIView!
    @IBOutlet var txtDiscountInMod: UITextField!
    @IBOutlet var vw_totalPrice: UIView!
    @IBOutlet var txtTotalPrice: UITextField!
    @IBOutlet var txtTax: UITextField!
    
    var model = CartList()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vw_item.layer.borderWidth = 0.5
        vw_item.layer.borderColor = UIColor.black.cgColor
        vw_qty.layer.borderWidth = 0.5
        vw_qty.layer.borderColor = UIColor.black.cgColor
        vw_price.layer.borderWidth = 0.5
        vw_price.layer.borderColor = UIColor.black.cgColor
        vw_discount.layer.borderWidth = 0.5
        vw_discount.layer.borderColor = UIColor.black.cgColor
        vw_discountinmod.layer.borderWidth = 0.5
        vw_discountinmod.layer.borderColor = UIColor.black.cgColor
        vw_totalPrice.layer.borderWidth = 0.5
        vw_totalPrice.layer.borderColor = UIColor.black.cgColor
        txtTax.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(index: Int) {
        txtItem.text = model.item
        txtQty.text = model.qty
        txtPrice.text = String(format: "%.02f", model.price)
        
        if model.showTax {
            txtTax.isHidden = false
            txtTax.text = String(format: "%.02f", model.tax)
        } else {
            txtTax.isHidden = true
            txtTax.text = ""
        }
        
        txtDiscount.text = String(format: "%.02f", model.discount)
        txtDiscountInMod.text = String(format: "%.02f", model.discountPercent)
        txtTotalPrice.text = String(format: "%.02f", model.totalPrice)
    }

}
