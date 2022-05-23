//
//  AppointmentCell.swift
//  MySunless
//
//  Created by Daydream Soft on 14/03/22.
//

import UIKit
import iOSDropDown
import SCLAlertView

class AppointmentCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var serviceStatusView: UIView!
    @IBOutlet var txtServiceStatus: DropDown!
    @IBOutlet var lblEid: UILabel!
    @IBOutlet var lblClientName: UILabel!
    @IBOutlet var lblAppointmentName : UILabel!
    @IBOutlet var lblServiceDate: UILabel!
    @IBOutlet var lblServiceStatus: UILabel!
    @IBOutlet var lblBookedDate: UILabel!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var btnProfile: UIButton!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var btnDelete: UIButton!
    
    var modelUserDetail = ViewAppointmentUserInfo(dict: [:])
    var delegate: ChangeAppointmentStatus?
    var alertTitle = "Are you sure?"
    var alertSubtitle = "Once deleted, it will move to Archive list!"
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
        serviceStatusView.layer.borderWidth = 0.5
        serviceStatusView.layer.borderColor = UIColor.init("#15B0DA").cgColor
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height / 2
        txtServiceStatus.optionArray = ["completed","pending","confirmed","canceled","pending-payment","in-progress"]
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(index: Int) {
        lblEid.text = "\(modelUserDetail.id)"
        let imgUrl = URL(string: modelUserDetail.ProfileImg)
        imgProfile.kf.setImage(with: imgUrl)
        lblClientName.text = modelUserDetail.FirstName + " " + modelUserDetail.LastName
        lblAppointmentName.text = modelUserDetail.title
        lblServiceDate.text = modelUserDetail.EventDate
        lblServiceStatus.text = modelUserDetail.eventstatus
        lblBookedDate.text = modelUserDetail.datelastupdated
        txtServiceStatus.text = modelUserDetail.eventstatus.capitalized
        btnProfile.tag = index
        btnEdit.tag = index
        btnDelete.tag = index
        
        txtServiceStatus.didSelect{(selectedText, index, id) in
          //  print("Selected String: \(selectedText) \n index: \(index), id: \(id)")
            self.txtServiceStatus.selectedIndex = index
          //  print(self.modelUserDetail.id)
            self.delegate?.callUpdateAppointmentStatusAPI(id: self.modelUserDetail.id, status: selectedText)
        }
    }
    
    func addRestoreAlert() {
        let alert = SCLAlertView()
        alert.addButton("Yes, delete it!", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(deleteClick(_:)))
        alert.addButton("Cancel", backgroundColor: UIColor.init("#E95268"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertTitle, subTitle: alertSubtitle)
    }
    
    @IBAction func btnDeleteClcik(_ sender: UIButton) {
        addRestoreAlert()
    }
    
    @IBAction func btnEditClick(_ sender: UIButton) {
       
    }
    
    @IBAction func btnProfileClick(_ sender: UIButton) {
    }
    
    @objc func deleteClick(_ sender: UIButton) {
        delegate?.callDeleteAppointmentInfo(id: modelUserDetail.id)
    }
}
