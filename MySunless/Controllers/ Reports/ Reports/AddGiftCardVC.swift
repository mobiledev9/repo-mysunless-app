//
//  AddGiftCardVC.swift
//  MySunless
//
//  Created by iMac on 28/02/22.
//

import UIKit

class AddGiftCardVC: UIViewController {

    @IBOutlet var vw_mainView: UIView!
    @IBOutlet var vw_top: UIView!
    @IBOutlet var vw_bottom: UIView!
    @IBOutlet var lblRecipientName: UILabel!
    @IBOutlet var vw_giftCardAmount: UIView!
    @IBOutlet var txtGiftCardAmount: UITextField!
    
    var token = String()
    var selectedClientName = String()
    var selectedClientId = Int()
    var delegate: AddOrderProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        hideKeyboardWhenTappedAround()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    func setInitially() {
        vw_mainView.layer.borderWidth = 1.0
        vw_mainView.layer.borderColor = UIColor.init("#005CC8").cgColor
        vw_top.layer.cornerRadius = 12
        vw_top.layer.masksToBounds = true
        vw_top.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        vw_bottom.layer.cornerRadius = 12
        vw_bottom.layer.masksToBounds = true
        vw_bottom.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        vw_giftCardAmount.layer.borderWidth = 0.5
        vw_giftCardAmount.layer.borderColor = UIColor.init("#15B0DA").cgColor
        txtGiftCardAmount.delegate = self
        lblRecipientName.text = selectedClientName
    }
    
    func setValidation() -> Bool {
        if txtGiftCardAmount.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please Enter Amount for Giftcard", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnAddToCartClick(_ sender: UIButton) {
        if setValidation() {
            self.dismiss(animated: true) {
                self.delegate?.callOrderGiftAPI(clientId: self.selectedClientId, giftCardAmount: self.txtGiftCardAmount.text ?? "")
            }
        }
    }
}

extension AddGiftCardVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtGiftCardAmount.resignFirstResponder()
    }
}
