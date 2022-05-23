//
//  TopSellingCell.swift
//  MySunless
//
//  Created by Daydream Soft on 20/04/22.
//

import UIKit

class TopSellingCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    var model = TopSellingProducts(dict: [:])
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell() {
        lblProductName.text = model.ProductTitle
        lblPrice.text = "$" + "\(model.SellingPrice)"
        lblQuantity.text = "\(model.SUMProdcutQuality)"
        lblAmount.text = "$" + "\(model.SUMProductFianlPrice)"
    }

}
