//
//  SalesOverviewCell.swift
//  MySunless
//
//  Created by iMac on 23/03/22.
//

import UIKit

class SalesOverviewCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var btnProfileImg: UIButton!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var imgProfile: UIImageView!
    
    var modelSalesOverview = SalesOverview(dict: [:])
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cellView.layer.cornerRadius = 8
        cellView.layer.masksToBounds = true
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(index: Int) {
        let imgUrl = URL(string: modelSalesOverview.image)
        imgProfile.kf.setImage(with: imgUrl)
        lblName.text = modelSalesOverview.clientname.capitalized
        lblAmount.text = "$" + "\(modelSalesOverview.totalamount)"
    }
    
    @IBAction func btnProfileImgClick(_ sender: UIButton) {
    }
}
