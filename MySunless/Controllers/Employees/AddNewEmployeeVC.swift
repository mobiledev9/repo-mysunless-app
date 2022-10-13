//
//  AddNewEmployeeVC.swift
//  MySunless
//
//  Created by iMac on 04/12/21.
//

import UIKit
import Alamofire

class AddNewEmployeeVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var btnPersonalInfo: UIButton!
    @IBOutlet var vw_personalInfo: UIView!
    @IBOutlet var vw_userName: UIView!
    @IBOutlet var txtUsername: UITextField!
    @IBOutlet var btnRefreshUsername: UIButton!
    @IBOutlet var vw_firstName: UIView!
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var vw_lastName: UIView!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var vw_email: UIView!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var vw_password: UIView!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var vw_phoneNumber: UIView!
    @IBOutlet var txtPhoneNumber: UITextField!
    @IBOutlet var btnAvatar: UIButton!
    @IBOutlet var vw_avatar: UIView!
    @IBOutlet var imgAvatar: UIImageView!
    @IBOutlet var btnSelectAvatarImg: UIButton!
    
    //MARK:- Variable Declarations
    var token = String()
    let imagePicker = UIImagePickerController()
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDesign()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        txtUsername.text = UserDefaults.standard.value(forKey: "username") as? String ?? ""
        txtPassword.text = UserDefaults.standard.value(forKey: "userPassword") as? String ?? ""
        
        txtUsername.delegate = self
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtPhoneNumber.delegate = self
        
        self.hideKeyboardWhenTappedAround()
    }
    
    //MARK:- UserDefined Functions
    func createDesign() {
        vw_personalInfo.layer.cornerRadius = 12
        vw_personalInfo.layer.masksToBounds = true
        vw_personalInfo.backgroundColor = UIColor.white
        vw_personalInfo.layer.shadowColor = UIColor.lightGray.cgColor
        vw_personalInfo.layer.shadowOpacity = 0.1
        vw_personalInfo.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        vw_personalInfo.layer.shadowRadius = 6.0
        vw_personalInfo.layer.masksToBounds = false
        
        vw_avatar.layer.cornerRadius = 12
        vw_avatar.layer.masksToBounds = true
        vw_avatar.backgroundColor = UIColor.white
        vw_avatar.layer.shadowColor = UIColor.lightGray.cgColor
        vw_avatar.layer.shadowOpacity = 0.1
        vw_avatar.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        vw_avatar.layer.shadowRadius = 6.0
        vw_avatar.layer.masksToBounds = false
        
        btnPersonalInfo.layer.borderWidth = 1
        btnPersonalInfo.layer.borderColor = UIColor.init("#15B0DA").cgColor
        btnAvatar.layer.borderWidth = 1
        btnAvatar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        imgAvatar.layer.cornerRadius = 12
        
        vw_userName.layer.borderWidth = 0.5
        vw_userName.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_firstName.layer.borderWidth = 0.5
        vw_firstName.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_lastName.layer.borderWidth = 0.5
        vw_lastName.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_email.layer.borderWidth = 0.5
        vw_email.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_password.layer.borderWidth = 0.5
        vw_password.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_phoneNumber.layer.borderWidth = 0.5
        vw_phoneNumber.layer.borderColor = UIColor.init("15B0DA").cgColor
        
        btnRefreshUsername.roundCorners(corners: [.topRight, .bottomRight], radius: 8.0)
    }
    

    func validation() -> Bool {
        if txtUsername.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Username", viewController: self)
        } else if txtFirstName.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Firstname", viewController: self)
        } else if txtLastName.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Lastname", viewController: self)
        } else if txtEmail.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Email", viewController: self)
        } else if txtPassword.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Password", viewController: self)
        } else if txtPhoneNumber.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Phonenumber", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func refreshUsernameValidation() -> Bool {
        if txtFirstName.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Firstname", viewController: self)
        } else if txtLastName.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Lastname", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func callSetUsernameAPI() {
        AppData.sharedInstance.showLoader()
        var params = NSDictionary()
        params = [
            "firstname" : txtFirstName.text ?? "",
            "lastname" : txtLastName.text ?? ""
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
    
    func callSaveEmployeeAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization":token]
        var params = NSDictionary()
        params = ["username" : txtUsername.text ?? "",
                  "firstname" : txtFirstName.text ?? "",
                  "lastname" : txtLastName.text ?? "",
                  "email" : txtEmail.text ?? "",
                  "password" : txtPassword.text ?? "",
                  "phone" : txtPhoneNumber.text ?? ""
        ]
        
        let profileImg: UIImage = imgAvatar.image ?? UIImage()
        let imageData = profileImg.pngData()
        
        APIUtilities.sharedInstance.UuuploadImage(url: BASE_URL + SAVE_EMPLOYEE, keyName: "profileimg", imageData: imageData, param: params, header: headers) { (response, error) in
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
    
    //MARK:- Actions
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPersonalInfoClick(_ sender: UIButton) {
    }
    
    @IBAction func btnUsernameClick(_ sender: UIButton) {
        if (self.refreshUsernameValidation()) {
            callSetUsernameAPI()
        }
    }
    
    @IBAction func btnAvatarClick(_ sender: UIButton) {
    }
    
    @IBAction func btnAvatarImgClick(_ sender: UIButton) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
//    @IBAction func btnUploadImgClick(_ sender: UIButton) {
//        if (self.validation()) {
//            callSaveEmployeeAPI()
//        }
//    }
    
    @IBAction func btnSubmitEmployeeClick(_ sender: UIButton) {
        if (self.validation()) {
            callSaveEmployeeAPI()
        }
    }
    
    @IBAction func btnCancelEmployeeClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK:- ImagePickerController Delegate Methods
extension AddNewEmployeeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imgAvatar.contentMode = .scaleAspectFill
            imgAvatar.image = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgAvatar.contentMode = .scaleAspectFill
            imgAvatar.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
}

//MARK:- Textfield Delegate Methods
extension AddNewEmployeeVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtUsername.resignFirstResponder()
        txtFirstName.resignFirstResponder()
        txtLastName.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        txtPhoneNumber.resignFirstResponder()
        
        return true
    }
}
