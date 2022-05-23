//
//  SalesInfoCell.swift
//  MySunless
//
//  Created by Daydream Soft on 16/03/22.
//

import UIKit

class SalesInfoCell: UITableViewCell {
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var lblCusomerName: UILabel!
    @IBOutlet var lblInvoiceNumber: UILabel!
    @IBOutlet var lblType: UILabel!
    @IBOutlet var lblOrderDate: UILabel!
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var btnView: UIButton!
    
    var modelSales = ViewSalesUserInfo(dictionary: [:])
   
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
        let imgUrl = URL(string: modelSales?.profileImg ?? "")
        imgView.kf.setImage(with: imgUrl)
        lblCusomerName.text = modelSales?.client_Fullname?.capitalized
        lblType.text = modelSales?.paymentType
        var orderdate = modelSales?.orderdate
        orderdate?.removeLast(9)
        lblOrderDate.text = orderdate
        lblAmount.text = "$" + (modelSales?.paymentAmount ?? "")
        
    }
    
    @IBAction func btnViewClcik(_ sender: UIButton) {
      
    }
   
}

