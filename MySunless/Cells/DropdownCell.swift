//
//  DropdownCell.swift
//  MySunless
//
//  Created by iMac on 14/10/21.
//

import UIKit

class DropdownCell: UITableViewCell {
    
//    class var identifier: String { return String(describing: self) }
//    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }

    @IBOutlet var lblName: UILabel!
    @IBOutlet var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.backgroundColor = UIColor.init("#15B0DA")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            cellView.backgroundColor = UIColor.init("#15B0DA")
        } else {
            cellView.backgroundColor = UIColor.white
        }
    }

}
