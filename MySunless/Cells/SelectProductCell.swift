//
//  SelectProductCell.swift
//  MySunless
//
//  Created by iMac on 28/02/22.
//

import UIKit

class SelectProductCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var lblBarcode: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblSellingPrice: UILabel!
    @IBOutlet var lblSalesTax: UILabel!
    @IBOutlet var lblQtyAvailable: UILabel!
    @IBOutlet var btnCheckbox: UIButton!
    
    var modelProduct = ViewProduct(dictionary: [:])
    var parent = SelectProductVC()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.borderWidth = 0.5
        cellView.layer.borderColor = UIColor.lightGray.cgColor
        cellView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(index: Int) {
        lblBarcode.text = modelProduct?.barcode
        lblName.text = modelProduct?.productTitle
        lblSellingPrice.text = "$\(modelProduct?.sellingPrice ?? 0)"
        lblSalesTax.text = (modelProduct?.onlytax ?? "0") + "%"
        lblQtyAvailable.text = "\(modelProduct?.noofPorduct ?? 0)"
        btnCheckbox.tag = index
    }
    
    @IBAction func btnCheckboxClick(_ sender: UIButton) {
        if (sender.currentImage?.description.contains("blank-check-box") == true) {
            sender.setImage(UIImage(named: "check-box"), for: .normal)
            parent.arrSelectedProductIds.append("\(modelProduct?.id ?? 0)")
            parent.arrAddedProductIds.removeAll()
            
            for dic in parent.arrCartListProduct {
                for ids in dic.productIds! {
                    if ids == "\(modelProduct?.id ?? 0)" {
                        parent.arrAddedProductTitle.append(modelProduct?.productTitle ?? "")
                        parent.arrAddedProductIds.append("\(modelProduct?.id ?? 0)")
                    }
                }
            }
        } else {
            sender.setImage(UIImage(named: "blank-check-box"), for: .normal)
            parent.arrSelectedProductIds = parent.arrSelectedProductIds.filter{$0 != "\(modelProduct?.id ?? 0)"}
            parent.arrAddedProductIds = parent.arrAddedProductIds.filter{$0 != "\(modelProduct?.id ?? 0)"}
            parent.arrAddedProductTitle = parent.arrAddedProductTitle.filter{$0 != "\(modelProduct?.productTitle ?? "")"}
        }
    }
    

}
