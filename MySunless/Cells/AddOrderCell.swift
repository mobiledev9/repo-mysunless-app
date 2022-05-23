//
//  AddOrderCell.swift
//  MySunless
//
//  Created by iMac on 26/02/22.
//

import UIKit
import Foundation
import SCLAlertView

class AddOrderCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var vw_item: UIView!
    @IBOutlet var txtItem: UITextField!
    @IBOutlet var vw_qty: UIView!
    @IBOutlet var txtQty: UITextField!
    @IBOutlet var vw_price: UIView!
    @IBOutlet var txtPrice: UITextField!
    @IBOutlet var vw_discount: UIView!
    @IBOutlet var txtDiscount: UITextField!
    @IBOutlet var vw_discountinmod: UIView!
    @IBOutlet var txtDiscountInMod: UITextField!
    @IBOutlet var vw_totalPrice: UIView!
    @IBOutlet var txtTotalPrice: UITextField!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var titleItem: UILabel!
    @IBOutlet var titleQty: UILabel!
    @IBOutlet var titlePrice: UILabel!
    @IBOutlet var titleDiscount: UILabel!
    @IBOutlet var titleDiscountPercent: UILabel!
    @IBOutlet var titleTotalPrice: UILabel!
    @IBOutlet var txtTax: UITextField!
    
    var delegate: AddOrderProtocol?
    var totalPrice = Float()
    var arrCartListCell = [CartList]()
    var price = Float()
    var discount = Float()
    var discountInMod = Float()
    var parent = AddOrderVC()
    var index = Int()
    var model = CartList()
    var tax = Float()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnDelete.layer.cornerRadius = 8
        vw_item.layer.borderWidth = 0.5
        vw_item.layer.borderColor = UIColor.black.cgColor
        vw_qty.layer.borderWidth = 0.5
        vw_qty.layer.borderColor = UIColor.black.cgColor
        vw_price.layer.borderWidth = 0.5
        vw_price.layer.borderColor = UIColor.black.cgColor
        vw_discount.layer.borderWidth = 0.5
        vw_discount.layer.borderColor = UIColor.black.cgColor
        vw_discountinmod.layer.borderWidth = 0.5
        vw_discountinmod.layer.borderColor = UIColor.black.cgColor
        vw_totalPrice.layer.borderWidth = 0.5
        vw_totalPrice.layer.borderColor = UIColor.black.cgColor
        txtTax.layer.cornerRadius = 8
        txtDiscount.delegate = self
        txtDiscountInMod.delegate = self
        txtQty.delegate = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(index: Int) {
        txtItem.text = model.item
        txtQty.text = "\(model.qty)"
        txtPrice.text = "\(model.price.clean)"
        txtDiscount.text = String(format:"%.02f",model.discount)
        txtDiscountInMod.text = String(format:"%.02f",model.discountPercent)
        txtTotalPrice.text = String(format:"%.02f",model.totalPrice)
        
        if model.showTax {
            txtTax.isHidden = false
            txtTax.text = String(format: "%.02f", model.tax)
        } else {
            txtTax.isHidden = true
            txtTax.text = " "
        }
        
        btnDelete.tag = index
    }
    
    func showDiscountAlert() {
        self.txtDiscount.resignFirstResponder()
        let alert = SCLAlertView()
        alert.addButton("OK", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            self.discount = 0.00
            self.discountInMod = 0.00
            self.totalPrice = self.price - self.discount
            self.arrCartListCell[self.index].discount = self.discount
            self.arrCartListCell.indices.filter{ self.arrCartListCell[$0].item == self.txtItem.text }.forEach{ self.arrCartListCell[$0].discountPercent = self.discountInMod }
            self.arrCartListCell.indices.filter{ self.arrCartListCell[$0].item == self.txtItem.text }.forEach{ self.arrCartListCell[$0].totalPrice = self.totalPrice }
            self.parent.totalServicePrice = 0.00
            self.parent.totalProductPrice = 0.00
            self.parent.totalPackagePrice = 0.00
            for i in self.arrCartListCell {
                if i.selectedItem == "Service" {
                    self.parent.totalServicePrice = self.parent.totalServicePrice + i.totalPrice
                } else if i.selectedItem == "Product" {
                    self.parent.totalProductPrice = self.parent.totalProductPrice + i.totalPrice
                } else if i.selectedItem == "Package" {
                    self.parent.totalPackagePrice = self.parent.totalPackagePrice + i.totalPrice
                }
            }
            self.delegate?.setServiceAndTotalAmt(selectedItem: self.arrCartListCell[self.index].selectedItem, totalAmt: self.totalPrice, arrCart: self.arrCartListCell)
            DispatchQueue.main.async {
                self.parent.tblCartList.reloadData()
            }
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess("", subTitle: "Sorry no discount more than actual price")
    }
    
    func showDiscountInModAlert() {
        txtDiscountInMod.resignFirstResponder()
        let alert = SCLAlertView()
        alert.addButton("OK", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            self.discount = 0.00
            self.discountInMod = 0.00
            self.totalPrice = self.price - self.discount
            self.arrCartListCell[self.index].discountPercent = self.discountInMod
            self.arrCartListCell.indices.filter{ self.arrCartListCell[$0].item == self.txtItem.text }.forEach{ self.arrCartListCell[$0].discount = self.discount }
            self.arrCartListCell.indices.filter{ self.arrCartListCell[$0].item == self.txtItem.text }.forEach{ self.arrCartListCell[$0].totalPrice = self.totalPrice }
            self.parent.totalServicePrice = 0.00
            self.parent.totalProductPrice = 0.00
            self.parent.totalPackagePrice = 0.00
            for i in self.arrCartListCell {
                if i.selectedItem == "Service" {
                    self.parent.totalServicePrice = self.parent.totalServicePrice + i.totalPrice
                } else if i.selectedItem == "Product" {
                    self.parent.totalProductPrice = self.parent.totalProductPrice + i.totalPrice
                } else if i.selectedItem == "Package" {
                    self.parent.totalPackagePrice = self.parent.totalPackagePrice + i.totalPrice
                }
            }
            self.delegate?.setServiceAndTotalAmt(selectedItem: self.arrCartListCell[self.index].selectedItem, totalAmt: self.totalPrice, arrCart: self.arrCartListCell)
            DispatchQueue.main.async {
                self.parent.tblCartList.reloadData()
            }
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess("", subTitle: "Sorry no discount more than actual price")
    }
    
    @IBAction func btnDeleteCartItemClick(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: parent.tblCartList)
        guard let indexpath = parent.tblCartList.indexPathForRow(at: point) else {return}
        parent.arrCartList.remove(at: indexpath.row)
        parent.tblCartList.beginUpdates()
        parent.tblCartList.deleteRows(at: [IndexPath(row: indexpath.row, section: 0)], with: .automatic)
        parent.tblCartList.endUpdates()
        
        if parent.arrServiceIds.count != 0 {
            parent.arrServiceIds.remove(at: indexpath.row)
        }
        if parent.arrServiceProviderIds.count != 0 {
            parent.arrServiceProviderIds.remove(at: indexpath.row)
        }
        if parent.arrServiceStartTime.count != 0 {
            parent.arrServiceStartTime.remove(at: indexpath.row)
        }
        if parent.arrPackageIds.count != 0 {
            parent.arrPackageIds.remove(at: indexpath.row)
        }
        if parent.arrNoOfVisit.count != 0 {
            parent.arrNoOfVisit.remove(at: indexpath.row)
        }
        if parent.arrPackageExpiryDate.count != 0 {
            parent.arrPackageExpiryDate.remove(at: indexpath.row)
        }
        
        parent.setShowHideCartView()
        if parent.dictService.item == "Giftcard" {
            parent.giftCardAdded = false
        }
        switch model.selectedItem {
            case "Service":
                parent.totalServicePrice = parent.totalServicePrice - model.totalPrice
            case "Product":
                parent.totalProductPrice = parent.totalProductPrice - model.totalPrice
            case "Package":
                parent.totalPackagePrice = parent.totalPackagePrice - model.totalPrice
            case "Gift Card":
                parent.totalGiftCardPrice = parent.totalGiftCardPrice - model.price
                parent.giftCardAdded = false
            default:
                print("Default")
        }
        delegate?.setServiceAndTotalAmt(selectedItem: model.selectedItem, totalAmt: nil, arrCart: arrCartListCell)
    }
    
}

