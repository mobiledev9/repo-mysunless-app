//
//  PerformanceListCell.swift
//  MySunless
//
//  Created by iMac on 28/02/22.
//

import UIKit

class PerformanceListCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var empImg: UIImageView!
    @IBOutlet var empName: UILabel!
    @IBOutlet var lblAppointmentBooked: UILabel!
    @IBOutlet var lblAppointmentConfirmed: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblSMS: UILabel!
    @IBOutlet var lblOrder: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
        
        empImg.layer.cornerRadius = empImg.frame.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
