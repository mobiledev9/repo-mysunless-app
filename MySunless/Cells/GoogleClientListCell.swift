//
//  GoogleClientListCell.swift
//  MySunless
//
//  Created by dds on 09/11/22.
//

import UIKit

class GoogleClientListCell: UITableViewCell {
    @IBOutlet var cellView: UIView!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var btnClientImgProfile: UIButton!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblPhone: UILabel!
    @IBOutlet var btnCheckmark: UIButton!
    
    @IBOutlet weak var btnSave: UIButton!
    var delegate: UpdateClientData?
    var modelGoogleContact : GoogleClientList? = nil
    var parent = GoogleContactListVC()
    
    
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
        let url = URL(string: modelGoogleContact!.profileUrl)
        imgProfile.kf.setImage(with: url)
        lblName.text = modelGoogleContact?.contactName ?? ""
        lblEmail.text = modelGoogleContact?.email ?? ""
        lblPhone.text = modelGoogleContact?.phone ?? ""
        btnClientImgProfile.tag = index
        btnCheckmark.tag = index
      //  btnCheckmark.setImage(UIImage(named: "blank-check-box"), for: .normal)
        isCheckAll == true ? btnCheckmark.setImage(UIImage(named: "check-box"), for: .normal) : btnCheckmark.setImage(UIImage(named: "blank-check-box"), for: .normal)
    }
    
    
    @IBAction func btnCheckmarkClick(_ sender: UIButton) {
        if (sender.currentImage?.description.contains("blank-check-box") == true) {
            sender.setImage(UIImage(named: "check-box"), for: .normal)
            if !(parent.arrSelectedIds.contains(modelGoogleContact?.contactName ?? "")) {
                parent.arrSelectedIds.append(modelGoogleContact?.contactName ?? "")
            }
        } else {
            sender.setImage(UIImage(named: "blank-check-box"), for: .normal)
            if (parent.arrSelectedIds.contains(modelGoogleContact?.contactName ?? "")) {
                parent.arrSelectedIds = parent.arrSelectedIds.filter { $0 != modelGoogleContact?.contactName ?? "" }
            }
        }
    }
    
    
}
