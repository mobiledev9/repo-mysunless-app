//
//  ImporttExportCell.swift
//  MySunless
//
//  Created by Daydream Soft on 29/07/22.
//

import UIKit

class ImporttExportCell: UICollectionViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
    }

}
