//
//  ProductCategoryCell.swift
//  MySunless
//
//  Created by Daydream Soft on 30/03/22.
//

import UIKit

class ProductCategoryCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var lblCategory: UILabel!
    @IBOutlet var lblNoOfProduct: UILabel!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var btnDelete: UIButton!
    
    var model = ShowProductCategoryInventory(dict: [:])
    var delegate: ProductCategoryListProtocol?
    
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
    
    func setCell(index: Int) {
        lblCategory.text = model.Category
        lblNoOfProduct.text = "\(model.pcount)"
        btnEdit.tag = index
        btnDelete.tag = index
    }
    
    @IBAction func btnEditClick(_ sender: UIButton) {
        delegate?.callEditCatList(catId: model.id, catName: lblCategory.text ?? "")
    }
    
    @IBAction func btnDeleteClick(_ sender: UIButton) {
        delegate?.callDeleteCatListAPI(catId: model.id)
    }

}
