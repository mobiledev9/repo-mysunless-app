//
//  NotesListCell.swift
//  MySunless
//
//  Created by iMac on 19/02/22.
//

import UIKit

class NotesListCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var txtVwDescription: UITextView!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var btnEdit: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
        txtVwDescription.layer.borderColor = UIColor.gray.cgColor
        txtVwDescription.layer.borderWidth = 0.5
        txtVwDescription.layer.cornerRadius = 12
        
    }
    
    override func layoutSubviews() {
        txtVwDescription.textColor = UIColor.init("#6D778E")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
