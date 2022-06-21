//
//  UserFilterCell.swift
//  MySunless
//
//  Created by Daydream Soft on 20/06/22.
//

import UIKit

class UserFilterCell: UICollectionViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

//        self.contentView.frame = self.bounds
//        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    
    
}
