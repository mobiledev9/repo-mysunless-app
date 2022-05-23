//
//  TemplateListCell.swift
//  MySunless
//
//  Created by iMac on 03/01/22.
//

import UIKit

class TemplateListCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblSubject: UILabel!
    @IBOutlet var lblMessage: UILabel!
    @IBOutlet var lblCreatedDate: UILabel!
    
    @IBOutlet var btnView: UIButton!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var switchValue: UISwitch!
    
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

   
}
