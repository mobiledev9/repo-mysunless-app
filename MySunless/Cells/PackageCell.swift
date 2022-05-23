//
//  PackageCell.swift
//  MySunless
//
//  Created by iMac on 17/01/22.
//

import UIKit

class PackageCell: UITableViewCell {
    @IBOutlet var cellView: UIView!
    @IBOutlet var lblClientName: UILabel!
    @IBOutlet var lblPackageName: UILabel!
    @IBOutlet var lblPackageStartDate: UILabel!
    @IBOutlet var lblPackageEndDate: UILabel!
    @IBOutlet var lblServiceRemaining: UILabel!
    @IBOutlet var lblEmployeeSold: UILabel!
    @IBOutlet var btnAdd: UIButton!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var imgClient: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
        imgClient.layer.cornerRadius = imgClient.frame.height/2
        btnCancel.layer.cornerRadius = btnCancel.frame.height/2
        btnAdd.layer.cornerRadius = btnAdd.frame.height/2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
}
