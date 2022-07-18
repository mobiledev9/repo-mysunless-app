//
//  TaskPreviewAssignedCell.swift
//  MySunless
//
//  Created by Daydream Soft on 14/07/22.
//

import UIKit

class TaskPreviewAssignedCell: UICollectionViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgUser.layer.cornerRadius = imgUser.frame.size.height / 2
    }
    
    
}
