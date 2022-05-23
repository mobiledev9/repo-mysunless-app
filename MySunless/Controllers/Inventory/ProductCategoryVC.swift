//
//  ProductCategoryVC.swift
//  MySunless
//
//  Created by Daydream Soft on 30/03/22.
//

import UIKit
import Alamofire
import SCLAlertView

class ProductCategoryVC: UIViewController {
    
    @IBOutlet weak var vw_Category: UIView!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet var vw_mainView: UIView!
    @IBOutlet var vw_bottom: UIView!
    @IBOutlet var vw_top: UIView!
    
    var token = String()
    var delegate: AddProductProtocol?
    var isEdit = false
    var catId = Int()
    var catName = String()
    var delegateCatList: ProductCategoryListProtocol?
    var isFromCatList = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isEdit {
            txtCategory.text = catName
        }
    }
    
    func setInitially() {
        vw_Category.layer.borderWidth = 0.5
        vw_Category.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_mainView.layer.borderWidth = 1.0
        vw_mainView.layer.borderColor = UIColor.init("#005CC8").cgColor
        vw_top.layer.cornerRadius = 12
        vw_top.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        vw_bottom.layer.cornerRadius = 12
        vw_bottom.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        txtCategory.delegate = self
    }
    
    func setValidation() -> Bool {
        if txtCategory.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter a category!", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func showSCLAlert(alertMainTitle: String, alertTitle: String) {
        let alert = SCLAlertView()
        alert.addButton("OK", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            if self.isEdit {
                self.dismiss(animated: true) {
                    self.delegateCatList?.calllistofprodcatAPI()
                }
            } else if self.isFromCatList {
                self.dismiss(animated: true) {
                    self.delegateCatList?.calllistofprodcatAPI()
                }
            } else {
                self.dismiss(animated: true) {
                    self.delegate?.callShowProdCatInventoryAPI()
                   // self.delegateCatList?.calllistofprodcatAPI()
                }
            }
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertMainTitle, subTitle: alertTitle)
    }
    
    func callAddProdCatAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["catname": txtCategory.text ?? ""]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + ADD_PRODUCT_CATEGORY, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let response = res.value(forKey: "response") as? String {
                            self.showSCLAlert(alertMainTitle: "", alertTitle: response)
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: response)
                        }
                    }
                }
            }
        }
    }
    
    func callUpdateProdCatAPI(catId: Int, catName: String) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["catid": catId,
                  "catname": catName
        ]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + ADD_PRODUCT_CATEGORY, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let message = res.value(forKey: "response") as? String {
                            self.isEdit = true
                            self.showSCLAlert(alertMainTitle: "", alertTitle: message)
                        }
                    } else {
                        if let message = res.value(forKey: "response") as? String {
                            self.showSCLAlert(alertMainTitle: "", alertTitle: message)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnSubmitCategoryClick(_ sender: UIButton) {
        if setValidation() {
            if isEdit {
                callUpdateProdCatAPI(catId: catId, catName: txtCategory.text ?? "")
            } else {
                callAddProdCatAPI()
            }
        }
    }
    
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ProductCategoryVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtCategory.resignFirstResponder()
    }
}
