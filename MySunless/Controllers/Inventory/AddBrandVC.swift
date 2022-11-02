//
//  AddBrandVC.swift
//  MySunless
//
//  Created by Daydream Soft on 30/03/22.
//

import UIKit
import Alamofire
import SCLAlertView

class AddBrandVC: UIViewController {
    
    @IBOutlet weak var vw_Brand: UIView!
    @IBOutlet weak var txtBrand: UITextField!
    @IBOutlet var vw_main: UIView!
    @IBOutlet var vw_bottom: UIView!
    @IBOutlet var vw_top: UIView!
    
    var token = String()
    var delegateBrand: ProductBrandListProtocol?
    var isEdit = false
    var brandId = Int()
    var brandName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        hideKeyboardWhenTappedAround()
    }
    
    func setValidation() -> Bool {
        if txtBrand.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Brand", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func setInitially() {
        vw_Brand.layer.borderWidth = 0.5
        vw_Brand.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_main.layer.borderWidth = 1.0
        vw_main.layer.borderColor = UIColor.init("#005CC8").cgColor
        vw_top.layer.cornerRadius = 12
        vw_top.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        vw_bottom.layer.cornerRadius = 12
        vw_bottom.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        txtBrand.text = brandName
    }
    
    func showSCLAlert(alertMainTitle: String, alertTitle: String) {
        let alert = SCLAlertView()
        alert.addButton("OK", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            self.delegateBrand?.updateProductBrandList!()
//            self.dismiss(animated: true) {
//               // self.delegate?.callShowProductBrandAPI()
//                self.delegateBrand?.updateProductBrandList!()
//            }
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertMainTitle, subTitle: alertTitle)
    }
    
    func calladdProductBrandAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        if isEdit {
            params = ["brandId": brandId,
                      "brandName": txtBrand.text ?? ""
                     ]
        } else {
            params = ["brandName": txtBrand.text ?? ""]
        }
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + ADD_PRODUCT_BRAND, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let response = res.value(forKey: "message") as? String {
                            self.showSCLAlert(alertMainTitle: "", alertTitle: response)
                            
                        }
                    } else {
                        if let response = res.value(forKey: "message") as? String {
                            self.showSCLAlert(alertMainTitle: "", alertTitle: response)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnSubmitBrandClick(_ sender: UIButton) {
        if setValidation() {
            calladdProductBrandAPI()
        }
    }
    
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
