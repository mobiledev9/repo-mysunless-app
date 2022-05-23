//
//  CategoryReportCell.swift
//  MySunless
//
//  Created by Daydream Soft on 13/04/22.
//

import UIKit

class CategoryReportCell: UITableViewCell {
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var lblCategory: UILabel!
    @IBOutlet var lblBrand: UILabel!
    @IBOutlet var lblQuantity: UILabel!
    @IBOutlet var lblSalesPrice: UILabel!
    @IBOutlet var lblCostPrice: UILabel!
    @IBOutlet var lblProfit: UILabel!
    @IBOutlet var lblPayableTax: UILabel!
    
    var model = CategoryReport(dictionary: [:])
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(index: Int) {
        lblCategory.text = model?.category
        lblBrand.text = model?.brand
        lblQuantity.text = "\(model?.quantity ?? 0)"
        lblSalesPrice.text = "$" + String(format: "%.2f", Float(model?.productFianlPrice ?? 0.00))
        lblCostPrice.text =  "$" + String(format: "%.2f", Float(model?.cost_Price ?? 0))
        lblPayableTax.text =  "$" + String(format: "%.2f", Float(model?.productTax ?? 0))
        lblProfit.text = "$" + (model?.profit ?? "")
    }

}
