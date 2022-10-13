//
//  AddPackagesVC.swift
//  MySunless
//
//  Created by iMac on 10/01/22.
//

import UIKit
import Alamofire
import iOSDropDown

class AddPackagesVC: UIViewController {
    @IBOutlet var vw_Name: UIView!
    @IBOutlet var txtName: UITextField!
    @IBOutlet var vw_Price: UIView!
    @IBOutlet var txtPrice: UITextField!
    @IBOutlet var vw_ExpireDate: UIView!
    @IBOutlet var txtExpireDate: UITextField!
    @IBOutlet var vw_Service: UIView!
    @IBOutlet var txtService:UITextField!
    @IBOutlet var vw_Visits: UIView!
    @IBOutlet var txtVisits: UITextField!
    @IBOutlet var vw_Description: UIView!
    @IBOutlet var txtVwDescription: UITextView!
    @IBOutlet var btnNoExpiration: UIButton!
    @IBOutlet var imgNoExpiration: UIImageView!
    @IBOutlet var btnUnlimited: UIButton!
    @IBOutlet var imgUnlimited: UIImageView!
    
    var token = String()
    var isForEdit = false
    var package:ShowPackageList = ShowPackageList(dict:[:])
    var arrOfService = [SelectServiceData]()
    var arrSelectedServiceId  = [Int]()
    var datePicker = UIDatePicker()
    var isNoExpiredSelect = true
    var isUnlimitedSelect = true
    var arrServiceName = [String]()
    var arrServiceId = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        self.hideKeyboardWhenTappedAround()
        
        txtName.delegate = self
        txtPrice.delegate = self
        txtExpireDate.delegate = self
        txtVisits.delegate = self
        txtService.delegate = self
        txtVwDescription.delegate = self
        
        let screenWidth = UIScreen.main.bounds.width
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        txtExpireDate.inputView = datePicker
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(self.handleDatePicker), for: UIControl.Event.valueChanged)
        datePicker.datePickerMode = .date
        
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        callSelectServiceAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isForEdit {
            self.txtName.text = package.name
            self.txtPrice.text = String(package.price)
            self.txtExpireDate.text = package.tracking
            self.txtVwDescription.setHTMLFromString(htmlText:package.description)
            self.txtService.text = package.service
            self.txtVisits.text = package.noofvisit
        }
    }
    
    func setInitially() {
        vw_Name.layer.borderWidth = 0.5
        vw_Name.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_Price.layer.borderWidth = 0.5
        vw_Price.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_ExpireDate.layer.borderWidth = 0.5
        vw_ExpireDate.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_Service.layer.borderWidth = 0.5
        vw_Service.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_Visits.layer.borderWidth = 0.5
        vw_Visits.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_Description.layer.borderWidth = 0.5
        vw_Description.layer.borderColor = UIColor.init("15B0DA").cgColor
    }
    
    func validation() -> Bool {
        if txtName.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please Enter Name", viewController: self)
        } else if txtPrice.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please Enter Price", viewController: self)
        } else if txtExpireDate.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please Enter Package Expire Date", viewController: self)
        } else if txtService.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please Select Service", viewController: self)
        } else if txtVisits.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please Enter Number of Visits", viewController: self)
        } else if txtVwDescription.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please Enter Package Description", viewController: self)
        } else {
           return true
        }
        return false
    }
    
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmitPackageClick(_ sender: UIButton) {
        if isForEdit {
            if validation() {
                self.callEditPackageAPI()
            }
         } else {
            if validation() {
             self.callAddPackageAPI()
            }
           
        }
    }
    
    @IBAction func btnNoExpirationClick(_ sender: UIButton) {
        if isNoExpiredSelect {
            imgNoExpiration.image = UIImage(systemName: "checkmark.square")
            txtExpireDate.text = "No Expiration"
            txtExpireDate.isEnabled = false
            isNoExpiredSelect = false
        } else {
            imgNoExpiration.image = UIImage(systemName: "square")
            txtExpireDate.text = ""
            txtExpireDate.isEnabled = true
            isNoExpiredSelect = true
        }
    }
    
    @IBAction func btnUnlimitedClick(_ sender: UIButton) {
        if isUnlimitedSelect {
            imgUnlimited.image = UIImage(systemName: "checkmark.square")
            txtVisits.text = "Unlimited"
            txtVisits.isEnabled = false
            isUnlimitedSelect = false
        } else {
            imgUnlimited.image = UIImage(systemName: "square")
            txtVisits.text = ""
            txtVisits.isEnabled = true
            isUnlimitedSelect = true
        }
    }
    
    @IBAction func btnServiceTextfieldSelectClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ServicesVC") as! ServicesVC
        VC.arrOfService = self.arrOfService
        VC.arrSelectedServiceId = self.arrSelectedServiceId
        VC.delegate = self
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func callAddPackageAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        
        params =
            ["package_name"  : txtName.text ?? "",
             "package_price" : txtPrice.text ?? "",
             "package_exp_date" : txtExpireDate.text ?? "",
             "package_desc"  : txtVwDescription.text ?? "",
             "service" : self.arrServiceId.joined(separator: ","),
             "of_visits" : txtVisits.text! ,
         ]
        
        print(params)

        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + ADD_PACKAGE, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if (success == 1) {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                        }
                    } else {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                        }
                    }
                }
            }
        }
    }
    
    func callEditPackageAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params =
            ["id":package.id,
             "package_name"  : txtName.text ?? "",
             "package_price" : txtPrice.text ?? "",
             "package_exp_date" : txtExpireDate.text ?? "",
             "package_desc"  : txtVwDescription.text ?? "",
             "service" : package.service,
             "of_visits" :txtVisits.text ?? ""
            ]

        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + EDIT_PACKAGE, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if (success == 1) {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                        }
                    } else {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                        }
                    }
                }
            }
        }
    }
    
    func callSelectServiceAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = [:]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SELECT_SERVICE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrOfService.removeAll()
                            for dict in response {
                                self.arrOfService.append(SelectServiceData(dict: dict))
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                        }
                    }
                }
            }
        }
    }
    
    @objc func handleDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        txtExpireDate.text = dateFormatter.string(from: datePicker.date)
       // txtExpireDate.resignFirstResponder()
    }
}

//MARK:- Textfield Delegate Methods
extension AddPackagesVC: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        //txtName.resignFirstResponder()
//         return true
//    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        self.resignFirstResponder()
//        return false
//    }
}

//MARK:- TextView Delegate Methods
extension AddPackagesVC: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        txtVwDescription.resignFirstResponder()
    }
    

}

//MARK:- SelectServiceDelegate
extension AddPackagesVC: SelectServiceDelegate {
    func didSelectServices(selectedService: [Int]) {
        arrServiceName.removeAll()
        arrServiceId.removeAll()
        self.arrSelectedServiceId = selectedService
        for item in arrOfService {
            if arrSelectedServiceId.contains(item.id) {
                arrServiceName.append(item.serviceName)
                arrServiceId.append(String(item.id))
                
            }
        }
        txtService.endEditing(true)
        txtService.text = arrServiceName.joined(separator: ",")
    
    }
    
    
}


   
