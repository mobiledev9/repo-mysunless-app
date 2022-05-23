//
//  ProductSortCell.swift
//  MySunless
//
//  Created by Daydream Soft on 30/03/22.
//

import UIKit

class ProductSortCell: UITableViewCell {
    @IBOutlet var cellView: UIView!
    @IBOutlet var lblName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnAsendingClick(_ sender: UIButton) {
        
    }
    
    @IBAction func btnDescendingClick(_ sender: UIButton) {
        
    }

}
