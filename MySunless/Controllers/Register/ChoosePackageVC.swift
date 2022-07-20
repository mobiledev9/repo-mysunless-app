//
//  ChoosePackageVC.swift
//  MySunless
//
//  Created by iMac on 15/10/21.
//

import UIKit
import Alamofire

struct SelectPackage {
    let name: String
    let price: String
    let validity: String
    
    init(name: String, price: String, validity: String) {
        self.name = name
        self.price = price
        self.validity = validity
    }
}

class ChoosePackageVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var vw_Main: UIView!
    @IBOutlet var vw_yearly: UIView!
    @IBOutlet var imgYearly: UIImageView!
    @IBOutlet var vw_monthly: UIView!
    @IBOutlet var imgMonthly: UIImageView!
    @IBOutlet var vw_earlyBird: UIView!
    @IBOutlet var imgEarlyBird: UIImageView!
    @IBOutlet var vw_freeTrial: UIView!
    @IBOutlet var imgFreeTrial: UIImageView!
    @IBOutlet var vw_promocode: UIView!
    @IBOutlet var txtPromocode: UITextField!
    @IBOutlet var btnYearly: UIButton!
    @IBOutlet var btnMonthly: UIButton!
    @IBOutlet var btnEarlyBird: UIButton!
    @IBOutlet var btnFreeTrial: UIButton!
    @IBOutlet var lblPromocodeHeightConstraint: NSLayoutConstraint!
    @IBOutlet var vw_promocodeHeightConstraint: NSLayoutConstraint!
    @IBOutlet var btnPreviousBottomConstraint: NSLayoutConstraint!
    @IBOutlet var btnSubmitBottomConstraint: NSLayoutConstraint!
    @IBOutlet var lblPackageName1: UILabel!
    @IBOutlet var lblPrice1: UILabel!
    @IBOutlet var lblValidityDay1: UILabel!
    @IBOutlet var lblPackageName2: UILabel!
    @IBOutlet var lblPrice2: UILabel!
    @IBOutlet var lblValidityDay2: UILabel!
    @IBOutlet var lblPackageName3: UILabel!
    @IBOutlet var lblPrice3: UILabel!
    @IBOutlet var lblValidityDay3: UILabel!
    @IBOutlet var lblPackageName4: UILabel!
    @IBOutlet var lblPrice4: UILabel!
    @IBOutlet var lblValidityDay4: UILabel!
    @IBOutlet var tblView: UITableView!
    
    //MARK:- Variable Declarations
//    var arrPackage = [ChoosePackage]()
    var arrPackage = [SelectPackage]()
    var userid = Int()
    var firstname = String()
    var lastname = String()
    var username = String()
    var user_phone_number = String()
    var user_primary_address = String()
    var user_state = String()
    var user_city = String()
    var user_zipcode = String()
    var company_name = String()
    var company_phone = String()
    var company_address = String()
    var company_state = String()
    var company_city = String()
    var company_zipcode = String()
    var company_service = String()
    var service_price = String()
    var service_duration = String()
    var instruction = String()
    var tax_rate = String()
    var package_id = Int()
    var promocode = String()
    var selectedIndex = -1
    var selectedPackage = Bool()
    var token = String()
    var totalCompAddress = String()
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        vw_Main.layer.cornerRadius = 12
        vw_Main.layer.masksToBounds = true
        vw_Main.backgroundColor = UIColor.white
        vw_Main.layer.shadowColor = UIColor.lightGray.cgColor
        vw_Main.layer.shadowOpacity = 0.8
        vw_Main.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        vw_Main.layer.shadowRadius = 6.0
        vw_Main.layer.masksToBounds = false
        vw_promocode.layer.borderWidth = 0.5
        vw_promocode.layer.borderColor = UIColor.gray.cgColor
        
        txtPromocode.delegate = self
        self.hideKeyboardWhenTappedAround()
        tblView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        getData()
     //   callShowPackageAPI()
        arrPackage = [SelectPackage(name: "Monthly subscription", price: "$19.99", validity: "30Days"), SelectPackage(name: "Free Trial", price: "$0", validity: "14Days")]
    }
    
    //MARK:- User-Defined Methods
