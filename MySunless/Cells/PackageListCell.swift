//
//  PackageListCell.swift
//  MySunless
//
//  Created by iMac on 11/01/22.
//

import UIKit

class PackageListCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblPackageDate: UILabel!
    @IBOutlet var lblRemainingVisit: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var btnDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
        btnDelete.layer.cornerRadius = btnDelete.frame.height/2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
