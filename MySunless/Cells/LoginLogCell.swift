//
//  LoginLogCell.swift
//  MySunless
//
//  Created by iMac on 01/03/22.
//

import UIKit

class LoginLogCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var lblLocalLoginTime: UILabel!
    @IBOutlet var lblUTCLoginTime: UILabel!
    @IBOutlet var lblLocalLogoutTime: UILabel!
    @IBOutlet var lblUTCLogoutTime: UILabel!
    @IBOutlet var lblRunTime: UILabel!
    @IBOutlet var lblIP: UILabel!
    @IBOutlet var txtVwDevice: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
        
        imgUser.layer.cornerRadius = imgUser.frame.size.height / 2
        txtVwDevice.layer.borderColor = UIColor.gray.cgColor
        txtVwDevice.layer.borderWidth = 0.5
        txtVwDevice.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
