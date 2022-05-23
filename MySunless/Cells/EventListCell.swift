//
//  EventListCell.swift
//  MySunless
//
//  Created by iMac on 09/02/22.
//

import UIKit
import iOSDropDown

class EventListCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var imgServiceProvider: UIImageView!
    @IBOutlet var imgCustomer: UIImageView!
    @IBOutlet var lblServiceProvider: UILabel!
    @IBOutlet var lblCustomer: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblPhone: UILabel!
    @IBOutlet var lblAppointmentID: UILabel!
    @IBOutlet var lblService: UILabel!
    @IBOutlet var lblCost: UILabel!
    @IBOutlet var lblDateTime: UILabel!
    @IBOutlet var dropDownStatus: DropDown!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblBookingDate: UILabel!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var btnEdit: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
        
        imgServiceProvider.layer.cornerRadius = imgServiceProvider.frame.size.height / 2
        imgCustomer.layer.cornerRadius = imgCustomer.frame.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
