//
//  ToDoArchiveCell.swift
//  MySunless
//
//  Created by Daydream Soft on 02/07/22.
//

import UIKit

class ToDoArchiveCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var btnCheckbox: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblArchive: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgView.layer.cornerRadius = imgView.frame.size.height / 2
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func btnCheckboxClick(_ sender: UIButton) {
    }
    
    @IBAction func btnDeleteClick(_ sender: UIButton) {
    }
    
    @IBAction func btnRestoreClick(_ sender: UIButton) {
    }
}
