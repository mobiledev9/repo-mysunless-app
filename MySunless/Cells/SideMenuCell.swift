//
//  SideMenuCell.swift
//  CustomSideMenuiOSExample
//
//  Created by John Codeos on 2/7/21.
//

import UIKit

class SideMenuCell: UITableViewCell {
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var expandImageView: UIImageView!
    @IBOutlet var iconImageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var expandImgTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var vw_lock: UIView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}


