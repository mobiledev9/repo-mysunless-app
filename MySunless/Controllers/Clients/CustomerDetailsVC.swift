//
//  CustomerDetailsVC.swift
//  MySunless
//
//  Created by iMac on 30/11/21.
//

import UIKit
import Alamofire
import Kingfisher

class CustomerDetailsVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet var vw_profileImg: UIView!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var vw_firstName: UIView!
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var vw_lastName: UIView!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var vw_phoneNumber: UIView!
    @IBOutlet var txtPhoneNumber: UITextField!
    @IBOutlet var vw_email: UIView!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var vw_streetAddress: UIView!
    @IBOutlet var txtStreetAddress: UITextField!
    @IBOutlet var vw_country: UIView!
    @IBOutlet var txtCountry: UITextField!
    @IBOutlet var vw_state: UIView!
    @IBOutlet var txtState: UITextField!
    @IBOutlet var vw_city: UIView!
    @IBOutlet var txtCity: UITextField!
    @IBOutlet var vw_zipcode: UIView!
    @IBOutlet var txtZipcode: UITextField!
    
    //MARK:- Variable Declarations
    let imagePicker = UIImagePickerController()
    var token = String()
    var model = ClientList(dict: [:])
    var isForEdit = false
    var isFromClientDetail = false
    var selectedClientDetailID = Int()
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDesign()
        self.hideKeyboardWhenTappedAround()
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtPhoneNumber.delegate = self
        txtEmail.delegate = self
        txtStreetAddress.delegate = self
        txtCountry.delegate = self
        txtState.delegate = self
        txtCity.delegate = self
        txtZipcode.delegate = self
        
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isForEdit {
            let imgUrl = URL(string: model.ProfileImg)
            imgProfile.kf.setImage(with: imgUrl)
            txtFirstName.text = model.firstName
            txtLastName.text = model.lastName
            txtPhoneNumber.text = model.phone
            txtEmail.text = model.email
            txtStreetAddress.text = model.address
            txtCountry.text = model.country
            txtState.text = model.state
            txtCity.text = model.city
            txtZipcode.text = model.zip
        } else if isFromClientDetail {
            callViewClientInfoAPI(id: selectedClientDetailID)
        }
    }
    
    //MARK:- UserDefined Functions
    func createDesign() {
        vw_profileImg.layer.borderWidth = 0.5
        vw_profileImg.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_firstName.layer.borderWidth = 0.5
        vw_firstName.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_lastName.layer.borderWidth = 0.5
        vw_lastName.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_phoneNumber.layer.borderWidth = 0.5
        vw_phoneNumber.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_email.layer.borderWidth = 0.5
        vw_email.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_streetAddress.layer.borderWidth = 0.5
        vw_streetAddress.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_country.layer.borderWidth = 0.5
        vw_country.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_state.layer.borderWidth = 0.5
        vw_state.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_city.layer.borderWidth = 0.5
        vw_city.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_zipcode.layer.borderWidth = 0.5
        vw_zipcode.layer.borderColor = UIColor.init("#15B0DA").cgColor
        imgProfile.layer.cornerRadius = 12
    }
    
    func validation() -> Bool {
        if txtFirstName.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Firstname", viewController: self)
        } else if txtLastName.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Lastname", viewController: self)
        } else if txtPhoneNumber.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter PhoneNumber", viewController: self)
        } else if txtEmail.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Email", viewController: self)
        } else if txtStreetAddress.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter StreetAddress", viewController: self)
        } else if txtState.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter State", viewController: self)
        } else if txtCity.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter City", viewController: self)
        } else if txtZipcode.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Zipcode", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func callSaveCustomerAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization":token]
        var params = NSDictionary()
        if isForEdit {
            params = ["edituserid" : model.id,
                      "firstname" : txtFirstName.text ?? "",
                      "lastname" : txtLastName.text ?? "",
                      "phone" : txtPhoneNumber.text ?? "",
                      "email" : txtEmail.text ?? "",
                      "address" : txtStreetAddress.text ?? "",
                      "zip" : txtZipcode.text ?? "",
                      "city" : txtCity.text ?? "",
                      "state" : txtState.text ?? "",
                      "country" : txtCountry.text ?? ""
            ]
        } else if isFromClientDetail {
            params = ["edituserid" : selectedClientDetailID,
                      "firstname" : txtFirstName.text ?? "",
                      "lastname" : txtLastName.text ?? "",
                      "phone" : txtPhoneNumber.text ?? "",
                      "email" : txtEmail.text ?? "",
                      "address" : txtStreetAddress.text ?? "",
                      "zip" : txtZipcode.text ?? "",
                      "city" : txtCity.text ?? "",
                      "state" : txtState.text ?? "",
                      "country" : txtCountry.text ?? ""
            ]
        } else {
            params = ["firstname" : txtFirstName.text ?? "",
                      "lastname" : txtLastName.text ?? "",
                      "phone" : txtPhoneNumber.text ?? "",
                      "email" : txtEmail.text ?? "",
                      "address" : txtStreetAddress.text ?? "",
                      "zip" : txtZipcode.text ?? "",
                      "city" : txtCity.text ?? "",
                      "state" : txtState.text ?? "",
                      "country" : txtCountry.text ?? ""
            ]
        }
        let clientImg: UIImage = imgProfile.image ?? UIImage()
        let imageData = clientImg.pngData()
        APIUtilities.sharedInstance.UuuploadImage(url: BASE_URL + SAVE_CLIENT, keyName: "clientimage", imageData: imageData, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if (success == "1") {
                        if let message = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                        }
                    } else {
                        if let message = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                        }
                    }
                }
            }
        }
    }
    
    func callViewClientInfoAPI(id: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["clientid": id]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + ALL_CLIENTS, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? NSDictionary {
                            if let profileimg = response.value(forKey: "ProfileImg") as? String {
                                if let imgUrl = URL(string: profileimg) {
                                    self.imgProfile.kf.setImage(with: imgUrl)
                                }
                            }
                            if let fname = response.value(forKey: "FirstName") as? String {
                                self.txtFirstName.text = fname
                            }
                            if let lname = response.value(forKey: "LastName") as? String {
                                self.txtLastName.text = lname
                            }
                            if let phone = response.value(forKey: "Phone") as? String {
                                self.txtPhoneNumber.text = phone
                            }
                            if let email = response.value(forKey: "email") as? String {
                                self.txtEmail.text = email
                            }
                            if let address = response.value(forKey: "Address") as? String {
                                self.txtStreetAddress.text = address
                            }
                            if let city = response.value(forKey: "City") as? String {
                                self.txtCity.text = city
                            }
                            if let state = response.value(forKey: "State") as? String {
                                self.txtState.text = state
                            }
                            if let country = response.value(forKey: "Country") as? String {
                                self.txtCountry.text = country
                            }
                            if let zip = response.value(forKey: "Zip") as? String {
                                self.txtZipcode.text = zip
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK:- Actions
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSelectImgClick(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnSaveCustomerClick(_ sender: UIButton) {
        if (self.validation()) {
            if AppData.sharedInstance.isValidEmailAddress(emailAddressString: txtEmail.text ?? "") {
                if txtZipcode.text!.count >= 5 {
                    callSaveCustomerAPI()
                } else {
                    AppData.sharedInstance.showAlert(title: "", message: "Please enter 5 digits in Zipcode", viewController: self)
                }
            } else {
                AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter valid email address", viewController: self)
            }
            
        }
        
    }
    
}

//MARK:- ImagePickerController Delegate Methods
extension CustomerDetailsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgProfile.contentMode = .scaleAspectFill
            imgProfile.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
}

//MARK:- TextField delegate Methods
extension CustomerDetailsVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtFirstName.resignFirstResponder()
        txtLastName.resignFirstResponder()
        txtPhoneNumber.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtStreetAddress.resignFirstResponder()
        txtCountry.resignFirstResponder()
        txtState.resignFirstResponder()
        txtCity.resignFirstResponder()
        txtZipcode.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
            case txtPhoneNumber:
                let text = txtPhoneNumber.text
                txtPhoneNumber.text = text?.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
                return AppData.sharedInstance.textLimitForPhone(existingText: txtPhoneNumber.text, newText: string, limit: 14)
            default:
                return true
        }
    }
}
