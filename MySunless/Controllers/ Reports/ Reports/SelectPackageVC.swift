//
//  SelectPackageVC.swift
//  MySunless
//
//  Created by iMac on 28/02/22.
//

import UIKit
import iOSDropDown
import Alamofire

class SelectPackageVC: UIViewController {

    @IBOutlet var vw_mainView: UIView!
    @IBOutlet var vw_top: UIView!
    @IBOutlet var vw_bottom: UIView!
    @IBOutlet var lblRecipientName: UILabel!
    @IBOutlet var vw_package: UIView!
    @IBOutlet var txtChoosePackage: DropDown!
    @IBOutlet var vw_amount: UIView!
    @IBOutlet var txtAmount: UITextField!
    @IBOutlet var vw_visits: UIView!
    @IBOutlet var txtVisits: UITextField!
    @IBOutlet var vw_expiresOn: UIView!
    @IBOutlet var txtExpiresOn: UITextField!
    
    var token = String()
 //   var datePicker = UIDatePicker()
    var arrViewPackage = [ViewPackage]()
    var arrPackageName = [String]()
    var arrPackageIds = [Int]()
    var selectedPackageId = Int()
    var selectedClientName = String()
    var delegate: AddOrderProtocol?
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.backgroundColor = .white
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.sizeToFit()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    lazy var doneToolBar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
        toolbar.setItems([doneButton], animated: true)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    lazy var pickerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        hideKeyboardWhenTappedAround()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callViewPackageAPI()
    }
    
    func setInitially() {
        vw_mainView.layer.borderWidth = 1.0
        vw_mainView.layer.borderColor = UIColor.init("#005CC8").cgColor
        vw_top.layer.cornerRadius = 12
        vw_top.layer.masksToBounds = true
        vw_top.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        vw_bottom.layer.cornerRadius = 12
        vw_bottom.layer.masksToBounds = true
        vw_bottom.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        vw_package.layer.borderWidth = 0.5
        vw_package.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_amount.layer.borderWidth = 0.5
        vw_amount.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_visits.layer.borderWidth = 0.5
        vw_visits.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_expiresOn.layer.borderWidth = 0.5
        vw_expiresOn.layer.borderColor = UIColor.init("#15B0DA").cgColor
        txtChoosePackage.delegate = self
        txtExpiresOn.delegate = self
        txtAmount.delegate = self
        txtVisits.delegate = self
        lblRecipientName.text = selectedClientName
        setupAutoLayout()
        pickerContainer.isHidden = true
        hideDatePicker()
    }
    
    func setValidation() -> Bool {
        if txtChoosePackage.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please select Package", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func showDatePickerView() {
        DispatchQueue.main.async {
            self.pickerContainer.isHidden = false
        }
    }
    
    func hideDatePicker() {
        DispatchQueue.main.async {
            self.pickerContainer.isHidden = true
        }
    }
    
    func setupAutoLayout() {
        pickerContainer.layer.borderWidth = 0.5
        pickerContainer.layer.borderColor = UIColor.init("#15B0DA").cgColor
        pickerContainer.layer.cornerRadius = 8
        self.view.addSubview(pickerContainer)
        self.view.bringSubviewToFront(pickerContainer)
        pickerContainer.addSubview(doneToolBar)
        pickerContainer.addSubview(datePicker)
        NSLayoutConstraint.activate([
            pickerContainer.topAnchor.constraint(equalTo: txtExpiresOn.bottomAnchor, constant: 5),
            pickerContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            pickerContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            pickerContainer.heightAnchor.constraint(equalToConstant: datePicker.intrinsicContentSize.height + doneToolBar.intrinsicContentSize.height),
            
            doneToolBar.topAnchor.constraint(equalTo: pickerContainer.topAnchor, constant: 0),
            doneToolBar.leftAnchor.constraint(equalTo: pickerContainer.leftAnchor, constant: 0),
            doneToolBar.rightAnchor.constraint(equalTo: pickerContainer.rightAnchor, constant: 0),
            
            datePicker.bottomAnchor.constraint(equalTo: pickerContainer.bottomAnchor, constant: 0),
            datePicker.leftAnchor.constraint(equalTo: pickerContainer.leftAnchor, constant: 0),
            datePicker.rightAnchor.constraint(equalTo: pickerContainer.rightAnchor, constant: 0)
        ])
    }
    
    func callViewPackageAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = [:]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + VIEW_PACKAGE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrViewPackage.removeAll()
                            for dict in response {
                                self.arrViewPackage.append(ViewPackage(dictionary: dict)!)
                            }
                            for item in self.arrViewPackage {
                                self.arrPackageName.append(item.name ?? "")
                                self.arrPackageIds.append(item.id ?? 0)
                            }
                            self.txtChoosePackage.optionArray = self.arrPackageName
                            self.txtChoosePackage.optionIds = self.arrPackageIds
                            self.txtChoosePackage.didSelect{(selectedText, index, id) in
                                self.txtChoosePackage.selectedIndex = index
                                self.selectedPackageId = id
                                for item in self.arrViewPackage {
                                    if item.id == id {
                                        self.txtAmount.text = item.price
                                        self.txtVisits.text = item.noofvisit
                                        self.txtExpiresOn.text = item.tracking
                                    }
                                }
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
    
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnAddToCartClick(_ sender: UIButton) {
        if setValidation() {
            self.dismiss(animated: true) {
                self.delegate?.callOrderPackageAPI(packageId: self.selectedPackageId, packageExpire: self.txtExpiresOn.text ?? "", packageAmount: self.txtAmount.text ?? "", Noofvisit: self.txtVisits.text ?? "")
            }
        }
    }
    
    @IBAction func btnManagePackageClick(_ sender: UIButton) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let storyBoard = UIStoryboard(name:"Main", bundle: nil)
        if let conVC = storyBoard.instantiateViewController(withIdentifier: "PackagesListVC") as? PackagesListVC,
           let navController = window?.rootViewController as? UINavigationController {
            self.dismiss(animated: true, completion: nil)
            navController.pushViewController(conVC, animated: true)
        }
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        txtExpiresOn.text = dateFormatter.string(from: datePicker.date)
        self.txtExpiresOn.resignFirstResponder()
    }
    
    @objc func doneClicked() {
        hideDatePicker()
    }
}

//MARK:- UITextfield Delegate Methods
extension SelectPackageVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtChoosePackage {
            txtChoosePackage.resignFirstResponder()
        } else if textField == txtExpiresOn {
          //  txtExpiresOn.setInputViewDatePicker(target: self, selector: #selector(handleDatePicker))
            txtExpiresOn.resignFirstResponder()
            showDatePickerView()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtAmount.resignFirstResponder()
        txtVisits.resignFirstResponder()
        return true
    }
}

