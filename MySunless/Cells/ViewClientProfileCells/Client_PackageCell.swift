//
//  Client_PackageCell.swift
//  MySunless
//
//  Created by Daydream Soft on 23/03/22.
//

import UIKit

class Client_PackageCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblPackageDate: UILabel!
    @IBOutlet var lblPackageName: UILabel!
    @IBOutlet var lblServiceRemaining: UILabel!
    @IBOutlet var lblBeforeNoteTime: UILabel!
    @IBOutlet var btnUserDetail: UIButton!
    
    var model = PackageHistory(dict: [:])
    var delegate: PackageHistoryProtocol?
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
        imgView.layer.cornerRadius = imgView.frame.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(index: Int) {
        let imgUrl = URL(string: model.userimg)
        imgView.kf.setImage(with: imgUrl)
        lblUserName.text = model.packageCreatorName
        lblPackageDate.text = AppData.sharedInstance.convertToUTC(dateToConvert: model.odatecreated)
        lblPackageName.text = model.Name
        lblServiceRemaining.text = model.Noofvisit
        lblBeforeNoteTime.text = model.timediff
        btnUserDetail.tag = index
    }

    @IBAction func btnUserDetailClick(_ sender: UIButton) {
        delegate?.showUserDetail()
    }
}
