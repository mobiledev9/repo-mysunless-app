//
//  Archive_UserCell.swift
//  MySunless
//
//  Created by Daydream Soft on 09/03/22.
//

import UIKit

class Archive_UserCell: UITableViewCell {
    @IBOutlet var cellView: UIView!
    @IBOutlet var lblUser: UILabel!
    @IBOutlet var lblDeletedDate: UILabel!
    @IBOutlet var lblDetail: UILabel!
    @IBOutlet var imgView: UIImageView!
    
    @IBOutlet var btnCheckMark: UIButton!
    @IBOutlet var btnRestore: UIButton!
    @IBOutlet var btnClientDetail: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnCheckMarkClick(_ sender: UIButton) {
        if (sender.currentImage?.description.contains("blank-check-box") == true) {
            sender.setImage(UIImage(named: "check-box"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "blank-check-box"), for: .normal)
        }
    }
    
    @IBAction func btnRestoreClcik(_ sender: UIButton) {
       // delegate?.callRestoreServiceAPI(id: modelService.id)
    }
    @IBAction func btnClientDetailClick(_ sender: UIButton) {
       
    }
    
}
