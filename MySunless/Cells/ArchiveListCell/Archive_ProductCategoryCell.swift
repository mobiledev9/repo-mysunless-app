//
//  Archive_ProductCategoryCell.swift
//  MySunless
//
//  Created by Daydream Soft on 09/03/22.
//

import UIKit
import SCLAlertView

class Archive_ProductCategoryCell: UITableViewCell {
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var lblProductCategory: UILabel!
    @IBOutlet var lblDeletedDate: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblCreatedBy: UILabel!
    @IBOutlet var btnCheckMark: UIButton!
    @IBOutlet var btnRestore: UIButton!
    @IBOutlet var btnUserDetail: UIButton!
    
    var modelProductCat = ShowProductCategory(dict: [:])
    var delegate: RestoreProductCatDelegate?
    var parent = ArchiveListVC()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
        imgView.layer.cornerRadius = imgView.frame.size.height / 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(index: Int) {
        let imgUrl = URL(string: modelProductCat.userimg)
        imgView.kf.setImage(with: imgUrl)
        lblProductCategory.text = modelProductCat.Category
        lblCreatedBy.text = modelProductCat.Fullname
        lblDeletedDate.text = AppData.sharedInstance.convertToUTC(dateToConvert: modelProductCat.datelastupdated)
        btnUserDetail.tag = index
        btnRestore.tag = index
        btnCheckMark.tag = index
        btnCheckMark.setImage(UIImage(named: "blank-check-box"), for: .normal)
    }
    
    func addRestoreAlert() {
        let alert = SCLAlertView()
        alert.addButton("OK", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(restoreClick(_:)))
        alert.addButton("Cancel", backgroundColor: UIColor.init("#E95268"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess("Restore?", subTitle: "")
    }
    
    @IBAction func btnCheckMarkClick(_ sender: UIButton) {
        if (sender.currentImage?.description.contains("blank-check-box") == true) {
            sender.setImage(UIImage(named: "check-box"), for: .normal)
            if !(parent.arrProductCatSelectedIds.contains("\(modelProductCat.id)")) {
                parent.arrProductCatSelectedIds.append("\(modelProductCat.id)")
            }
        } else {
            sender.setImage(UIImage(named: "blank-check-box"), for: .normal)
            if (parent.arrProductCatSelectedIds.contains("\(modelProductCat.id)")) {
                parent.arrProductCatSelectedIds = parent.arrProductCatSelectedIds.filter { $0 != "\(modelProductCat.id)" }
            }
        }
    }
    
    @IBAction func btnRestoreClcik(_ sender: UIButton) {
        addRestoreAlert()
    }
    
    @IBAction func btnUserDetailClick(_ sender: UIButton) {
       
    }
    
    @objc func restoreClick(_ sender: UIButton) {
        delegate?.callRestoreProductCatAPI(id: ["\(modelProductCat.id)"])
    }
}


