//
//  BannerImagesCell.swift
//  MySunless
//
//  Created by Daydream Soft on 05/03/22.
//

import UIKit

class BannerImagesCell: UITableViewCell {
    @IBOutlet var cellView: UIView!
    @IBOutlet var lblBannerDate: UILabel!
    @IBOutlet var btnDeleteBanner: UIButton!
    @IBOutlet var imgProfile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height / 2
        imgProfile.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
