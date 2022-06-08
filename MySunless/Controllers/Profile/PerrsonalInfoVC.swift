//
//  PerrsonalInfoVC.swift
//  MySunless
//
//  Created by Daydream Soft on 08/06/22.
//

import UIKit
import Alamofire

class PerrsonalInfoVC: UIViewController {
    
    @IBOutlet var vw_username: UIView!
    @IBOutlet var txtUsername: UITextField!
    @IBOutlet var btnRefreshClick: UIButton!
    @IBOutlet var vw_firstname: UIView!
    @IBOutlet var txtFirstname: UITextField!
    @IBOutlet var vw_lastname: UIView!
    @IBOutlet var txtLastname: UITextField!
    @IBOutlet var vw_email: UIView!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var vw_phonenumber: UIView!
    @IBOutlet var txtPhonenumber: UITextField!
    @IBOutlet var vw_streetAddress: UIView!
    @IBOutlet var txtStreetAddress: UITextField!
    @IBOutlet var vw_secondaryAddress: UIView!
    @IBOutlet var txtVwSecondaryAddress: UITextView!
    @IBOutlet var vw_zipcode: UIView!
    @IBOutlet var txtZipcode: UITextField!
    @IBOutlet var vw_country: UIView!
    @IBOutlet var txtCountry: UITextField!
    @IBOutlet var vw_state: UIView!
    @IBOutlet var txtState: UITextField!
    @IBOutlet var btnState: UIButton!
    @IBOutlet var vw_stateDropdown: UIView!
    @IBOutlet var tblVwState: UITableView!
    @IBOutlet var vw_city: UIView!
    @IBOutlet var txtCity: UITextField!
    @IBOutlet var lblStreetAddress: UILabel!
    @IBOutlet var lblCity: UILabel!
    @IBOutlet var imgStateDropdown: UIImageView!
    
    var arrState = [String]()
    var token = String()
    var usertype = String()
    var stateDropdownOpen = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        arrState = stateList
        
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        usertype = UserDefaults.standard.value(forKey: "usertype") as? String ?? ""
        
