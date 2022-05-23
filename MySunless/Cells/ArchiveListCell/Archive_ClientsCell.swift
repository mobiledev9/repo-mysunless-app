//
//  Archive_ClientsCell.swift
//  MySunless
//
//  Created by Daydream Soft on 09/03/22.
//

import UIKit
import SCLAlertView

class Archive_ClientsCell: UITableViewCell {
    @IBOutlet var cellView: UIView!
    @IBOutlet var lblClientName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblPhone: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblCreatedBy: UILabel!
    @IBOutlet var lblDeletedDate: UILabel!
    @IBOutlet var imageViewCreatedBy: UIImageView!
    @IBOutlet var imageViewClientName: UIImageView!
    @IBOutlet var btnCheckMark: UIButton!
    @IBOutlet var btnRestore: UIButton!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var btnClientDetail: UIButton!
    @IBOutlet var btnUserDetail: UIButton!
    
    var modelClient = ShowClient(dict: [:])
    var delegate: RestoreClientDelegate?
    var parent = ArchiveListVC()
    var alertTitle = "Permanently Delete?"
    var alertSubtitle = "Are you sure you want to delete permanently?"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
        imageViewCreatedBy.layer.cornerRadius = imageViewCreatedBy.frame.size.height / 2
        imageViewClientName.layer.cornerRadius = imageViewClientName.frame.size.height / 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(index: Int) {
        let imgUrl = URL(string: modelClient.ProfileImg)
        imageViewClientName.kf.setImage(with: imgUrl)
        let imgUrl2 = URL(string: modelClient.userimg)
        imageViewCreatedBy.kf.setImage(with: imgUrl2)
        lblClientName.text = modelClient.FirstName.capitalized + " " + modelClient.LastName.capitalized
        lblEmail.text = modelClient.email
        lblPhone.text = modelClient.Phone
        
        lblAddress.text = modelClient.Address + ", " + modelClient.City + ", " + modelClient.State + ", " + modelClient.Zip + ", " + modelClient.Country
        
        lblCreatedBy.text = modelClient.Fullname
        lblDeletedDate.text = AppData.sharedInstance.convertToUTC(dateToConvert: modelClient.datelastupdated)
        btnClientDetail.tag = index
        btnUserDetail.tag = index
        btnRestore.tag = index
        btnDelete.tag = index
        btnCheckMark.tag = index
        btnCheckMark.setImage(UIImage(named: "blank-check-box"), for: .normal)
    }
    
    func addDeleteAlert() {
        let alert = SCLAlertView()
        alert.addButton("Yes, delete it!", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(deletePermanently(_:)))
        alert.addButton("Cancel", backgroundColor: UIColor.init("#E95268"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertTitle, subTitle: alertSubtitle)
    }
    
    func addRestoreAlert() {
        let alert = SCLAlertView()
        alert.addButton("OK", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(restoreClick(_:)))
        alert.addButton("Cancel", backgroundColor: UIColor.init("#E95268"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess("Restore?", subTitle: "")
    }
    
    @IBAction func btnRestoreClcik(_ sender: UIButton) {
        addRestoreAlert()
    }
    
    @IBAction func btnDeleteClick(_ sender: UIButton) {
       addDeleteAlert()
    }
    
    @IBAction func btnCheckMarkClick(_ sender: UIButton) {
        if (sender.currentImage?.description.contains("blank-check-box") == true) {
            sender.setImage(UIImage(named: "check-box"), for: .normal)
            if !(parent.arrClientSelectedIds.contains("\(modelClient.id)")) {
                parent.arrClientSelectedIds.append("\(modelClient.id)")
            }
        } else {
            sender.setImage(UIImage(named: "blank-check-box"), for: .normal)
            if (parent.arrClientSelectedIds.contains("\(modelClient.id)")) {
                parent.arrClientSelectedIds = parent.arrClientSelectedIds.filter { $0 != "\(modelClient.id)" }
            }
        }
    }
    
    @IBAction func btnClientDetailClick(_ sender: UIButton) {
       
    }
    
    @IBAction func btnUserDetailClick(_ sender: UIButton) {
        delegate?.showUserDetail()
    }
    
    @objc func deletePermanently(_ sender: UIButton) {
        delegate?.deleteClient(id: modelClient.id)
        
    }
    
    @objc func restoreClick(_ sender: UIButton) {
        delegate?.callRestoreClientAPI(id: ["\(modelClient.id)"])
    }
    
}
