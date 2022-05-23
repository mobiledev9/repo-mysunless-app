//
//  ChoosePackageCell.swift
//  MySunless
//
//  Created by iMac on 08/11/21.
//

import UIKit

class ChoosePackageCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var lblPackageName: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblValidityDay: UILabel!
    @IBOutlet var btnRadio: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //Do reset here
      //  btnRadio.setImage(UIImage(named: "radio-off-button.png"), for: .normal)
      //  btnRadio.setImage(UIImage(named: isSelected ? "radio-off-button.png" : "radio-on-button.png"), for:.normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
       // btnRadio.setImage(UIImage(named: selected ? "radio-off-button.png" : "radio-on-button.png"), for:.normal)
    }

}
