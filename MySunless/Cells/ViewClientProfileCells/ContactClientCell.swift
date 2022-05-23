//
//  ContactClientCell.swift
//  MySunless
//
//  Created by Daydream Soft on 24/03/22.
//

import UIKit
import Kingfisher

class ContactClientCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblCommunicationDetail: UILabel!
    @IBOutlet var lblDateTime: UILabel!
    @IBOutlet var btnType: UIButton!
    @IBOutlet var btnUserDetail: UIButton!
    
    var model = ContactHistory(dict: [:])
    var delegate: ContactHistoryProtocol?
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
        imgView.layer.cornerRadius = imgView.frame.size.height / 2
        btnType.layer.cornerRadius = 8
        btnType.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 15)
        btnType.titleLabel?.textColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(index: Int) {
        btnType.tag = index
        btnUserDetail.tag = index
        let imgUrl = URL(string: model.userimg)
        imgView.kf.setImage(with: imgUrl)
        lblUserName.text = model.firstname + " " + model.lastname
        btnType.setTitle(" " + model.type.uppercased() + " ", for: .normal)
        lblCommunicationDetail.text = model.subject
        lblDateTime.text = AppData.sharedInstance.convertToUTC(dateToConvert: model.comtime)
    }

    @IBAction func btnTypeClick(_ sender: UIButton) {
        
    }
    
    @IBAction func btnUserDetailClick(_ sender: UIButton) {
        delegate?.showUserDetail()
    }
}
