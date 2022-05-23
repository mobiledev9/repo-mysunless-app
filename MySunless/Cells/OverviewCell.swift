//
//  OverviewCell.swift
//  MySunless
//
//  Created by iMac on 12/05/22.
//

import UIKit

class OverviewCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblActualAmt: UILabel!
    @IBOutlet var lblDiscount: UILabel!
    @IBOutlet var lblTotalSales: UILabel!
    
    var model = Overview(dict: [:])
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setHeaderUI() {
        cellView.backgroundColor = UIColor.init("#323A46")
        lblName.font = UIFont(name: "Roboto-Medium", size: 17)
        lblName.textColor = UIColor.white
        lblActualAmt.font = UIFont(name: "Roboto-Medium", size: 17)
        lblActualAmt.textColor = UIColor.white
        lblDiscount.font = UIFont(name: "Roboto-Medium", size: 17)
        lblDiscount.textColor = UIColor.white
        lblTotalSales.font = UIFont(name: "Roboto-Medium", size: 17)
        lblTotalSales.textColor = UIColor.white
    }
    
    func setCellsUI() {
        cellView.backgroundColor = UIColor.init("#F5F5F5")
        lblName.font = UIFont(name: "Roboto-Regular", size: 17)
        lblName.textColor = UIColor.init("#6D778E")
        lblActualAmt.font = UIFont(name: "Roboto-Regular", size: 17)
        lblActualAmt.textColor = UIColor.init("#6D778E")
        lblDiscount.font = UIFont(name: "Roboto-Regular", size: 17)
        lblDiscount.textColor = UIColor.init("#6D778E")
        lblTotalSales.font = UIFont(name: "Roboto-Regular", size: 17)
        lblTotalSales.textColor = UIColor.init("#6D778E")
    }
    
    func setFooterUI() {
        cellView.backgroundColor = UIColor.init("#F5F5F5")
        lblName.font = UIFont(name: "Roboto-Medium", size: 20)
        lblName.textColor = UIColor.init("#6D778E")
        lblActualAmt.font = UIFont(name: "Roboto-Medium", size: 20)
        lblActualAmt.textColor = UIColor.init("#6D778E")
        lblDiscount.font = UIFont(name: "Roboto-Medium", size: 20)
        lblDiscount.textColor = UIColor.init("#6D778E")
        lblTotalSales.font = UIFont(name: "Roboto-Medium", size: 20)
        lblTotalSales.textColor = UIColor.init("#6D778E")
    }
    
    func setCell(index: Int) {
        if index == 0 {
            lblName.text = "Name"
            lblActualAmt.text = "Actual \nAmount"
            lblDiscount.text = "Discount"
            lblTotalSales.text = "Total Sales"
            setHeaderUI()
        } else if index == 2 {
            lblName.text = model.name
            let tax = " ($" + String(format: "%.02f", model.tax ?? 0.00) + " TAX)"
            lblActualAmt.text = "$" + String(format: "%.02f", model.actualamt) + tax
            lblDiscount.text = "$" + String(format: "%.02f", model.discount)
            lblTotalSales.text = "$" + String(format: "%.02f", model.totalsales)
            setCellsUI()
        } else if index == 4 {
            lblName.text = model.name
            lblActualAmt.text = "$" + String(format: "%.02f", model.actualamt)
            if model.actualamt == 0.00 {
                lblDiscount.text = "$" + String(format: "%.02f", model.discount)
            } else {
                lblDiscount.text = "$" + String(format: "%.02f", model.discount) + "\n" + "(applied)"
            }
            lblTotalSales.text = "$" + String(format: "%.02f", model.totalsales)
            setCellsUI()
        } else if index == 6     {
            lblName.text = model.name
            lblActualAmt.text = "$" + String(format: "%.02f", model.actualamt)
            lblDiscount.text = "$" + String(format: "%.02f", model.discount)
            lblTotalSales.text = "$" + String(format: "%.02f", model.totalsales)
            setFooterUI()
        } else {
            lblName.text = model.name
            lblActualAmt.text = "$" + String(format: "%.02f", model.actualamt)
            lblDiscount.text = "$" + String(format: "%.02f", model.discount)
            lblTotalSales.text = "$" + String(format: "%.02f", model.totalsales)
            setCellsUI()
        }
    }

}
