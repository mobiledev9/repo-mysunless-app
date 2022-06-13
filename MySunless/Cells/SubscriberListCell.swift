//
//  SubscriberListCell.swift
//  MySunless
//
//  Created by Daydream Soft on 13/06/22.
//

import UIKit

class SubscriberListCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var lblTitleSubscriber: UILabel!
    @IBOutlet weak var imgSubscriber: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblUsertype: UILabel!
    @IBOutlet weak var lblCreatedDate: UILabel!
    @IBOutlet weak var lblCustomerProfile: UILabel!
    @IBOutlet weak var switchActive: UISwitch!
    @IBOutlet weak var lblDaysAgo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
        imgSubscriber.layer.cornerRadius = imgSubscriber.frame.size.height / 2
        lblTitleSubscriber.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        lblTitleSubscriber.layer.cornerRadius = 12
        lblTitleSubscriber.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func switchValueChanged(_ sender: UISwitch) {
    }
}
