//
//  RequestedEventsCell.swift
//  MySunless
//
//  Created by Daydream Soft on 04/04/22.
//

import UIKit

class RequestedEventsCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblServiceProvider: UILabel!
    @IBOutlet var lblContact: UILabel!
    @IBOutlet var lblClientName: UILabel!
    @IBOutlet var lblAppointmentTime: UILabel!
    @IBOutlet var btnUpdate: UIButton!
    @IBOutlet var btnCancel: UIButton!
    
    var model = RequestedEventList(dictionary: [:])
    var delegate: RequestedEventProtocol?
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(index: Int) {
        lblTitle.text = model?.title
        lblServiceProvider.text = (model?.firstname ?? "") + " " + (model?.lastname ?? "")
        lblClientName.text = (model?.firstName ?? "") + " " + (model?.lastName ?? "")
        lblContact.text = model?.phone
        lblAppointmentTime.text = model?.eventDate
    }
    
    @IBAction func btnUpdateClick(_ sender: UIButton) {
        delegate?.callAcceptAppointmentAPI(id: model?.id ?? 0)
        
    }
    
    @IBAction func btnCancelClick(_ sender: UIButton) {
        delegate?.callNotAcceptAppointmentAPI(id: model?.id ?? 0)
    }

}
