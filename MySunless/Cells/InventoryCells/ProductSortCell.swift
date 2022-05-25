//
//  ProductSortCell.swift
//  MySunless
//
//  Created by iMac on 24/05/22.
//

import UIKit

class ProductSortCell: UITableViewCell {
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var btnBackward: UIButton!
    @IBOutlet var btnForward: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    

}
