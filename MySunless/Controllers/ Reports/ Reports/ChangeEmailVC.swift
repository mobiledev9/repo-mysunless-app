//
//  ChangeEmailVC.swift
//  MySunless
//
//  Created by iMac on 21/04/22.
//

import UIKit

class ChangeEmailVC: UIViewController {

    @IBOutlet var vw_main: UIView!
    @IBOutlet var vw_top: UIView!
    @IBOutlet var vw_bottom: UIView!
    @IBOutlet var vw_email: UIView!
    @IBOutlet var txtEmail: UITextField!
    
    var delegate: SendMailProtocol?
    var orderId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setInitially()
        hideKeyboardWhenTappedAround()
    }
    
    func setInitially() {
        vw_main.layer.borderWidth = 1.0
        vw_main.layer.borderColor = UIColor.init("#005CC8").cgColor
        vw_top.layer.cornerRadius = 12
        vw_top.layer.masksToBounds = true
        vw_top.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        vw_bottom.layer.cornerRadius = 12
        vw_bottom.layer.masksToBounds = true
        vw_bottom.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        vw_email.layer.borderWidth = 0.5
        vw_email.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_email.layer.cornerRadius = 12
        txtEmail.delegate = self
    }
    
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSendClick(_ sender: UIButton) {
        delegate?.callOrderInvoiceMailAPI(email: txtEmail.text ?? "", orderId: orderId)
    }
    
}

extension ChangeEmailVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtEmail.resignFirstResponder()
    }
}
