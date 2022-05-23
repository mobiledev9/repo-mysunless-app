//
//  ProductBarcodeVC.swift
//  MySunless
//
//  Created by Daydream Soft on 29/03/22.
//

import UIKit
import Alamofire
import SCLAlertView

class ProductBarcodeVC: UIViewController {
    
    @IBOutlet weak var vw_BarcodeId: UIView!
    @IBOutlet weak var txtBarcodeId: UITextField!
    @IBOutlet var vw_main: UIView!
    @IBOutlet var vw_bottom: UIView!
    @IBOutlet var vw_top: UIView!
    
    var token = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        hideKeyboardWhenTappedAround()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    func setInitially() {
        vw_BarcodeId.layer.borderWidth = 0.5
        vw_BarcodeId.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_main.layer.borderWidth = 1.0
        vw_main.layer.borderColor = UIColor.init("#005CC8").cgColor
        vw_top.layer.cornerRadius = 12
        vw_top.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        vw_bottom.layer.cornerRadius = 12
        vw_bottom.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        txtBarcodeId.delegate = self
    }
    
    func setValidation() -> Bool {
        if txtBarcodeId.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please Enter the Barcode", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func showSCLAlert(alertMainTitle: String, alertTitle: String) {
        let alert = SCLAlertView()
        alert.addButton("OK", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            let storyBoard = UIStoryboard(name:"Main", bundle: nil)
            if let conVC = storyBoard.instantiateViewController(withIdentifier: "AddProductVC") as? AddProductVC,
               let navController = window?.rootViewController as? UINavigationController {
                conVC.barcode = self.txtBarcodeId.text ?? ""
                conVC.tittle = "Update Product"
                conVC.isEdit = true
                self.dismiss(animated: true, completion: nil)
                navController.pushViewController(conVC, animated: true)
            }
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertMainTitle, subTitle: alertTitle)
    }
    
    func callAddBarcodeAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["barcode": txtBarcodeId.text ?? ""]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + ADD_BARCODE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let response = res.value(forKey: "response") as? String {
                            print(response)
                            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                            let storyBoard = UIStoryboard(name:"Main", bundle: nil)
                            if let conVC = storyBoard.instantiateViewController(withIdentifier: "AddProductVC") as? AddProductVC,
                               let navController = window?.rootViewController as? UINavigationController {
                                conVC.barcode = self.txtBarcodeId.text ?? ""
                                conVC.tittle = "Add New Product"
                                self.dismiss(animated: true, completion: nil)
                                navController.pushViewController(conVC, animated: true)
                            }
                        }
                    } else if success == 0 {
                        if let response = res.value(forKey: "response") as? String {
                            self.showSCLAlert(alertMainTitle: "", alertTitle: response)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnSubmitBarcodeClick(_ sender: UIButton) {
        if setValidation() {
            callAddBarcodeAPI() 
        }
    }
    
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ProductBarcodeVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtBarcodeId.resignFirstResponder()
    }
}
