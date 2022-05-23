//
//  PrivateClientNotesCell.swift
//  MySunless
//
//  Created by iMac on 01/02/22.
//

import UIKit

class PrivateClientNotesCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var imgDot: UIImageView!
    @IBOutlet var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgDot.layer.cornerRadius = imgDot.frame.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
