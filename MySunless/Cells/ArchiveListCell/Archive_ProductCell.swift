//
//  Archive_ProductCell.swift
//  MySunless
//
//  Created by Daydream Soft on 09/03/22.
//

import UIKit
import SCLAlertView

class Archive_ProductCell: UITableViewCell {
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var lblProductName: UILabel!
    @IBOutlet var lblCostPrice: UILabel!
    @IBOutlet var lblSellingPrice: UILabel!
    @IBOutlet var lblQuantity: UILabel!
    @IBOutlet var lblCreatedBy: UILabel!
    @IBOutlet var lblDeletedDate: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var btnCheckMark: UIButton!
    @IBOutlet var btnRestore: UIButton!
    @IBOutlet var btnClientDetail: UIButton!
    
    var modelProduct = ShowProductList(dict: [:])
    var delegate: RestoreProductDelegate?
    var parent = ArchiveListVC()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
        imgView.layer.cornerRadius = imgView.frame.height/2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(index: Int) {
        let imgUrl = URL(string: modelProduct.userimg)
        imgView.kf.setImage(with: imgUrl)
        lblProductName.text = modelProduct.ProductTitle
        lblCostPrice.text = "$" + "\(modelProduct.CompanyCost)"
        lblSellingPrice.text = "$" + "\(modelProduct.SellingPrice)"
        lblQuantity.text = "\(modelProduct.NoofPorduct)"
        lblCreatedBy.text = modelProduct.Fullname
        lblDeletedDate.text = AppData.sharedInstance.convertToUTC(dateToConvert: modelProduct.datelastupdated)
        btnClientDetail.tag = index
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
            if !(parent.arrProductSelectedIds.contains("\(modelProduct.id)")) {
                parent.arrProductSelectedIds.append("\(modelProduct.id)")
            }
        } else {
            sender.setImage(UIImage(named: "blank-check-box"), for: .normal)
            if (parent.arrProductSelectedIds.contains("\(modelProduct.id)")) {
                parent.arrProductSelectedIds = parent.arrProductSelectedIds.filter { $0 != "\(modelProduct.id)" }
            }
        }
    }
    
    @IBAction func btnRestoreClcik(_ sender: UIButton) {
        addRestoreAlert()
    }
    
    @IBAction func btnClientDetailClick(_ sender: UIButton) {
       
    }
    
    @objc func restoreClick(_ sender: UIButton) {
        delegate?.callRestoreProductAPI(id: ["\(modelProduct.id)"])
    }
}


