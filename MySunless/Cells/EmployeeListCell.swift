//
//  EmployeeListCell.swift
//  MySunless
//
//  Created by iMac on 07/12/21.
//

import UIKit

class EmployeeListCell: UITableViewCell {
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var imgEmployee: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblPhonenumber: UILabel!
    @IBOutlet var btnProfile: UIButton!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var btnHours: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgEmployee.layer.cornerRadius = imgEmployee.frame.size.height / 2
        imgEmployee.clipsToBounds = true
        
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