extension AddOrderCell: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        discount = txtDiscount.text?.floatValue() ?? 0.00
        price = txtTotalPrice.text?.floatValue() ?? 0.00
        discountInMod = txtDiscountInMod.text?.floatValue() ?? 0.00
        if textField == txtDiscount {
            if arrCartListCell.contains(where: {$0.item == txtItem.text}) {
                if discount > price {
                    showDiscountAlert()
                } else {
                    discountInMod = (discount) / (price) * 100
                }
                totalPrice = price - discount
                
                arrCartListCell[index].discount = txtDiscount.text?.floatValue() ?? 0.00
                arrCartListCell.indices.filter{ arrCartListCell[$0].item == txtItem.text }.forEach{ arrCartListCell[$0].discountPercent = discountInMod }
                arrCartListCell.indices.filter{ arrCartListCell[$0].item == txtItem.text }.forEach{ arrCartListCell[$0].totalPrice = totalPrice }
                
                parent.totalServicePrice = 0.00
                parent.totalProductPrice = 0.00
                parent.totalPackagePrice = 0.00
                for i in self.arrCartListCell {
                    if i.selectedItem == "Service" {
                        parent.totalServicePrice = parent.totalServicePrice + i.totalPrice
                    } else if i.selectedItem == "Product" {
                        parent.totalProductPrice = parent.totalProductPrice + i.totalPrice
                    } else if i.selectedItem == "Package" {
                        self.parent.totalPackagePrice = self.parent.totalPackagePrice + i.totalPrice
                    }
                }
            } else {
                
            }
            if model.selectedItem == "Gift Card" {
                txtDiscount.isUserInteractionEnabled = false
                txtDiscount.isEnabled = false
            }
        } else if textField == txtDiscountInMod {
            if arrCartListCell.contains(where: {$0.item == txtItem.text}) {
                if discountInMod > 100 {
                    showDiscountInModAlert()
                } else {
                    discount = price / 100 * discountInMod
                }
                totalPrice = price - discount
                arrCartListCell[index].discountPercent = txtDiscountInMod.text?.floatValue() ?? 0.00
                arrCartListCell.indices.filter{ arrCartListCell[$0].item == txtItem.text }.forEach{ arrCartListCell[$0].discount = discount }
                arrCartListCell.indices.filter{ arrCartListCell[$0].item == txtItem.text }.forEach{ arrCartListCell[$0].totalPrice = totalPrice }
                parent.totalServicePrice = 0.00
                parent.totalProductPrice = 0.00
                parent.totalPackagePrice = 0.00
                for i in self.arrCartListCell {
                    if i.selectedItem == "Service" {
                        parent.totalServicePrice = parent.totalServicePrice + i.totalPrice
                    } else if i.selectedItem == "Product" {
                        parent.totalProductPrice = parent.totalProductPrice + i.totalPrice
                    } else if i.selectedItem == "Package" {
                        parent.totalPackagePrice = parent.totalPackagePrice + i.totalPrice
                    }
                }
            }
            if model.selectedItem == "Gift Card" {
                txtDiscountInMod.isUserInteractionEnabled = false
            }
        } else if textField == txtQty {
            switch model.selectedItem {
                case "Service":
                    txtQty.isUserInteractionEnabled = false
                case "Product":
                    txtQty.isUserInteractionEnabled = true
                    if txtQty.text != "" {
                        tax = (model.tax) * (txtQty.text?.floatValue() ?? 0.00)
                        txtTax.text = String(format: "%.02f", tax)
                        totalPrice = (model.totalPrice) * (txtQty.text?.floatValue() ?? 0.00)
                        txtTotalPrice.text = String(format: "%.02f", totalPrice)
                        arrCartListCell[index].totalPrice = totalPrice
                        arrCartListCell[index].tax = tax
                        arrCartListCell[index].qty = txtQty.text ?? ""
                        self.parent.totalProductPrice = 0.00
                        for i in self.arrCartListCell {
                            if i.selectedItem == "Product" {
                                self.parent.totalProductPrice = self.parent.totalProductPrice + i.totalPrice
                            }
                        }
                    }
                case "Package":
                    txtQty.isUserInteractionEnabled = false
                case "Gift Card":
                    txtQty.isUserInteractionEnabled = false
                default:
                    print("Default")
            }
        }
        delegate?.setServiceAndTotalAmt(selectedItem: arrCartListCell[index].selectedItem, totalAmt: totalPrice, arrCart: arrCartListCell)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtDiscount {
            if model.selectedItem == "Gift Card" {
                let inputView = UIView(frame: .zero)
                inputView.backgroundColor = UIColor.clear
                inputView.isOpaque = false
                txtDiscount.inputView = inputView
                txtDiscount.isUserInteractionEnabled = false
                txtDiscount.isEnabled = false
                return false
            }
            
        } else if textField == txtDiscountInMod {
            if model.selectedItem == "Gift Card" {
                let inputView = UIView(frame: .zero)
                inputView.backgroundColor = UIColor.clear
                inputView.isOpaque = false
                txtDiscountInMod.inputView = inputView
                txtDiscountInMod.isUserInteractionEnabled = false
                return false
            }
        } else if textField == txtQty {
            if model.selectedItem == "Gift Card" {
                let inputView = UIView(frame: .zero)
                inputView.backgroundColor = UIColor.clear
                inputView.isOpaque = false
                txtQty.inputView = inputView
                txtQty.isUserInteractionEnabled = false
                return false
            }
        }
        return true
    }

 
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtDiscount {
            DispatchQueue.main.async {
                self.parent.tblCartList.reloadData()
            }
        } else if textField == txtDiscountInMod {
            DispatchQueue.main.async {
                self.parent.tblCartList.reloadData()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtDiscount {
            DispatchQueue.main.async {
                self.parent.tblCartList.reloadData()
            }
        } else if textField == txtDiscountInMod {
            DispatchQueue.main.async {
                self.parent.tblCartList.reloadData()
            }
        } else if textField == txtQty {
            txtQty.resignFirstResponder()
            DispatchQueue.main.async {
                self.parent.tblCartList.reloadData()
            }
        }
        return true
    }
    
}
