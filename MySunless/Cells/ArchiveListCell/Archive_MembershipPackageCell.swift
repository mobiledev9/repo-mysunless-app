//
//  Archive_MembershipPackageCell.swift
//  MySunless
//
//  Created by Daydream Soft on 08/03/22.
//

import UIKit
import SCLAlertView

class Archive_MembershipPackageCell: UITableViewCell {
    @IBOutlet var cellView: UIView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblPackageDate: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblCreatedBy: UILabel!
    @IBOutlet var lblDeletedDate: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var btnCheckMark: UIButton!
    @IBOutlet var btnRestore: UIButton!
    @IBOutlet var btnClientDetail: UIButton!
    
    var modelMemPackage = ShowMembershipPackage(dict: [:])
    var delegate: RestoreMemPacDelegate?
    var parent = ArchiveListVC()
    
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
        let imgUrl = URL(string: modelMemPackage.userimg)
        imgView.kf.setImage(with: imgUrl)
        lblName.text = modelMemPackage.Name
        lblPrice.text = "$" + modelMemPackage.Price
        lblPackageDate.text = modelMemPackage.Tracking
        lblDescription.text = modelMemPackage.Description
        lblCreatedBy.text = modelMemPackage.Fullname
        lblDeletedDate.text = AppData.sharedInstance.convertToUTC(dateToConvert: modelMemPackage.datelastupdated)
        btnRestore.tag = index
        btnCheckMark.tag = index
        btnClientDetail.tag = index
        btnCheckMark.setImage(UIImage(named: "blank-check-box"), for: .normal)
    }
    
    func addRestoreAlert() {
        let alert = SCLAlertView()
        alert.addButton("OK", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(restoreClick(_:)))
        alert.addButton("Cancel", backgroundColor: UIColor.init("#E95268"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess("Restore?", subTitle: "")
    }
    
    @IBAction func btnCheckMarkClick(_ sender: UIButton) {
        if (sender.currentImage?.description.contains("blank-check-box") == true) {
            sender.setImage(UIImage(named: "check-box"), for: .normal)
            if !(parent.arrMemPackageSelectedIds.contains("\(modelMemPackage.id)")) {
                parent.arrMemPackageSelectedIds.append("\(modelMemPackage.id)")
            }
        } else {
            sender.setImage(UIImage(named: "blank-check-box"), for: .normal)
            if (parent.arrMemPackageSelectedIds.contains("\(modelMemPackage.id)")) {
                parent.arrMemPackageSelectedIds = parent.arrServiceSelectedIds.filter { $0 != "\(modelMemPackage.id)" }
            }
        }
    }
    
    @IBAction func btnRestoreClcik(_ sender: UIButton) {
        addRestoreAlert()
    }
    
    @IBAction func btnUserDetailClick(_ sender: UIButton) {
        delegate?.showUserDetail()
    }
    
    @objc func restoreClick(_ sender: UIButton) {
        delegate?.callRestoreMemPacAPI(id: ["\(modelMemPackage.id)"])
    }
    
}
