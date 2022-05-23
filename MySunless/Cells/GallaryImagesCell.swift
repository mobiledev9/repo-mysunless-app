//
//  GallaryImageCell.swift
//  MySunless
//
//  Created by Daydream Soft on 05/03/22.
//

import UIKit

class GallaryImagesCell: UITableViewCell {
    @IBOutlet var cellView: UIView!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var lblGallaryDate: UILabel!
    @IBOutlet var btnEditGallary: UIButton!
    @IBOutlet var btnDeleteGallary: UIButton!
    
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