        hideKeyboardWhenTappedAround()
        callGetProfileAPI()
        getUserNameFieldStatus()
    }
    
    func setInitially() {
        vw_username.layer.borderWidth = 0.5
        vw_username.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_firstname.layer.borderWidth = 0.5
        vw_firstname.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_lastname.layer.borderWidth = 0.5
        vw_lastname.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_email.layer.borderWidth = 0.5
        vw_email.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_phonenumber.layer.borderWidth = 0.5
        vw_phonenumber.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_streetAddress.layer.borderWidth = 0.5
        vw_streetAddress.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_secondaryAddress.layer.borderWidth = 0.5
        vw_secondaryAddress.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_zipcode.layer.borderWidth = 0.5
        vw_zipcode.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_country.layer.borderWidth = 0.5
        vw_country.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_state.layer.borderWidth = 0.5
        vw_state.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_city.layer.borderWidth = 0.5
        vw_city.layer.borderColor = UIColor.init("15B0DA").cgColor
        
        vw_stateDropdown.layer.borderWidth = 0.5
        vw_stateDropdown.layer.borderColor = UIColor.init("15B0DA").cgColor
        
        tblVwState.delegate = self
        tblVwState.dataSource = self
      //  searchBar.delegate = self
        
        txtFirstname.delegate = self
        txtLastname.delegate = self
        txtEmail.delegate = self
        txtStreetAddress.delegate = self
        txtCity.delegate = self
        
        vw_stateDropdown.isHidden = true
        
        btnRefreshClick.roundCorners(corners: [.topRight, .bottomRight], radius: 8.0)
    }
    
    func getUserNameFieldStatus() {
        switch usertype {
            case "Admin" :
                //read-only
                vw_username.backgroundColor = UIColor.init("#F3F5F6")
                btnRefreshClick.backgroundColor = UIColor.init("#93D9ED")
                txtUsername.isUserInteractionEnabled = false
            case "subscriber" :
                vw_username.backgroundColor = UIColor.white
                btnRefreshClick.backgroundColor = UIColor.init("#15B0DA")
                vw_username.bringSubviewToFront(btnRefreshClick)
                txtUsername.isUserInteractionEnabled = true
            default :
                print("UserType is nil")
        }
    }
    
    func callSetUsernameAPI() {
        AppData.sharedInstance.showLoader()
        var params = NSDictionary()
        params = [
            "firstname" : txtFirstname.text ?? "",
            "lastname" : txtLastname.text ?? ""
        ]
        
        APIUtilities.sharedInstance.POSTAPICallWith(url: BASE_URL + SET_USERNAME, param: params) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if (success == 1) {
                        if let userName = res.value(forKey: "username") as? String {
                            //  print(userName)
                            self.txtUsername.text = userName
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
    
    func PersonalInfoValidation() -> Bool {
        if txtFirstname.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Firstname", viewController: self)
        } else if txtLastname.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Lastname", viewController: self)
        } else if txtEmail.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Email", viewController: self)
        } else if txtPhonenumber.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Phonenumber", viewController: self)
        } else if txtStreetAddress.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Street Address", viewController: self)
        } else if txtZipcode.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Zipcode", viewController: self)
        } else if txtCountry.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Country", viewController: self)
        } else if txtState.text == "" || txtState.placeholder == "Select a State" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please select State", viewController: self)
        } else if txtCity.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter City", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func refreshUsernameValidation() -> Bool {
        if txtFirstname.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Firstname", viewController: self)
        } else if txtLastname.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Lastname", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func callGetProfileAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization":token]
        
        APIUtilities.sharedInstance.GetDictAPICallWith(url: BASE_URL + USER_PROFILE, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            if let res = response as? NSDictionary {
                if let username = res.value(forKey: "username") as? String {
                    self.txtUsername.text = username
                }
                if let firstname = res.value(forKey: "firstname") as? String {
                    self.txtFirstname.text = firstname
                }
                if let lastname = res.value(forKey: "lastname") as? String {
                    self.txtLastname.text = lastname
                }
                if let email = res.value(forKey: "email") as? String {
                    self.txtEmail.text = email
                }
                if let phonenumber = res.value(forKey: "phonenumber") as? String {
                    self.txtPhonenumber.text = phonenumber
                }
                if let primaryaddress = res.value(forKey: "primaryaddress") as? String {
                    self.txtStreetAddress.text = primaryaddress
                }
                if let secondaryaddress = res.value(forKey: "secondaryaddress") as? String {
                    self.txtVwSecondaryAddress.text = secondaryaddress
                }
                if let zipcode = res.value(forKey: "zipcode") as? String {
                    self.txtZipcode.text = zipcode
                }
                if let country = res.value(forKey: "country") as? String {
                    self.txtCountry.text = country
                }
                if let state = res.value(forKey: "state") as? String {
                    self.txtState.text = state
                }
                if let city = res.value(forKey: "city") as? String {
                    self.txtCity.text = city
                }
//                if let company = res.value(forKey: "company") as? NSDictionary {
//                    print(company)
//                }
            }
        }
    }
    
    func callUpdateProfileAPI() {
        AppData.sharedInstance.showLoader()
        var params = NSDictionary()
        params = [
            "firstname" : txtFirstname.text ?? "",
            "lastname" : txtLastname.text ?? "",
            "username" : txtUsername.text ?? "",
            "phone_number" : txtPhonenumber.text ?? "",
            "primary_address" : txtStreetAddress.text ?? "",
            "secondary_address" : txtVwSecondaryAddress.text ?? "",
            "state" : txtState.text ?? "",
            "city" : txtCity.text ?? "",
            "zipcode" : txtZipcode.text ?? ""
        ]
        
        let headers: HTTPHeaders = ["Authorization":token]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + UPDATE_PROFILE, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let result = res.value(forKey: "result") as? Int {
                    if (result == 1) {
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
    
    @IBAction func btnRefreshUsernameClick(_ sender: UIButton) {
        if (self.refreshUsernameValidation()) {
            callSetUsernameAPI()
        }
    }
    
    @IBAction func btnSameAsPrimaryAddress(_ sender: UIButton) {
        txtVwSecondaryAddress.text = txtStreetAddress.text
    }
    
    @IBAction func btnStateClick(_ sender: UIButton) {
        if (stateDropdownOpen == true) {
            self.vw_stateDropdown.isHidden = false
            imgStateDropdown.image = UIImage(named: "up-arrow")
            
            lblCity.isHidden = true
            vw_city.isHidden = true
            
            stateDropdownOpen = false
        } else {
            self.vw_stateDropdown.isHidden = true
            imgStateDropdown.image = UIImage(named: "down-arrow-1")
            
            lblCity.isHidden = false
            vw_city.isHidden = false
            
            stateDropdownOpen = true
        }
    }
    
    @IBAction func btnUpdateProfileClick(_ sender: UIButton) {
        if PersonalInfoValidation() {
            callUpdateProfileAPI()
        }
    }

}

extension PerrsonalInfoVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrState.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tblVwState.dequeueReusableCell(withIdentifier: "CompanyTypeCell", for: indexPath) as! CompanyTypeCell
            cell.lblTitle.text = arrState[indexPath.row]
            return cell
    }
}

extension PerrsonalInfoVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let cell = tblVwState.cellForRow(at: indexPath) as! CompanyTypeCell
            txtState.text = cell.lblTitle.text
    }
}

//MARK:- Textfield Delegate Methods
extension PerrsonalInfoVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtFirstname.resignFirstResponder()
        txtLastname.resignFirstResponder()
        txtEmail.resignFirstResponder()
      //  txtPhonenumber.resignFirstResponder()
//        txtCompanyName.resignFirstResponder()
//        txtCompanyWebsite.resignFirstResponder()
        txtStreetAddress.resignFirstResponder()
      //  txtZipcode.resignFirstResponder()
        txtCity.resignFirstResponder()
        
        return true
    }
}

extension PerrsonalInfoVC: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        self.txtVwSecondaryAddress.endEditing(true)
        txtVwSecondaryAddress.resignFirstResponder()
    }
}
