//
//  Archive_ServiceCell.swift
//  MySunless
//
//  Created by iMac on 10/03/22.
//

import UIKit
import Kingfisher
import SCLAlertView

class Archive_ServiceCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var btnCheckMark: UIButton!
    @IBOutlet var btnRestore: UIButton!
    @IBOutlet var lblServiceName: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblDuration: UILabel!
    @IBOutlet var lblIUser: UILabel!
    @IBOutlet var lblCreatedBy: UILabel!
    @IBOutlet var lblDeletedDate: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var btnClientDetail: UIButton!
    
    var modelService = ShowServiceList(dict: [:])
    var delegate: RestoreServiceDelegate?
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
        let imgUrl = URL(string: modelService.userimg)
        imgView.kf.setImage(with: imgUrl)
        lblServiceName.text = modelService.ServiceName
        lblCreatedBy.text = modelService.Fullname
        lblPrice.text = "$" + modelService.Price
        lblDuration.text = modelService.Duration
        lblIUser.text = modelService.userbane
        lblDeletedDate.text = AppData.sharedInstance.convertToUTC(dateToConvert: modelService.datelastupdated)
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
            if !(parent.arrServiceSelectedIds.contains("\(modelService.id)")) {
                parent.arrServiceSelectedIds.append("\(modelService.id)")
            }
        } else {
            sender.setImage(UIImage(named: "blank-check-box"), for: .normal)
            if (parent.arrServiceSelectedIds.contains("\(modelService.id)")) {
                parent.arrServiceSelectedIds = parent.arrServiceSelectedIds.filter { $0 != "\(modelService.id)" }
            }
        }
    }
    
    @IBAction func btnRestoreClcik(_ sender: UIButton) {
        addRestoreAlert()
    }
    
    @IBAction func btnClientDetailClick(_ sender: UIButton) {
    }
    
    @objc func restoreClick(_ sender: UIButton) {
        delegate?.callRestoreServiceAPI(id: ["\(modelService.id)"])
    }
}
