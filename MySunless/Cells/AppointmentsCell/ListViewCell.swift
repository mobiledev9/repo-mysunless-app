//
//  ListViewCell.swift
//  MySunless
//
//  Created by Daydream Soft on 04/04/22.
//

import UIKit
import Kingfisher
import SCLAlertView

class ListViewCell: UITableViewCell {
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var lblCustomerName: UILabel!
    @IBOutlet var lblStartDateTime: UILabel!
    @IBOutlet var lblServiceProvider: UILabel!
    @IBOutlet var lblService: UILabel!
    @IBOutlet var lblContactNumber: UILabel!
    @IBOutlet var lblContactEmail: UILabel!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var btnShowClientDetail: UIButton!
    @IBOutlet weak var imgCustomer: UIImageView!
    
    var modelAppointment : ShowAppointmentList!
    var alertTitle = "Temporary Delete?"
    var alertSubtitle = "Once deleted, it will move to Archive list!"
    var parent = EventListViewVC()
    var delegate: PaymentHistoryCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
        imgCustomer.layer.cornerRadius = imgCustomer.frame.size.height / 2
    }
    
    func addDeleteAlert() {
        let alert = SCLAlertView()
        alert.addButton("Yes, delete it!", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(deletePermanently(_:)))
        alert.addButton("Cancel", backgroundColor: UIColor.init("#E95268"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertTitle, subTitle: alertSubtitle)
    }
    
    @objc func deletePermanently(_ sender: UIButton) {
        //  delegate?.deleteClient(id: modelClient.id)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func btnEditClick(_ sender: UIButton) {
        delegate?.editEventListView(index: sender.tag)
    }
    
    @IBAction func btnDeleteClick(_ sender: UIButton) {
        addDeleteAlert()
    }
    
    @IBAction func btnShowClientDetailClick(_ sender: UIButton) {
        showClientDetail(clientId: modelAppointment.clientid!)
    }
    
    func showClientDetail(clientId: Int) {
        delegate?.showClientDetail(clientId: modelAppointment.clientid!)
    }
    
    func setCell(index: Int) {
        let imgUrl = URL(string: modelAppointment.profileImg!)
        imgCustomer.kf.setImage(with: imgUrl)
        lblCustomerName.text = "\(modelAppointment.client_firstname ?? "") \(modelAppointment.client_Lastname ?? "")"
        let strEventDate  = AppData().converterDateFromString(dateString: modelAppointment.eventDate!, withFormat: "MM-dd-yyyy")
        let strStartTime = AppData().converterDateFromString(dateString: modelAppointment.eventDate!, withFormat: "h:mm a") ?? ""
        let strEndTime: String = AppData().converterDateFromString(dateString: modelAppointment.end_date!, withFormat: "h:mm a") ?? ""
        let weakDay: String = AppData().dayOfTheWeek(dateString: modelAppointment.eventDate!) ??  ""
        
        lblStartDateTime.attributedText = NSAttributedString(string: "\(strEventDate ?? "")\n\(String(describing: strStartTime)) - \(strEndTime )\n\(weakDay )")
        //modelAppointment.eventDate
        lblService.attributedText = NSAttributedString(string:"\(modelAppointment.title ?? "") (\(modelAppointment.username ?? ""))")
        
        lblContactNumber.text = modelAppointment.client_phone
        lblContactEmail.text = modelAppointment.client_email
        lblStatus.text = modelAppointment.eventstatus!
        
        btnEdit.tag = index
        btnDelete.tag = index
    }
}