//    func validation() -> Bool {
//        if (btnYearly.isSelected == false && btnMonthly.isSelected == false && btnEarlyBird.isSelected == false && btnFreeTrial.isSelected == false) {
//            AppData.sharedInstance.showAlert(title: "Alert", message: "Please select Package", viewController: self)
//        } else {
//            return true
//        }
//        return false
//    }
    
    func getData() {
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        userid = UserDefaults.standard.value(forKey: "userid") as? Int ?? 0
        firstname = UserDefaults.standard.value(forKey: "firstname") as? String ?? ""
        lastname = UserDefaults.standard.value(forKey: "lastname") as? String ?? ""
        username = UserDefaults.standard.value(forKey: "username") as? String ?? ""
        user_phone_number = UserDefaults.standard.value(forKey: "user_phone_number") as? String ?? ""
        user_primary_address = UserDefaults.standard.value(forKey: "user_primary_address") as? String ?? ""
        user_state = UserDefaults.standard.value(forKey: "user_state") as? String ?? ""
        user_city = UserDefaults.standard.value(forKey: "user_city") as? String ?? ""
        user_zipcode = UserDefaults.standard.value(forKey: "user_zipcode") as? String ?? ""
        company_name = UserDefaults.standard.value(forKey: "company_name") as? String ?? ""
        company_phone = UserDefaults.standard.value(forKey: "company_phone") as? String ?? ""
        company_address = UserDefaults.standard.value(forKey: "company_address") as? String ?? ""
        company_state = UserDefaults.standard.value(forKey: "company_state") as? String ?? ""
        company_city = UserDefaults.standard.value(forKey: "company_city") as? String ?? ""
        company_zipcode = UserDefaults.standard.value(forKey: "company_zipcode") as? String ?? ""
        company_service = UserDefaults.standard.value(forKey: "company_service") as? String ?? ""
        service_price = UserDefaults.standard.value(forKey: "service_price") as? String ?? ""
        service_duration = UserDefaults.standard.value(forKey: "service_duration") as? String ?? ""
        instruction = UserDefaults.standard.value(forKey: "instruction") as? String ?? ""
        tax_rate = UserDefaults.standard.value(forKey: "tax_rate") as? String ?? ""
        
      //  package_id = UserDefaults.standard.value(forKey: "package_id") as? Int ?? 0
        promocode = UserDefaults.standard.value(forKey: "promocode") as? String ?? ""
    }
    
  /*  func callShowPackageAPI() {
        AppData.sharedInstance.showLoader()
        var params = NSDictionary()
        params = [:]
        let headers: HTTPHeaders = ["Authorization": token]
        APIUtilities.sharedInstance.PpOSTArrayAPICallWith(url: BASE_URL + CHOOSE_PACKAGE, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? [[String:Any]] {
                self.arrPackage.removeAll()
                
                for dict in res {
                    self.arrPackage.append(ChoosePackage(dict: dict))
                }
                
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
        }
    }       */
    
    func callRegisterAPI() {
        AppData.sharedInstance.showLoader()
        var params = NSDictionary()
        params = [
            "userid" : userid,
            "firstname" : firstname,
            "lastname" : lastname,
            "username" : username,
            "user_phone_number" : user_phone_number,
            "user_primary_address" : user_primary_address,
            "user_state" : user_state,
            "user_city" : user_city,
            "user_zipcode" : user_zipcode,
            "company_name" : company_name,
            "company_phone" : company_phone,
            "company_address" : company_address,
            "company_state" : company_state,
            "company_city" : company_city,
            "company_zipcode" : company_zipcode,
            "company_service" : company_service,
            "service_price" : service_price,
            "service_duration" : service_duration,
            "instruction" : instruction,
            "tax_rate" : tax_rate,
            "package_id" : package_id,
            "promocode" : promocode
        ]
        
        let imageData1 = UserDefaults.standard.data(forKey: "userimage")
        let imageData2 = UserDefaults.standard.data(forKey: "company_logo")
        APIUtilities.sharedInstance.uploadTwoImages(url: BASE_URL + STORE_USER, keyName1: "userimage", keyName2: "company_logo", imageData1: imageData1, imageData2: imageData2, param: params, header: [:]) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if (success == 1) {
                        UserDefaults.standard.set(true, forKey: "setUser")
                        self.totalCompAddress = self.company_address + "," + self.company_city + "," + self.company_zipcode + "," + self.company_state + ",United States"
                        UserDefaults.standard.set(self.totalCompAddress, forKey: "companyAddress")
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.alert(message: message, viewController: self) { (alert) in
                                let VC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                                self.navigationController?.pushViewController(VC, animated: true)
                            }
                        }
                    } else if (success == 2) {
                        UserDefaults.standard.set(true, forKey: "setUser")
                        self.totalCompAddress = self.company_address + "," + self.company_city + "," + self.company_zipcode + "," + self.company_state + ",United States"
                        UserDefaults.standard.set(self.totalCompAddress, forKey: "companyAddress")
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.alert(message: message, viewController: self) { (alert) in
                                let VC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                                self.navigationController?.pushViewController(VC, animated: true)
                            }
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
    
    //MARK:- Actions
  /*  @IBAction func btnRadioClick(_ sender: UIButton) {
        if sender.tag == 0 {
            imgYearly.image = UIImage(named: "radio-on-button")
            imgMonthly.image = UIImage(named: "radio-off-button")
            imgEarlyBird.image = UIImage(named: "radio-off-button")
            imgFreeTrial.image = UIImage(named: "radio-off-button")
            
            vw_yearly.layer.backgroundColor = UIColor.init("#15B0DA").cgColor
            vw_monthly.layer.backgroundColor = UIColor.white.cgColor
            vw_earlyBird.layer.backgroundColor = UIColor.white.cgColor
            vw_freeTrial.layer.backgroundColor = UIColor.white.cgColor
            
            btnYearly.isSelected = true
            
            lblPromocodeHeightConstraint.constant = 21
            vw_promocodeHeightConstraint.constant = 42
            btnPreviousBottomConstraint.constant = 25
            btnSubmitBottomConstraint.constant = 25
            
            package_id = self.model[sender.tag].id
            UserDefaults.standard.setValue(package_id, forKey: "package_id")
        } else if sender.tag == 1 {
            imgYearly.image = UIImage(named: "radio-off-button")
            imgMonthly.image = UIImage(named: "radio-on-button")
            imgEarlyBird.image = UIImage(named: "radio-off-button")
            imgFreeTrial.image = UIImage(named: "radio-off-button")
            
            vw_monthly.layer.backgroundColor = UIColor.init("#15B0DA").cgColor
            vw_yearly.layer.backgroundColor = UIColor.white.cgColor
            vw_earlyBird.layer.backgroundColor = UIColor.white.cgColor
            vw_freeTrial.layer.backgroundColor = UIColor.white.cgColor
            
            btnMonthly.isSelected = true
            
            lblPromocodeHeightConstraint.constant = 21
            vw_promocodeHeightConstraint.constant = 42
            btnPreviousBottomConstraint.constant = 25
            btnSubmitBottomConstraint.constant = 25
            
            package_id = self.model[sender.tag].id
            UserDefaults.standard.setValue(package_id, forKey: "package_id")
        } else if sender.tag == 2 {
            imgYearly.image = UIImage(named: "radio-off-button")
            imgMonthly.image = UIImage(named: "radio-off-button")
            imgEarlyBird.image = UIImage(named: "radio-on-button")
            imgFreeTrial.image = UIImage(named: "radio-off-button")
            
            vw_earlyBird.layer.backgroundColor = UIColor.init("#15B0DA").cgColor
            vw_monthly.layer.backgroundColor = UIColor.white.cgColor
            vw_yearly.layer.backgroundColor = UIColor.white.cgColor
            vw_freeTrial.layer.backgroundColor = UIColor.white.cgColor
            
            btnEarlyBird.isSelected = true
            
            lblPromocodeHeightConstraint.constant = 21
            vw_promocodeHeightConstraint.constant = 42
            btnPreviousBottomConstraint.constant = 25
            btnSubmitBottomConstraint.constant = 25
            
            package_id = self.model[sender.tag].id
            UserDefaults.standard.setValue(package_id, forKey: "package_id")
        } else if sender.tag == 3 {
            imgYearly.image = UIImage(named: "radio-off-button")
            imgMonthly.image = UIImage(named: "radio-off-button")
            imgEarlyBird.image = UIImage(named: "radio-off-button")
            imgFreeTrial.image = UIImage(named: "radio-on-button")
            
            vw_freeTrial.layer.backgroundColor = UIColor.init("#15B0DA").cgColor
            vw_monthly.layer.backgroundColor = UIColor.white.cgColor
            vw_earlyBird.layer.backgroundColor = UIColor.white.cgColor
            vw_yearly.layer.backgroundColor = UIColor.white.cgColor
            
            btnFreeTrial.isSelected = true
            
            lblPromocodeHeightConstraint.constant = 0
            vw_promocodeHeightConstraint.constant = 0
            btnPreviousBottomConstraint.constant = 63
            btnSubmitBottomConstraint.constant = 63
            
            package_id = self.model[sender.tag].id
            UserDefaults.standard.setValue(package_id, forKey: "package_id")
        }
    }     */
    
    @IBAction func btnPreviousClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmitClick(_ sender: UIButton) {
        getData()
        
      //  if selectedPackage == true {
            callRegisterAPI()
//        } else if selectedPackage == false {
//            AppData.sharedInstance.showAlert(title: "Alert", message: "Please select Package", viewController: self)
//        }
    }
    
    @objc func btnRadioClicckk(_ sender: UIButton) {
        let btnRadio = sender
        selectedIndex = sender.tag
        tblView.reloadData()
        btnRadio.setImage(UIImage(named: btnRadio.isSelected ? "radio-on-button.png" : "radio-off-button.png"), for: .normal)
      //  package_id = self.arrPackage[sender.tag].id
        UserDefaults.standard.setValue(package_id, forKey: "package_id")
        print(package_id)
        
        if arrPackage[sender.tag].name == "Free Trial" {
            lblPromocodeHeightConstraint.constant = 0
            vw_promocodeHeightConstraint.constant = 0
            btnPreviousBottomConstraint.constant = 63
            btnSubmitBottomConstraint.constant = 63
        } else {
            lblPromocodeHeightConstraint.constant = 21
            vw_promocodeHeightConstraint.constant = 42
            btnPreviousBottomConstraint.constant = 25
            btnSubmitBottomConstraint.constant = 25
        }
        
        if btnRadio.isSelected {
            selectedPackage = true
        } else {
            selectedPackage = false
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
}

//MARK:- TableView Datasource Methods
extension ChoosePackageVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPackage.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "ChoosePackageCell", for: indexPath) as! ChoosePackageCell
        
        let dict = arrPackage[indexPath.row]
//        cell.lblPackageName.text = dict.PackageName
//        cell.lblPrice.text = "$\(dict.Price)"
//        cell.lblValidityDay.text = "\(dict.ValidityDay)Days"
        
        cell.lblPackageName.text = dict.name
        cell.lblPrice.text = dict.price
        cell.lblValidityDay.text = dict.validity
        
        cell.btnRadio.tag = indexPath.row
        cell.btnRadio.addTarget(self, action: #selector(btnRadioClicckk(_:)), for: .touchUpInside)
        
        if indexPath.row == selectedIndex {
            cell.btnRadio.isSelected = true
        } else {
            cell.btnRadio.isSelected = false
        }
        
        cell.btnRadio.setImage(UIImage(named: cell.btnRadio.isSelected ? "radio-on-button.png" : "radio-off-button.png"), for: .normal)
        cell.cellView.backgroundColor = cell.btnRadio.isSelected ? UIColor.init("#15B0DA") : UIColor.white
        
//        if cell.btnRadio.isSelected == true {
//            selectedPackage = true
//        } else if cell.btnRadio.isSelected == false {
//            selectedPackage = false
//        }
        
        return cell
    }
}

//MARK:- TableView Delegate Methods
extension ChoosePackageVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//MARK:- Textfield Delegate Methods
extension ChoosePackageVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtPromocode.resignFirstResponder()
        return true
    }
}
