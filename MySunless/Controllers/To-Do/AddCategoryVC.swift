//
//  AddCategoryVC.swift
//  MySunless
//
//  Created by Daydream Soft on 21/06/22.
//

import UIKit
import Alamofire
import SCLAlertView

class AddCategoryVC: UIViewController {

    @IBOutlet weak var vw_main: UIView!
    @IBOutlet weak var vw_top: UIView!
    @IBOutlet weak var vw_bottom: UIView!
    @IBOutlet weak var vw_categoryName: UIView!
    @IBOutlet weak var txtCategoryName: UITextField!
    
    var token = String()
    var delegate: ToDoProtocol?
    var isEdit = false
    var catName = String()
    var catId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setInitially()
        hideKeyboardWhenTappedAround()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        if isEdit {
            txtCategoryName.text = catName
        }
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
        vw_categoryName.layer.borderWidth = 0.5
        vw_categoryName.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_categoryName.layer.cornerRadius = 12
        txtCategoryName.delegate = self
    }
    
    func setValidation() -> Bool {
        if txtCategoryName.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter category name", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func addCustomAlert(message: String) {
        let alert = SCLAlertView()
        alert.addButton("OK", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            self.dismiss(animated: true) {
                self.delegate?.callShowAllTodoCategory()
            }
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess("", subTitle: message)
    }
    
    func callAddCategoryAPI(isEdit: Bool) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        if isEdit {
            params = ["categoryName": txtCategoryName.text ?? "",
                      "categoryId": catId
            ]
        } else {
            params = ["categoryName": txtCategoryName.text ?? ""]
        }
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + ADD_CATEGORY, param: params, header: headers) { respnse, error in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let Message = res.value(forKey: "message") as? String {
                            self.addCustomAlert(message: Message)
                        }
                    } else {
                        if let Message = res.value(forKey: "message") as? String {
                            self.addCustomAlert(message: Message)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnAddCategoryClick(_ sender: UIButton) {
        if setValidation() {
            if isEdit {
                callAddCategoryAPI(isEdit: true)
            } else {
                callAddCategoryAPI(isEdit: false)
            }
        }
    }
}

extension AddCategoryVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtCategoryName.resignFirstResponder()
    }
}
