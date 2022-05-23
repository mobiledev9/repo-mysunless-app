//
//  ServiceCell.swift
//  MySunless
//
//  Created by iMac on 21/01/22.
//

import UIKit

class ServiceCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var lblServiceName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
//        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
//        cellView.layer.cornerRadius = 12
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
