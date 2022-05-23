//
//  ProductBrandCell.swift
//  MySunless
//
//  Created by Daydream Soft on 30/03/22.
//

import UIKit
import SCLAlertView

class ProductBrandCell: UITableViewCell {
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var lblBrand: UILabel!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var btnDelete: UIButton!
    
    var model = ShowProductBrand(dict: [:])
    var delegate: ProductBrandListProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func showSCLAlert(alertMainTitle: String, alertTitle: String) {
        let alert = SCLAlertView()
        alert.addButton("OK", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            self.delegate?.calldeleteProductBrandAPI(brandId: self.model.id)
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertMainTitle, subTitle: alertTitle)
    }
    
    func setCell(index: Int) {
        lblBrand.text = model.Brand
        btnEdit.tag = index
        btnDelete.tag = index
    }
    
    @IBAction func btnEditClick(_ sender: UIButton) {
        delegate?.editBrand(brandId: model.id, brandName: model.Brand)
    }
    
    @IBAction func btnDeleteClick(_ sender: UIButton) {
        showSCLAlert(alertMainTitle: "Are you sure?", alertTitle: "Once deleted, you will lost all data of this Brand!")
    }

}
