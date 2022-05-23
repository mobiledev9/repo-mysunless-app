//
//  ClientListCell.swift
//  MySunless
//
//  Created by iMac on 30/11/21.
//

import UIKit
import SCLAlertView

class ClientListCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var btnClientImgProfile: UIButton!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblPhone: UILabel!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var btnView: UIButton!
    @IBOutlet var btnCheckmark: UIButton!
    
    var delegate: UpdateClientData?
    var modelClient = ClientList(dict: [:])
    var parent = ClientsVC()
    var alertTitle = "Temporary Delete?"
    var alertSubtitle = "Once deleted, it will move to Archive list!"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height / 2
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(index: Int, isCheckAll: Bool) {
        let url = URL(string: modelClient.ProfileImg)
        imgProfile.kf.setImage(with: url)
        lblName.text = modelClient.firstName.capitalized + " " + modelClient.lastName.capitalized
        lblEmail.text = modelClient.email
        lblPhone.text = modelClient.phone
        btnClientImgProfile.tag = index
        btnEdit.tag = index
        btnView.tag = index
        btnDelete.tag = index
        btnCheckmark.tag = index
      //  btnCheckmark.setImage(UIImage(named: "blank-check-box"), for: .normal)
        isCheckAll == true ? btnCheckmark.setImage(UIImage(named: "check-box"), for: .normal) : btnCheckmark.setImage(UIImage(named: "blank-check-box"), for: .normal)
    }
    
    func addRestoreAlert() {
        let alert = SCLAlertView()
        alert.addButton("Yes, delete it!", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(deleteClick(_:)))
        alert.addButton("Cancel", backgroundColor: UIColor.init("#E95268"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertTitle, subTitle: alertSubtitle)
    }
    
    @IBAction func btnCheckmarkClick(_ sender: UIButton) {
        if (sender.currentImage?.description.contains("blank-check-box") == true) {
            sender.setImage(UIImage(named: "check-box"), for: .normal)
            if !(parent.arrSelectedIds.contains("\(modelClient.id)")) {
                parent.arrSelectedIds.append("\(modelClient.id)")
            }
        } else {
            sender.setImage(UIImage(named: "blank-check-box"), for: .normal)
            if (parent.arrSelectedIds.contains("\(modelClient.id)")) {
                parent.arrSelectedIds = parent.arrSelectedIds.filter { $0 != "\(modelClient.id)" }
            }
        }
    }
    
    @IBAction func btnImgProfileClick(_ sender: UIButton) {
        delegate?.showClientDetailVC(id: modelClient.id)
    }
    
    @IBAction func btnEditClick(_ sender: UIButton) {
        delegate?.editButton(id: modelClient.id)
    }
    
    @IBAction func btnDeleteClick(_ sender: UIButton) {
        addRestoreAlert()
    }
    
    @IBAction func btnViewClick(_ sender: UIButton) {
        delegate?.showClientProfileVC(id: modelClient.id)
    }
    
    @objc func deleteClick(_ sender: UIButton) {
        delegate?.callDeleteClientAPI(id: ["\(modelClient.id)"])
    }
    
}
