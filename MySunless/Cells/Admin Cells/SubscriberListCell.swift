//
//  SubscriberListCell.swift
//  MySunless
//
//  Created by Daydream Soft on 13/06/22.
//

import UIKit
import Kingfisher

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
    
    var model = SubscriberList(dict: [:])
    var delegate: SubscriberProtocol?
    
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
    
    func setCell(index: Int) {
        switchActive.tag = index
        lblTitleSubscriber.text = "Subscriber Group: " + model.username
        let imgUrl = URL(string: model.userimg)
        imgSubscriber.kf.setImage(with: imgUrl)
        lblUsername.text = model.username
        lblUsertype.text = "(" + model.usertype.uppercased() + ")"
        lblName.text = model.firstname + " " + model.lastname
        lblCompanyName.text = model.companyname
        lblEmail.text = model.email
        lblPhone.text = model.phonenumber
        lblCreatedDate.text = model.created_at
        lblCustomerProfile.text = "\(model.clientc)"
        model.login_permission == "1" ? switchActive.setOn(true, animated: false) : switchActive.setOn(false, animated: false)
        lblDaysAgo.text = model.timediff
        
    }

    @IBAction func switchValueChanged(_ sender: UISwitch) {
        var login = String()
        if switchActive.isOn {
            login = "1"
        } else {
            login = "0"
        }
        delegate?.callSubscriberStatusAPI(subscriberId: model.id, loginPermission: login)
    }
}
