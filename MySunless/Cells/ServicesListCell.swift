//
//  ServicesListCell.swift
//  MySunless
//
//  Created by Daydream Soft on 04/03/22.
//

import UIKit

class ServicesListCell: UITableViewCell {
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var lblServiceName: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblDuration: UILabel!
    @IBOutlet var lblUser: UILabel!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var btnDelete: UIButton!
    
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
    
}

