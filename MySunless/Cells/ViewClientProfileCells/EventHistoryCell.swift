//
//  EventHistoryCell.swift
//  MySunless
//
//  Created by Daydream Soft on 23/03/22.
//

import UIKit
import Kingfisher
import SCLAlertView

class EventHistoryCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var btnImgServiceProvider: UIButton!
    @IBOutlet var lblServiceProviderName: UILabel!
    @IBOutlet var lblAppointmentName: UILabel!
    @IBOutlet var lblEventID: UILabel!
    @IBOutlet var lblServiceDate: UILabel!
    @IBOutlet var lblServiceStatus: UILabel!
    @IBOutlet var lblBookedDate: UILabel!
    @IBOutlet var lblBeforeNoteTime: UILabel!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var btnDelete: UIButton!
    
    var model = EventList(dict: [:])
    var delegate: EventHistoryProtocol?
    var alertTitle = "Temporary Delete?"
    var alertSubtitle = "Once deleted, it will move to Archive list!"
    
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
        let imgUrl = URL(string: model.ProfileImg)
        imgView.kf.setImage(with: imgUrl)
        lblServiceProviderName.text = model.FirstName + " " + model.LastName + "(" + model.username + ")"
        lblAppointmentName.text = model.title
        lblEventID.text = "\(model.id)"
        lblServiceDate.text = model.EventDate
        lblServiceStatus.text = model.eventstatus
        lblBookedDate.text = model.datecreated
        lblBeforeNoteTime.text = model.timediff
        btnImgServiceProvider.tag = index
        btnEdit.tag = index
        btnDelete.tag = index
    }
    
    func addDeleteAlert() {
        let alert = SCLAlertView()
        alert.addButton("Yes, delete it!", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(deleteClick(_:)))
        alert.addButton("Cancel", backgroundColor: UIColor.init("#E95268"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertTitle, subTitle: alertSubtitle)
    }

    @IBAction func btnImgServiceProvider(_ sender: UIButton) {
        delegate?.showUserDetail()
    }
    
    @IBAction func btnEditClick(_ sender: UIButton) {
    }
    
    @IBAction func btnDeleteClick(_ sender: UIButton) {
        addDeleteAlert()
    }
    
    @objc func deleteClick(_ sender: UIButton) {
        delegate?.deleteEventHistory(eventId: model.id)
    }
    
}
