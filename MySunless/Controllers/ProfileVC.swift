//
//  ProfileVC.swift
//  MySunless
//
//  Created by iMac on 21/10/21.
//

import UIKit
import Alamofire
import SwiftSignatureView
import Kingfisher

class ProfileVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var btnPersonalInfo: UIButton!
    @IBOutlet var vw_personalInfo: UIView!
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
    @IBOutlet var btnChangeAvatar: UIButton!
    @IBOutlet var vw_changeAvatar: UIView!
    @IBOutlet var btnSelectImageClick: UIButton!
    @IBOutlet var imgAvatar: UIImageView!
    @IBOutlet var vw_personalInfoHeightConstraint: NSLayoutConstraint!
    @IBOutlet var vw_changeAvatarHeightConstraint: NSLayoutConstraint!
    @IBOutlet var vw_currentPassword: UIView!
    @IBOutlet var txtCurrentPassword: UITextField!
    @IBOutlet var vw_newPassword: UIView!
    @IBOutlet var txtNewPassword: UITextField!
    @IBOutlet var vw_confirmNewPassword: UIView!
    @IBOutlet var txtConfirmNewPassword: UITextField!
    @IBOutlet var vw_changePassword: UIView!
    @IBOutlet var btnChangePassword: UIButton!
    @IBOutlet var vw_changePasswordHeightConstraint: NSLayoutConstraint!
    @IBOutlet var vw_mainHeightConstraint: NSLayoutConstraint!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var btnSubscription: UIButton!
    @IBOutlet var vw_subscription: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var subscriptionTblview: UITableView!
    @IBOutlet var vw_invoiceSection: UIView!
    @IBOutlet var subscriptionTblHeightConstraint: NSLayoutConstraint!
    @IBOutlet var vw_mySignature: UIView!
    @IBOutlet var signatureView: SwiftSignatureView!
    @IBOutlet var showSignatureView: UIImageView!
    @IBOutlet var btnRemoveSignature: UIButton!
    @IBOutlet var vw_myGoals: UIView!
    @IBOutlet var vw_selectClientGoal: UIView!
    @IBOutlet var txtClientGoal: UITextField!
    @IBOutlet var btnClientGoal: UIButton!
    @IBOutlet var imgClientGoalDropdown: UIImageView!
    @IBOutlet var vw_clientGoalDropdown: UIView!
    @IBOutlet var tblVwClientGoal: UITableView!
    @IBOutlet var vw_selectSalesGoal: UIView!
    @IBOutlet var txtSalesGoal: UITextField!
    @IBOutlet var btnSalesGoal: UIButton!
    @IBOutlet var imgSalesGoalDropdown: UIImageView!
    @IBOutlet var vw_salesGoalDropdown: UIView!
    @IBOutlet var tblVwSalesGoal: UITableView!
    @IBOutlet var lblSalesGoal: UILabel!
    @IBOutlet var vw_subscriptionHeightConstraint: NSLayoutConstraint!
    @IBOutlet var vw_mySignatureHeightConstraint: NSLayoutConstraint!
    @IBOutlet var vw_myGoalsHeightConstraint: NSLayoutConstraint!
    @IBOutlet var btnMySignature: UIButton!
    @IBOutlet var btnMyGoals: UIButton!
    
    //MARK:- Variable Declarations
    var arrState = [String]()
    var arrCompanyType = [String]()
    var arrClientGoal = [String]()
    var arrSalesGoal = [String]()
    var stateDropdownOpen = true
    var clientGoalDropdownOpen = true
    var salesGoalDropdownOpen = true
    var personalInfoSelected = Bool()
    var changeAvatarSelected = Bool()
    var changePasswordSelected = Bool()
    var showSubscription = Bool()
    var showSignature = Bool()
    var showMyGoals = Bool()
    let imagePicker = UIImagePickerController()
    var token = String()
    var userName = String()
    var userType = String()
    var arrSubscription = [SubscriptionList]()
    var filterdata = [SubscriptionList]()
    var searching = false
    var usertype = String()
   // var arrData = [[String:Any]]()
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vw_personalInfo.layer.cornerRadius = 12
        vw_personalInfo.layer.masksToBounds = true
        vw_personalInfo.backgroundColor = UIColor.white
        vw_personalInfo.layer.shadowColor = UIColor.lightGray.cgColor
        vw_personalInfo.layer.shadowOpacity = 0.1
        vw_personalInfo.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        vw_personalInfo.layer.shadowRadius = 6.0
        vw_personalInfo.layer.masksToBounds = false
        
        vw_changeAvatar.layer.cornerRadius = 12
        vw_changeAvatar.layer.masksToBounds = true
        vw_changeAvatar.backgroundColor = UIColor.white
        vw_changeAvatar.layer.shadowColor = UIColor.lightGray.cgColor
        vw_changeAvatar.layer.shadowOpacity = 0.1
        vw_changeAvatar.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        vw_changeAvatar.layer.shadowRadius = 6.0
        vw_changeAvatar.layer.masksToBounds = false
        
        vw_changePassword.layer.cornerRadius = 12
        vw_changePassword.layer.masksToBounds = true
        vw_changePassword.backgroundColor = UIColor.white
        vw_changePassword.layer.shadowColor = UIColor.lightGray.cgColor
        vw_changePassword.layer.shadowOpacity = 0.1
        vw_changePassword.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        vw_changePassword.layer.shadowRadius = 6.0
        vw_changePassword.layer.masksToBounds = false
        
        vw_subscription.layer.cornerRadius = 12
        vw_subscription.layer.masksToBounds = true
        vw_subscription.backgroundColor = UIColor.white
        vw_subscription.layer.shadowColor = UIColor.lightGray.cgColor
        vw_subscription.layer.shadowOpacity = 0.1
        vw_subscription.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        vw_subscription.layer.shadowRadius = 6.0
        vw_subscription.layer.masksToBounds = false
        
        vw_mySignature.layer.cornerRadius = 12
        vw_mySignature.layer.masksToBounds = true
        vw_mySignature.backgroundColor = UIColor.white
        vw_mySignature.layer.shadowColor = UIColor.lightGray.cgColor
        vw_mySignature.layer.shadowOpacity = 0.1
        vw_mySignature.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        vw_mySignature.layer.shadowRadius = 6.0
        vw_mySignature.layer.masksToBounds = false
        
        vw_myGoals.layer.cornerRadius = 12
        vw_myGoals.layer.masksToBounds = true
        vw_myGoals.backgroundColor = UIColor.white
        vw_myGoals.layer.shadowColor = UIColor.lightGray.cgColor
        vw_myGoals.layer.shadowOpacity = 0.1
        vw_myGoals.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        vw_myGoals.layer.shadowRadius = 6.0
        vw_myGoals.layer.masksToBounds = false
        
        btnPersonalInfo.layer.borderWidth = 1
        btnPersonalInfo.layer.borderColor = UIColor.init("#15B0DA").cgColor
        btnChangeAvatar.layer.borderWidth = 1
        btnChangeAvatar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        btnChangePassword.layer.borderWidth = 1
        btnChangePassword.layer.borderColor = UIColor.init("#15B0DA").cgColor
        btnSubscription.layer.borderWidth = 1
        btnSubscription.layer.borderColor = UIColor.init("#15B0DA").cgColor
        btnMySignature.layer.borderWidth = 1
        btnMySignature.layer.borderColor = UIColor.init("#15B0DA").cgColor
        btnMyGoals.layer.borderWidth = 1
        btnMyGoals.layer.borderColor = UIColor.init("#15B0DA").cgColor
        
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
        vw_currentPassword.layer.borderWidth = 0.5
        vw_currentPassword.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_newPassword.layer.borderWidth = 0.5
        vw_newPassword.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_confirmNewPassword.layer.borderWidth = 0.5
        vw_confirmNewPassword.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_selectClientGoal.layer.borderWidth = 0.5
        vw_selectClientGoal.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_selectSalesGoal.layer.borderWidth = 0.5
        vw_selectSalesGoal.layer.borderColor = UIColor.init("15B0DA").cgColor
        
        vw_stateDropdown.layer.borderWidth = 0.5
        vw_stateDropdown.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_clientGoalDropdown.layer.borderWidth = 0.5
        vw_clientGoalDropdown.layer.borderColor = UIColor.init("15B0DA").cgColor
        vw_salesGoalDropdown.layer.borderWidth = 0.5
        vw_salesGoalDropdown.layer.borderColor = UIColor.init("15B0DA").cgColor
        
        subscriptionTblview.layer.borderColor = UIColor.init("005CC8").cgColor
        subscriptionTblview.layer.borderWidth = 0.5
       // subscriptionTblview.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 8.0)
        vw_invoiceSection.layer.borderColor = UIColor.init("005CC8").cgColor
        vw_invoiceSection.layer.borderWidth = 0.5
       // vw_invoiceSection.roundCorners(corners: [.topLeft,.topRight], radius: 8.0)
        
        signatureView.layer.borderColor = UIColor.init("005CC8").cgColor
        signatureView.layer.borderWidth = 0.5
        signatureView.layer.cornerRadius = 8
        
        showSignatureView.layer.borderColor = UIColor.init("005CC8").cgColor
        showSignatureView.layer.borderWidth = 0.5
        
       // vw_mainHeightConstraint.constant = 3800
        vw_mainHeightConstraint.constant = UIScreen.main.bounds.height

        imgAvatar.layer.cornerRadius = 12
//        self.vw_personalInfoHeightConstraint.constant = 1100
//        self.vw_changeAvatarHeightConstraint.constant = 280
//        self.vw_changePasswordHeightConstraint.constant = 370
//        self.vw_subscriptionHeightConstraint.constant = 490
//        self.vw_mySignatureHeightConstraint.constant = 520
//        self.vw_myGoalsHeightConstraint.constant = 400
        
        vw_personalInfo.isHidden = true
        vw_changeAvatar.isHidden = true
        vw_changePassword.isHidden = true
        vw_subscription.isHidden = true
        vw_mySignature.isHidden = true
        vw_myGoals.isHidden = true
        
        vw_personalInfoHeightConstraint.constant = 0
        vw_changeAvatarHeightConstraint.constant = 0
        vw_changePasswordHeightConstraint.constant = 0
        vw_subscriptionHeightConstraint.constant = 0
        vw_mySignatureHeightConstraint.constant = 0
        vw_myGoalsHeightConstraint.constant = 0
        
        tblVwState.delegate = self
        tblVwState.dataSource = self
        searchBar.delegate = self
        signatureView.delegate = self
        
        txtFirstname.delegate = self
        txtLastname.delegate = self
        txtEmail.delegate = self
        txtStreetAddress.delegate = self
        txtCity.delegate = self
        
        txtCurrentPassword.delegate = self
        txtNewPassword.delegate = self
        txtConfirmNewPassword.delegate = self
        
        vw_stateDropdown.isHidden = true
        vw_clientGoalDropdown.isHidden = true
        vw_salesGoalDropdown.isHidden = true
       // vw_subscription.isHidden = true
        
        btnRefreshClick.roundCorners(corners: [.topRight, .bottomRight], radius: 8.0)
        
        arrState = stateList
        arrCompanyType = companyTypeList
        arrClientGoal = clientGoalList
        arrSalesGoal = salesGoalList
        
        subscriptionTblview.register(UINib(nibName: "SubscriptionListCell", bundle: nil), forCellReuseIdentifier: "SubscriptionListCell")
        subscriptionTblview.register(UINib(nibName: "SubscriptionDataCell", bundle: nil), forCellReuseIdentifier: "SubscriptionDataCell")
       // tblVwState.register(UINib(nibName: "DropdownCell", bundle: nil), forCellReuseIdentifier: "DropdownCell")
        
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        usertype = UserDefaults.standard.value(forKey: "usertype") as? String ?? ""
        
        self.hideKeyboardWhenTappedAround()
        callGetProfileAPI()
        getUserNameFieldStatus()
        callSubscriptionsListAPI()
        
        setHeight()
        
    }

    //MARK:- User-Defined Methods
  /*  func setViewHeight() {
        if (personalInfoSelected == true && changeAvatarSelected == true && changePasswordSelected == true) {
            self.vw_mainHeightConstraint.constant = 2800
        } else if (personalInfoSelected == false && changeAvatarSelected == false && changePasswordSelected == false) {
            self.vw_mainHeightConstraint.constant = 2800 - (1100 + 280 + 370)
        } else if (personalInfoSelected == true && changeAvatarSelected == false && changePasswordSelected == false) {
            self.vw_mainHeightConstraint.constant = 2800 - (280 + 370)
        } else if (personalInfoSelected == false && changeAvatarSelected == true && changePasswordSelected == false) {
            self.vw_mainHeightConstraint.constant = 2800 - (1100 + 370)
        } else if (personalInfoSelected == false && changeAvatarSelected == false && changePasswordSelected == true) {
            self.vw_mainHeightConstraint.constant = 2800 - (1100 + 280)
        } else if (personalInfoSelected == true && changeAvatarSelected == true && changePasswordSelected == false) {
            self.vw_mainHeightConstraint.constant = 2800 - 370
        } else if (personalInfoSelected == false && changeAvatarSelected == true && changePasswordSelected == true) {
            self.vw_mainHeightConstraint.constant = 2800 - 1100
        } else if (personalInfoSelected == true && changeAvatarSelected == false && changePasswordSelected == true) {
            self.vw_mainHeightConstraint.constant = 2800 - 280
        }
    }       */
    
    func setHeight() {
        switch usertype {
            case "Admin":
                btnSubscription.isHidden = true
                btnMySignature.isHidden = true
                btnMyGoals.isHidden = true
                
                if (personalInfoSelected == true) {
                    vw_personalInfo.isHidden = false
                    vw_changeAvatar.isHidden = true
                    vw_changePassword.isHidden = true
                    
                    vw_personalInfoHeightConstraint.constant = 1100
                    vw_changeAvatarHeightConstraint.constant = 0
                    vw_changePasswordHeightConstraint.constant = 0
                    vw_subscriptionHeightConstraint.constant = 0
                    vw_mySignatureHeightConstraint.constant = 0
                    vw_myGoalsHeightConstraint.constant = 0
                    
                    let height = 2200 - (280 + 370)
                    self.vw_mainHeightConstraint.constant = CGFloat(height)
                    
                } else if (changeAvatarSelected == true) {
                    vw_personalInfo.isHidden = true
                    vw_changeAvatar.isHidden = false
                    vw_changePassword.isHidden = true
                    
                    vw_personalInfoHeightConstraint.constant = 0
                    vw_changeAvatarHeightConstraint.constant = 280
                    vw_changePasswordHeightConstraint.constant = 0
                    vw_subscriptionHeightConstraint.constant = 0
                    vw_mySignatureHeightConstraint.constant = 0
                    vw_myGoalsHeightConstraint.constant = 0
                    
                    let height = 2200 - (1100 + 370)
                    self.vw_mainHeightConstraint.constant = CGFloat(height)
                    
                } else if (changePasswordSelected == true) {
                    vw_personalInfo.isHidden = true
                    vw_changeAvatar.isHidden = true
                    vw_changePassword.isHidden = false
                    
                    vw_personalInfoHeightConstraint.constant = 0
                    vw_changeAvatarHeightConstraint.constant = 0
                    vw_changePasswordHeightConstraint.constant = 370
                    vw_subscriptionHeightConstraint.constant = 0
                    vw_mySignatureHeightConstraint.constant = 0
                    vw_myGoalsHeightConstraint.constant = 0
                    
                    let height = 2200 - (280 + 1100)
                    self.vw_mainHeightConstraint.constant = CGFloat(height)
                    
                }
            case "subscriber":
                if (personalInfoSelected == true) {
                    vw_personalInfo.isHidden = false
                    vw_changeAvatar.isHidden = true
                    vw_changePassword.isHidden = true
                    vw_subscription.isHidden = true
                    vw_mySignature.isHidden = true
                    vw_myGoals.isHidden = true
                    
                    vw_personalInfoHeightConstraint.constant = 1100
                    vw_changeAvatarHeightConstraint.constant = 0
                    vw_changePasswordHeightConstraint.constant = 0
                    vw_subscriptionHeightConstraint.constant = 0
                    vw_mySignatureHeightConstraint.constant = 0
                    vw_myGoalsHeightConstraint.constant = 0
                    
                    let height = 3800 - (280 + 370 + 490 + 520 + 400)
                    self.vw_mainHeightConstraint.constant = CGFloat(height)
                    
                } else if (changeAvatarSelected == true) {
                    vw_personalInfo.isHidden = true
                    vw_changeAvatar.isHidden = false
                    vw_changePassword.isHidden = true
                    vw_subscription.isHidden = true
                    vw_mySignature.isHidden = true
                    vw_myGoals.isHidden = true
                    
                    vw_personalInfoHeightConstraint.constant = 0
                    vw_changeAvatarHeightConstraint.constant = 280
                    vw_changePasswordHeightConstraint.constant = 0
                    vw_subscriptionHeightConstraint.constant = 0
                    vw_mySignatureHeightConstraint.constant = 0
                    vw_myGoalsHeightConstraint.constant = 0
                    
                    let height = 3800 - (1100 + 370 + 490 + 520 + 400)
                    self.vw_mainHeightConstraint.constant = CGFloat(height)
                    
                } else if (changePasswordSelected == true) {
                    vw_personalInfo.isHidden = true
                    vw_changeAvatar.isHidden = true
                    vw_changePassword.isHidden = false
                    vw_subscription.isHidden = true
                    vw_mySignature.isHidden = true
                    vw_myGoals.isHidden = true
                    
                    vw_personalInfoHeightConstraint.constant = 0
                    vw_changeAvatarHeightConstraint.constant = 0
                    vw_changePasswordHeightConstraint.constant = 370
                    vw_subscriptionHeightConstraint.constant = 0
                    vw_mySignatureHeightConstraint.constant = 0
                    vw_myGoalsHeightConstraint.constant = 0
                    
                    let height = 3800 - (280 + 1100 + 490 + 520 + 400)
                    self.vw_mainHeightConstraint.constant = CGFloat(height)
                    
                } else if (showSubscription == true) {
                    vw_personalInfo.isHidden = true
                    vw_changeAvatar.isHidden = true
                    vw_changePassword.isHidden = true
                    vw_subscription.isHidden = false
                    vw_mySignature.isHidden = true
                    vw_myGoals.isHidden = true
                    
                    vw_personalInfoHeightConstraint.constant = 0
                    vw_changeAvatarHeightConstraint.constant = 0
                    vw_changePasswordHeightConstraint.constant = 0
                    vw_subscriptionHeightConstraint.constant = 490
                    vw_mySignatureHeightConstraint.constant = 0
                    vw_myGoalsHeightConstraint.constant = 0
                    
                    let height = 3800 - (280 + 370 + 1100 + 520 + 400)
                    self.vw_mainHeightConstraint.constant = CGFloat(height)
                    
                } else if (showSignature == true) {
                    vw_personalInfo.isHidden = true
                    vw_changeAvatar.isHidden = true
                    vw_changePassword.isHidden = true
                    vw_subscription.isHidden = true
                    vw_mySignature.isHidden = false
                    vw_myGoals.isHidden = true
                    
                    vw_personalInfoHeightConstraint.constant = 0
                    vw_changeAvatarHeightConstraint.constant = 0
                    vw_changePasswordHeightConstraint.constant = 0
                    vw_subscriptionHeightConstraint.constant = 0
                    vw_mySignatureHeightConstraint.constant = 520
                    vw_myGoalsHeightConstraint.constant = 0
                    
                    let height = 3800 - (280 + 370 + 490 + 1100 + 400)
                    self.vw_mainHeightConstraint.constant = CGFloat(height)
                    
                } else if (showMyGoals == true) {
                    vw_personalInfo.isHidden = true
                    vw_changeAvatar.isHidden = true
                    vw_changePassword.isHidden = true
                    vw_subscription.isHidden = true
                    vw_mySignature.isHidden = true
                    vw_myGoals.isHidden = false
                    
                    vw_personalInfoHeightConstraint.constant = 0
                    vw_changeAvatarHeightConstraint.constant = 0
                    vw_changePasswordHeightConstraint.constant = 0
                    vw_subscriptionHeightConstraint.constant = 0
                    vw_mySignatureHeightConstraint.constant = 0
                    vw_myGoalsHeightConstraint.constant = 400
                    
                    let height = 3800 - (280 + 370 + 490 + 520 + 1100)
                    self.vw_mainHeightConstraint.constant = CGFloat(height)
                }
            default:
                print("usertype is nil")
        }
        
    }
    
    func saveGoalsValidation() -> Bool {
        if txtClientGoal.text == "Select Client Goal" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please select Client Goal", viewController: self)
        } else if txtSalesGoal.text == "Select Sales Goal" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please select Sales Goal", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func getUserNameFieldStatus() {
        userType = UserDefaults.standard.value(forKey: "usertype") as? String ?? ""
      /*  if (userType == "Admin") {
            //read-only
            vw_username.backgroundColor = UIColor.init("#F3F5F6")
            btnRefreshClick.backgroundColor = UIColor.init("#93D9ED")
            txtUsername.isUserInteractionEnabled = false
        } else if (userType == "subscriber") {
            vw_username.backgroundColor = UIColor.white
            btnRefreshClick.backgroundColor = UIColor.init("#15B0DA")
            vw_username.bringSubviewToFront(btnRefreshClick)
            txtUsername.isUserInteractionEnabled = true
        }    */
        
        switch userType {
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
    
    func changePasswordValidation() -> Bool {
        if txtCurrentPassword.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter your current password", viewController: self)
        } else if txtNewPassword.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter new password", viewController: self)
        } else if txtConfirmNewPassword.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter confirm password", viewController: self)
        } else if txtNewPassword.text != txtConfirmNewPassword.text {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Enter confirm password same as password", viewController: self)
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
                if let user_image = res.value(forKey: "user_image") as? String {
                    let userImgUrl = URL(string: user_image)
                    self.imgAvatar.kf.setImage(with: userImgUrl)
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
    
    func callChangeAvatarAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization":token]
        let imgAvataar: UIImage = imgAvatar.image ?? UIImage()
        let imageData = imgAvataar.pngData()
        
        APIUtilities.sharedInstance.UuuploadImage(url: BASE_URL + USER_AVATAR, keyName: "profileimage", imageData: imageData, param: [:], header: headers) { (response, error) in
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
    
    func callChangePasswordAPI() {
        AppData.sharedInstance.showLoader()
        var params = NSDictionary()
        params = [
            "password":txtCurrentPassword.text ?? "",
            "newpassword":txtNewPassword.text ?? ""
        ]
        
        let headers: HTTPHeaders = ["Authorization":token]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + CHANGE_PASSWORD, param: params, header: headers) { (response, error) in
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
    
    func callSubscriptionsListAPI() {
        AppData.sharedInstance.showLoader()
        
        let headers: HTTPHeaders = ["Authorization":token]
        print(headers)
        
//        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess" ) {
//            AppData.sharedInstance.showAlert(title: "No Network Found!", message: "Please check your internet connection.", viewController: self)
//            return
//        }
        
        APIUtilities.sharedInstance.GetArrayAPICallWith(url: BASE_URL + SUBSCRIPTIONS_LIST, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? [[String:Any]] {
                for dict in res {
                   // let invoiceID = dict["InvoiceID"] as? String ?? ""
                    self.arrSubscription.append(SubscriptionList.init(dict: dict))
                    self.filterdata = self.arrSubscription
                  //  self.arrData.append(dict)
                }
                
            }
            
            DispatchQueue.main.async {
                self.subscriptionTblview.reloadData()
            }
            
        }
        
    }
    
    func callSaveSignatureAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization":token]
        
        let signatureImage: UIImage = showSignatureView.image ?? UIImage()
        let imageData = signatureImage.pngData()
        
        APIUtilities.sharedInstance.UuuploadImage(url: BASE_URL + SAVE_SIGNATURE, keyName: "signature",imageData: imageData, param: [:], header: headers) { (response, error) in
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
    
    func callSaveGoalsAPI() {
        AppData.sharedInstance.showLoader()
        var params = NSDictionary()
        params = ["clientgoal":Int(txtClientGoal.text!) ?? 0,
                  "salesgoal":Int(txtSalesGoal.text!) ?? 0]
        
        let headers: HTTPHeaders = ["Authorization":token]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SAVE_GOALS, param: params, header: headers) { (response, error) in
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
    
    func filterContentForSearchText(_ searchText: String) {
        filterdata = arrSubscription.filter({ (subscription:SubscriptionList) -> Bool in
            let invoiceid = "\(subscription.invoiceID)"
            let invoice = invoiceid.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let packagename = subscription.packageType
            let name = packagename.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            return invoice != nil || name != nil
        })
    }
    
    //MARK:- Actions
    @IBAction func btnPersonalInfoClick(_ sender: UIButton) {
//        if (personalInfoSelected == true) {
//            self.vw_personalInfo.isHidden = true
//            self.vw_personalInfoHeightConstraint.constant = 0
//            personalInfoSelected = false
//        } else {
//            self.vw_personalInfo.isHidden = false
//            self.vw_personalInfoHeightConstraint.constant = 1100
//            personalInfoSelected = true
//        }
        
        personalInfoSelected = true
        changeAvatarSelected = false
        changePasswordSelected = false
        showSubscription = false
        showSignature = false
        showMyGoals = false
        
       // setViewHeight()
        setHeight()
    }
    
    @IBAction func btnRefreshUsernameClick(_ sender: UIButton) {
        if (self.refreshUsernameValidation()) {
            callSetUsernameAPI()
        }
    }
    
    @IBAction func btnSameAsPrimaryAddress(_ sender: UIButton) {
        txtVwSecondaryAddress.text = txtStreetAddress.text
    }
    
    /*  @IBAction func btnCompanyTypeClick(_ sender: UIButton) {
        if (companyTypeDropdownOpen == true) {
            self.vw_comapnyTypeDropdown.isHidden = false
            imgCompanyTypeDropdown.image = UIImage(named: "up-arrow")
//          vw_profileImagTopConstraint.constant = 100
            
            lblCompanyWebsite.isHidden = true
            vw_CompanyWebsite.isHidden = true
            lblStreetAddress.isHidden = true
            
            companyTypeDropdownOpen = false
        } else {
            self.vw_comapnyTypeDropdown.isHidden = true
            imgCompanyTypeDropdown.image = UIImage(named: "down-arrow-1")
//          vw_profileImagTopConstraint.constant = 15
            
            lblCompanyWebsite.isHidden = false
            vw_CompanyWebsite.isHidden = false
            lblStreetAddress.isHidden = false

            companyTypeDropdownOpen = true
        }
    }      */
    
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
    
    @IBAction func btnChangeAvatarClick(_ sender: UIButton) {
//        if (changeAvatarSelected == true) {
//            self.vw_changeAvatar.isHidden = true
//            self.vw_changeAvatarHeightConstraint.constant = 0
//            changeAvatarSelected = false
//        } else {
//            self.vw_changeAvatar.isHidden = false
//            self.vw_changeAvatarHeightConstraint.constant = 280
//            changeAvatarSelected = true
//        }
        
        personalInfoSelected = false
        changeAvatarSelected = true
        changePasswordSelected = false
        showSubscription = false
        showSignature = false
        showMyGoals = false
        
       // setViewHeight()
        setHeight()
    }
    
    @IBAction func btnSelectImageClick(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnUploadImageClick(_ sender: UIButton) {
        callChangeAvatarAPI()
    }
    
    @IBAction func btnUpdatePasswordClick(_ sender: UIButton) {
        if changePasswordValidation() {
            callChangePasswordAPI()
        }
    }
    
    @IBAction func btnChangePasswordClick(_ sender: UIButton) {
//        if (changePasswordSelected == true) {
//            self.vw_changePassword.isHidden = true
//            self.vw_changePasswordHeightConstraint.constant = 0
//            changePasswordSelected = false
//        } else {
//            self.vw_changePassword.isHidden = false
//            self.vw_changePasswordHeightConstraint.constant = 370
//            changePasswordSelected = true
//        }
        
        personalInfoSelected = false
        changeAvatarSelected = false
        changePasswordSelected = true
        showSubscription = false
        showSignature = false
        showMyGoals = false
        
       // setViewHeight()
        setHeight()
    }
    
    @IBAction func btnSubscriptionClick(_ sender: UIButton) {
//        if (showSubscription == true) {
//            self.vw_subscription.isHidden = false
//            self.vw_subscriptionHeightConstraint.constant = 0
//            showSubscription = false
//        } else {
//            self.vw_subscription.isHidden = true
//            self.vw_subscriptionHeightConstraint.constant = 490
//            showSubscription = true
//        }
        
        personalInfoSelected = false
        changeAvatarSelected = false
        changePasswordSelected = false
        showSubscription = true
        showSignature = false
        showMyGoals = false
        
      //  setViewHeight()
        setHeight()
    }
    
    @IBAction func btnMySignatureClick(_ sender: UIButton) {
//        if (showSignature == true) {
//            self.vw_mySignature.isHidden = false
//            self.vw_mySignatureHeightConstraint.constant = 0
//            showSignature = false
//        } else {
//            self.vw_mySignature.isHidden = true
//            self.vw_mySignatureHeightConstraint.constant = 520
//            showSignature = true
//        }
        
        personalInfoSelected = false
        changeAvatarSelected = false
        changePasswordSelected = false
        showSubscription = false
        showSignature = true
        showMyGoals = false
        
        //  setViewHeight()
        
        if showSignatureView.image == nil {
            btnRemoveSignature.isHidden = true
        } else {
            btnRemoveSignature.isHidden = false
        }
        
        setHeight()
    }
    
    @IBAction func btnSaveSignatureClick(_ sender: UIButton) {
        showSignatureView.image = signatureView.getCroppedSignature()
        if showSignatureView.image == nil {
            btnRemoveSignature.isHidden = true
        } else {
            btnRemoveSignature.isHidden = false
        }
        signatureView.clear()
        print("fullRender \(showSignatureView.image?.size ?? CGSize.zero)")
        
        callSaveSignatureAPI()
    }
    
    @IBAction func btnClearSignatureClick(_ sender: UIButton) {
        signatureView.clear()
    }
    
    @IBAction func btnRemoveSignatureClick(_ sender: UIButton) {
        showSignatureView.image = nil
    }
    
    @IBAction func btnMyGoalsClick(_ sender: UIButton) {
//        if (showMyGoals == true) {
//            self.vw_myGoals.isHidden = false
//            self.vw_myGoalsHeightConstraint.constant = 0
//            showMyGoals = false
//        } else {
//            self.vw_myGoals.isHidden = true
//            self.vw_myGoalsHeightConstraint.constant = 400
//            showMyGoals = true
//        }
        
        personalInfoSelected = false
        changeAvatarSelected = false
        changePasswordSelected = false
        showSubscription = false
        showSignature = false
        showMyGoals = true
        
        //  setViewHeight()
        setHeight()
    }
    
    @IBAction func btnClientGoalClick(_ sender: UIButton) {
        if (clientGoalDropdownOpen == true) {
            self.vw_clientGoalDropdown.isHidden = false
            imgClientGoalDropdown.image = UIImage(named: "up-arrow")
            
            lblSalesGoal.isHidden = true
            vw_selectSalesGoal.isHidden = true
            btnSalesGoal.isHidden = true
            imgSalesGoalDropdown.isHidden = true
            
            clientGoalDropdownOpen = false
        } else {
            self.vw_clientGoalDropdown.isHidden = true
            imgClientGoalDropdown.image = UIImage(named: "down-arrow-1")
            
            lblSalesGoal.isHidden = false
            vw_selectSalesGoal.isHidden = false
            btnSalesGoal.isHidden = false
            imgSalesGoalDropdown.isHidden = false
            
            clientGoalDropdownOpen = true
        }
    }
    
    @IBAction func btnSalesGoalClick(_ sender: UIButton) {
        if (salesGoalDropdownOpen == true) {
            self.vw_salesGoalDropdown.isHidden = false
            imgSalesGoalDropdown.image = UIImage(named: "up-arrow")
            
            //            lblCity.isHidden = true
            //            vw_city.isHidden = true
            
            salesGoalDropdownOpen = false
        } else {
            self.vw_salesGoalDropdown.isHidden = true
            imgSalesGoalDropdown.image = UIImage(named: "down-arrow-1")
            
            //            lblCity.isHidden = false
            //            vw_city.isHidden = false
            
            salesGoalDropdownOpen = true
        }
    }
    
    @IBAction func btnSaveMyGoalsClick(_ sender: UIButton) {
        if (self.saveGoalsValidation()) {
            callSaveGoalsAPI()
        }
    }
    
    @objc func headerViewTapped(tapped:UITapGestureRecognizer) {
        if searching {
            if filterdata[tapped.view!.tag].collapsed == true {
                filterdata[tapped.view!.tag].collapsed = false
            } else {
                filterdata[tapped.view!.tag].collapsed = true
            }
            if let imView = tapped.view?.subviews[1] as? UIImageView {
                if imView.isKind(of: UIImageView.self) {
                    if filterdata[tapped.view!.tag].collapsed {
                        imView.image = UIImage(named: "minus")
                    } else {
                        imView.image = UIImage(named: "plus")
                    }
                }
            }
        } else {
            if arrSubscription[tapped.view!.tag].collapsed == true {
                arrSubscription[tapped.view!.tag].collapsed = false
            } else {
                arrSubscription[tapped.view!.tag].collapsed = true
            }
            if let imView = tapped.view?.subviews[1] as? UIImageView {
                if imView.isKind(of: UIImageView.self) {
                    if arrSubscription[tapped.view!.tag].collapsed {
                        imView.image = UIImage(named: "minus")
                    } else {
                        imView.image = UIImage(named: "plus")
                    }
                }
            }
        }
        self.searchBar.searchTextField.endEditing(true)
        subscriptionTblview.reloadData()
    }
}

extension ProfileVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblVwState {
            return 1
        } else if tableView == subscriptionTblview {
            if searching {
                return filterdata.count
            } else {
                return arrSubscription.count
            }
        } else if tableView == tblVwClientGoal {
            return 1
        } else if tableView == tblVwSalesGoal {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblVwState {
            return arrState.count
        } else if tableView == subscriptionTblview {
            if searching {
                let itms = filterdata[section]
                return !itms.collapsed ? 0 : 1
            } else {
                let itms = arrSubscription[section]
                return !itms.collapsed ? 0 : 1
            }
        } else if tableView == tblVwClientGoal {
            return arrClientGoal.count
        } else if tableView == tblVwSalesGoal {
            return arrSalesGoal.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblVwState {
            let cell = tblVwState.dequeueReusableCell(withIdentifier: "CompanyTypeCell", for: indexPath) as! CompanyTypeCell
            cell.lblTitle.text = arrState[indexPath.row]
            return cell
        } else if tableView == subscriptionTblview {
            let cell = subscriptionTblview.dequeueReusableCell(withIdentifier: "SubscriptionDataCell", for: indexPath) as! SubscriptionDataCell
            if searching {
                let model = filterdata[indexPath.section]
                cell.lblAmount.text = "\(model.amount)"
                cell.lblPurchaseDate.text = model.paytime
                cell.lblExpirationDate.text = model.packend
                
                if model.paymentType == "" {
                    cell.lblPaymentType.text = "--"
                } else {
                    cell.lblPaymentType.text = model.paymentType
                }
                
                cell.lblStatus.text = model.status
            } else {
                let model = arrSubscription[indexPath.section]
                cell.lblAmount.text = "\(model.amount)"
                cell.lblPurchaseDate.text = model.paytime
                cell.lblExpirationDate.text = model.packend
                
                if model.paymentType == "" {
                    cell.lblPaymentType.text = "--"
                } else {
                    cell.lblPaymentType.text = model.paymentType
                }
                
                cell.lblStatus.text = model.status
            }
            return cell
        } else if tableView == tblVwClientGoal {
            let cell = tblVwClientGoal.dequeueReusableCell(withIdentifier: "CompanyTypeCell", for: indexPath) as! CompanyTypeCell
            cell.lblTitle.text = arrClientGoal[indexPath.row]
            return cell
        } else if tableView == tblVwSalesGoal {
            let cell = tblVwSalesGoal.dequeueReusableCell(withIdentifier: "CompanyTypeCell", for: indexPath) as! CompanyTypeCell
            cell.lblTitle.text = arrSalesGoal[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}

extension ProfileVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == subscriptionTblview {
            return 45
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblVwState {
            return 40
        } else if tableView == subscriptionTblview {
            return 240
        } else if tableView == tblVwClientGoal {
            return 40
        } else if tableView == tblVwSalesGoal {
            return 40
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == subscriptionTblview {
            let headerCell = subscriptionTblview.dequeueReusableCell(withIdentifier: "SubscriptionListCell") as! SubscriptionListCell
            
            if searching {
                headerCell.lblInvoiceID.text = "\(filterdata[section].invoiceID)"
                headerCell.lblPackageType.text = filterdata[section].packageType
                
                if filterdata[section].collapsed {
                    headerCell.expandImageView.image = UIImage(named: "minus")
                } else {
                    headerCell.expandImageView.image = UIImage(named: "plus")
                }
            } else {
                headerCell.lblInvoiceID.text = "\(arrSubscription[section].invoiceID)"
                headerCell.lblPackageType.text = arrSubscription[section].packageType
                
                if arrSubscription[section].collapsed {
                    headerCell.expandImageView.image = UIImage(named: "minus")
                } else {
                    headerCell.expandImageView.image = UIImage(named: "plus")
                }
            }
            
            let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(headerViewTapped))
            tapGuesture.numberOfTapsRequired = 1
            headerCell.addGestureRecognizer(tapGuesture)
            headerCell.tag = section
            
            return headerCell
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblVwState {
            let cell = tblVwState.cellForRow(at: indexPath) as! CompanyTypeCell
            txtState.text = cell.lblTitle.text
        } else if tableView == tblVwClientGoal {
            let cell = tblVwClientGoal.cellForRow(at: indexPath) as! CompanyTypeCell
            txtClientGoal.text = cell.lblTitle.text
        } else if tableView == tblVwSalesGoal {
            let cell = tblVwSalesGoal.cellForRow(at: indexPath) as! CompanyTypeCell
            txtSalesGoal.text = cell.lblTitle.text
        }
    }
}

extension ProfileVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                filterdata = arrSubscription
            }
            subscriptionTblview.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        subscriptionTblview.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
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
extension ProfileVC: UITextFieldDelegate {
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
        
        txtCurrentPassword.resignFirstResponder()
        txtNewPassword.resignFirstResponder()
        txtConfirmNewPassword.resignFirstResponder()
        return true
    }
}

extension ProfileVC: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        self.txtVwSecondaryAddress.endEditing(true)
        txtVwSecondaryAddress.resignFirstResponder()
    }
}

extension ProfileVC: SwiftSignatureViewDelegate {
    func swiftSignatureViewDidDrawGesture(_ view: ISignatureView, _ tap: UIGestureRecognizer) {
        print("swiftSignatureViewDidDrawGesture")
        scrollView.panGestureRecognizer.require(toFail: tap)
        //  scrollView.isScrollEnabled = false
    }
    
    func swiftSignatureViewDidDraw(_ view: ISignatureView) {
        print("swiftSignatureViewDidDraw")
        // scrollView.isScrollEnabled = false
    }
}


