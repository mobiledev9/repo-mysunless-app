//
//  AddOrderVC.swift
//  MySunless
//
//  Created by iMac on 25/02/22.
//

import UIKit
import iOSDropDown
import Alamofire
import Kingfisher
import SCLAlertView

protocol AddOrderProtocol {
    func callOrderServiceAPI(clientId: Int, serviceId: Int, serviceProviderId: Int?, startTime: String?)
    func callOrderProductAPI(productIds: String, arrSelectedProductIds: [String])
    func callOrderPackageAPI(packageId: Int, packageExpire: String, packageAmount: String, Noofvisit: String)
    func callOrderGiftAPI(clientId: Int, giftCardAmount: String)
    func setServiceAndTotalAmt(selectedItem: String?, totalAmt: Float?, arrCart: [CartList]?)
}

class AddOrderVC: UIViewController {

    @IBOutlet var btnEditProfileClick: UIButton!
    @IBOutlet var vw_chooseClient: UIView!
    @IBOutlet var txtChooseClient: DropDown!
    @IBOutlet var vw_clientDetails: UIView!
    @IBOutlet var btnClientProfileImg: UIButton!
    @IBOutlet var lblClientUsername: UILabel!
    @IBOutlet var lblClientEmail: UILabel!
    @IBOutlet var lblClientPhoneNumber: UILabel!
    @IBOutlet var lblClientAmount: UILabel!
    @IBOutlet var vw_selectPackage: UIView!
    @IBOutlet var txtSelectPackage: DropDown!
    @IBOutlet var vw_emptyCart: UIView!
    @IBOutlet var vw_cartTable: UIView!
    @IBOutlet var tblCartList: UITableView!
    @IBOutlet var vw_buttons: UIView!
    @IBOutlet var vw_orderPriceData: UIView!
    @IBOutlet var lblServicePrice: UILabel!
    @IBOutlet var lblGiftCardPrice: UILabel!
    @IBOutlet var lblProductPrice: UILabel!
    @IBOutlet var lblPackagePrice: UILabel!
    @IBOutlet var txtTipsValue1: UITextField!
    @IBOutlet var txtTipsValue2: UITextField!
    @IBOutlet var vw_chooseTips: UIView!
    @IBOutlet var txtChooseTips: DropDown!
    @IBOutlet var lblSalesTax: UILabel!
    @IBOutlet var lblTotalAmount: UILabel!
    @IBOutlet var vw_email: UIView!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var btnService: UIButton!
    @IBOutlet var btnProduct: UIButton!
    @IBOutlet var btnPackage: UIButton!
    @IBOutlet var btnGiftCard: UIButton!
    @IBOutlet var vw_clientDetailsHeight: NSLayoutConstraint!  //120
    @IBOutlet var imgMembership: UIImageView!
    @IBOutlet var imgMembershipHeight: NSLayoutConstraint!   //20
    @IBOutlet var lblMembership: UILabel!
    @IBOutlet var lblMembershipHeight: NSLayoutConstraint!    //21
    @IBOutlet var vw_selectPackageHeight: NSLayoutConstraint!   //42
    @IBOutlet var vw_emptyCartHeight: NSLayoutConstraint!     //200
    @IBOutlet var vw_cartTableHeight: NSLayoutConstraint!      //200
    @IBOutlet var vw_emailHeight: NSLayoutConstraint!      //30
    @IBOutlet var vw_main: UIView!
    @IBOutlet var vw_mainHeight: NSLayoutConstraint!        //1320-268
    @IBOutlet var vw_emptyCartTop: NSLayoutConstraint!      //232
    @IBOutlet var imgCustomer: UIImageView!
    @IBOutlet var vw_buttonsTop: NSLayoutConstraint!        //230
    @IBOutlet var vw_chooseTipsHeight: NSLayoutConstraint!   //30
    @IBOutlet var vw_tipsSeparatorTop: NSLayoutConstraint!     //43
    @IBOutlet var btnRadioNone: UIButton!
    @IBOutlet var btnRadioEmail: UIButton!
    @IBOutlet var btnRadioCustom: UIButton!
    @IBOutlet var lblCopyOfInvoice: UILabel!
    @IBOutlet var lblNone: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblCustom: UILabel!
    
    var token = String()
    var arrCustomer = [ChooseCustomer]()
    var arrMemberPackage = [MemberPackage]()
    var selectedClientId = Int()
    var arrCartList = [CartList]()
    var arrSetFromCart = [CartList]()
    var item = String()
    var price = Float()
    var discount = Float()
    var discountPercent = Float()
    var dictService = CartList()
    var arrOrderProduct = [OrderProduct]()
    var giftCardAdded = false
    var totalServicePrice = Float()
    var totalProductPrice = Float()
    var totalPackagePrice = Float()
    var totalGiftCardPrice = Float()
    var arrAddProductIds = [String]()
    var arrFinalIds = [String]()
    var arrTitle = [String]()
    var showProductAlert = false
    var valueFor15Percent = Float()
    var valueFor18Percent = Float()
    var valueFor20Percent = Float()
    var arrChooseTips = [String]()
    var salestaxPercent = Float()
    
    var arrServiceIds = [String]()
    var arrServiceProvider = [ProviderData]()
    var arrServiceProviderIds = [String]()
    var arrServiceStartTime = [String]()
    var productIds = String()
    var arrPackageIds = [String]()
    var arrNoOfVisit = [String]()
    var arrPackageExpiryDate = [String]()
    var serviceCommissionAmt = Int()
    var productCommissionAmt = Int()
    var packageCommissionAmt = Int()
    var email = String()
    
    var isEditCompletedOrder = false
    var editCompletedOrder = ShowCompletedOrder(dict: [:])
    var tips = String()
    var isFromPackageListVC = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        setInitialHeight()
        tblCartList.tableFooterView = UIView()
        hideKeyboardWhenTappedAround()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callChooseCustomerAPI()
        setShowHideCartView()
        
        if arrCartList.count != 0 {
            for i in self.arrCartList {
                if i.selectedItem == "Service" {
                    self.totalServicePrice = self.totalServicePrice + i.price
                }
                if i.selectedItem == "Product" {
                    self.totalProductPrice = self.totalProductPrice + i.totalPrice
                }
                if i.selectedItem == "Package" {
                    self.totalPackagePrice = self.totalPackagePrice + i.price
                }
                if i.selectedItem == "Gift Card" {
                    self.totalGiftCardPrice = self.totalGiftCardPrice + i.price
                    self.giftCardAdded = true
                }
            }
            
            txtTipsValue1.text = tips
            calculateTipsValueInPercent()
        }
        
        if isFromPackageListVC {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "SelectPackageVC") as! SelectPackageVC
            VC.modalPresentationStyle = .overCurrentContext
            VC.modalTransitionStyle = .crossDissolve
            VC.delegate = self
            VC.selectedClientName = txtChooseClient.text ?? ""
            self.present(VC, animated: true, completion: nil)
        }
        
    }

    func setInitially() {
        vw_chooseClient.layer.borderWidth = 0.5
        vw_chooseClient.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_selectPackage.layer.borderWidth = 0.5
        vw_selectPackage.layer.borderColor = UIColor.init("#15B0DA").cgColor
        btnService.layer.borderWidth = 0.5
        btnService.layer.borderColor = UIColor.init("#15B0DA").cgColor
        btnService.layer.cornerRadius = 8
        btnProduct.layer.borderWidth = 0.5
        btnProduct.layer.borderColor = UIColor.init("#15B0DA").cgColor
        btnProduct.layer.cornerRadius = 8
        btnPackage.layer.borderWidth = 0.5
        btnPackage.layer.borderColor = UIColor.init("#15B0DA").cgColor
        btnPackage.layer.cornerRadius = 8
        btnGiftCard.layer.borderWidth = 0.5
        btnGiftCard.layer.borderColor = UIColor.init("#15B0DA").cgColor
        btnGiftCard.layer.cornerRadius = 8
        txtTipsValue1.layer.borderWidth = 0.5
        txtTipsValue1.layer.borderColor = UIColor.black.cgColor
        txtTipsValue1.layer.cornerRadius = 8
        txtTipsValue2.layer.borderWidth = 0.5
        txtTipsValue2.layer.borderColor = UIColor.black.cgColor
        txtTipsValue2.layer.cornerRadius = 8
        
        vw_clientDetails.layer.borderWidth = 0.5
        vw_clientDetails.layer.borderColor = UIColor.lightGray.cgColor
        vw_cartTable.layer.borderWidth = 1.0
        vw_cartTable.layer.borderColor = UIColor.lightGray.cgColor
        vw_orderPriceData.layer.borderWidth = 0.5
        vw_orderPriceData.layer.borderColor = UIColor.lightGray.cgColor
        vw_chooseTips.layer.borderWidth = 0.5
        vw_chooseTips.layer.borderColor = UIColor.black.cgColor
        vw_emptyCart.layer.borderWidth = 0.5
        vw_emptyCart.layer.borderColor = UIColor.lightGray.cgColor
        vw_email.layer.borderWidth = 0.5
        vw_email.layer.borderColor = UIColor.black.cgColor
        imgCustomer.layer.cornerRadius = imgCustomer.frame.size.height / 2
        txtEmail.delegate = self
        txtTipsValue1.delegate = self
        txtTipsValue2.delegate = self
        txtChooseTips.delegate = self
        txtChooseClient.delegate = self
        txtSelectPackage.delegate = self
    }
    
    func setInitialHeight() {
        btnEditProfileClick.isHidden = true
//        if isEditCompletedOrder {
//            vw_clientDetails.isHidden = false
//            vw_clientDetailsHeight.constant = 120
//        } else {
            vw_clientDetails.isHidden = true
            vw_clientDetailsHeight.constant = 0
//        }
        imgMembership.isHidden = true
        imgMembershipHeight.constant = 0
        lblMembership.isHidden = true
        lblMembershipHeight.constant = 0
        vw_selectPackage.isHidden = true
        vw_selectPackageHeight.constant = 0
        vw_emptyCart.isHidden = false
        vw_emptyCartHeight.constant = 200
        vw_emptyCartTop.constant = 15
        lblServicePrice.text = ""
        lblTotalAmount.text = ""
        vw_cartTable.isHidden = true
        vw_cartTableHeight.constant = 0
        vw_email.isHidden = true
        vw_emailHeight.constant = 0
      //  vw_buttonsTop.constant = 15
        vw_chooseTipsHeight.constant = 0
        vw_tipsSeparatorTop.constant = 5
        vw_chooseTips.isHidden = true
        
        lblCopyOfInvoice.isHidden = true
        btnRadioNone.isHidden = true
        btnRadioEmail.isHidden = true
        btnRadioCustom.isHidden = true
        lblNone.isHidden = true
        lblEmail.isHidden = true
        lblCustom.isHidden = true
        
        vw_mainHeight.constant = 1052
    }
    
    func setViewOnSelectClient() {
        btnEditProfileClick.isHidden = false
      //  if isEditCompletedOrder {
            vw_clientDetails.isHidden = false
            vw_clientDetailsHeight.constant = 120
//        } else {
//            vw_clientDetails.isHidden = true
//            vw_clientDetailsHeight.constant = 0
//        }
        imgMembership.isHidden = false
        imgMembershipHeight.constant = 20
        lblMembership.isHidden = false
        lblMembershipHeight.constant = 21
        vw_selectPackage.isHidden = false
        vw_selectPackageHeight.constant = 42
        vw_emptyCartTop.constant = 232
        vw_mainHeight.constant = 1320
        
        lblCopyOfInvoice.isHidden = false
        btnRadioNone.isHidden = false
        btnRadioEmail.isHidden = false
        btnRadioCustom.isHidden = false
        lblNone.isHidden = false
        lblEmail.isHidden = false
        lblCustom.isHidden = false
        
    }
    
    func setShowHideCartView() {
        if arrCartList.count == 0 {
            vw_emptyCart.isHidden = false
            vw_emptyCartHeight.constant = 200
            vw_cartTable.isHidden = true
            vw_cartTableHeight.constant = 200
            vw_buttonsTop.constant = 230
            lblServicePrice.text = ""
            lblTotalAmount.text = ""
        } else {
            vw_emptyCart.isHidden = true
            vw_emptyCartHeight.constant = 0
            vw_cartTable.isHidden = false
            vw_cartTableHeight.constant = 200
            vw_buttonsTop.constant = 230
        }
    }
    
    func setCheckOutValidation() -> Bool {
        if arrCartList.count == 0 {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please add service,product or membership in cart", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func setServicetValidation() -> Bool {
        if txtChooseClient.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please select client", viewController: self)
        } else {
            return true
        }
        return false
    }

    func showAlert(alertMainTitle: String, alertTitle: String) {
        let alert = SCLAlertView()
        alert.addButton("OK", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertMainTitle, subTitle: alertTitle)
    }
    
    func setChooseTipsValue(totalPrice: Float) {
        valueFor15Percent = (totalPrice / 100) * 15
        valueFor18Percent = (totalPrice / 100) * 18
        valueFor20Percent = (totalPrice / 100) * 20
        
        arrChooseTips = ["15% = $ \(valueFor15Percent)", "18% = $ \(valueFor18Percent)", "20% = $ \(valueFor20Percent)"]
        txtChooseTips.optionArray = arrChooseTips
        txtChooseTips.didSelect { (selectedText, index, id) in
            switch index {
                case 0:
                    self.txtTipsValue1.text = String(format: "%.02f", self.valueFor15Percent)
                    self.txtChooseTips.text = "Choose %"
                case 1:
                    self.txtTipsValue1.text = String(format: "%.02f", self.valueFor18Percent)
                    self.txtChooseTips.text = "Choose %"
                case 2:
                    self.txtTipsValue1.text = String(format: "%.02f", self.valueFor20Percent)
                    self.txtChooseTips.text = "Choose %"
                default:
                    print("default")
            }
        }
        txtChooseTips.listDidDisappear {
            self.txtChooseTips.text = "Choose %"
            self.calculateTipsValueInPercent()
            self.lblTotalAmount.text = "$" + String(format:"%.02f",self.arrCartList.sum(\.totalPrice) + (self.txtTipsValue1.text?.floatValue() ?? 0.00))
        }
    }
    
    func calculateTipsValueInPercent() {
        let total = totalServicePrice + totalProductPrice + totalPackagePrice + totalGiftCardPrice
        txtTipsValue2.text = String(format: "%.02f",(txtTipsValue1.text?.floatValue() ?? 0.00) / (total) * 100)
    }
    
    func calculateTipsValue() {
        let total = totalServicePrice + totalProductPrice + totalPackagePrice + totalGiftCardPrice
        txtTipsValue1.text = String(format: "%.02f",(total) / 100 * (txtTipsValue2.text?.floatValue() ?? 0.00))
    }
    
    func calculateSalesTaxPercent(salesTax: Float, productPrice: Float) -> Float {
        let tax = salesTax / 100 * productPrice
        return tax
    }
    
    func callChooseCustomerAPI() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + CHOOSE_CUSTOMER, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "resonse") as? [[String:Any]] {
                            self.arrCustomer.removeAll()
                            for dict in response {
                                self.arrCustomer.append(ChooseCustomer(dict: dict))
                            }
                            self.txtChooseClient.optionIds = self.arrCustomer.map{$0.id}
                            self.txtChooseClient.optionArray = self.arrCustomer.map{ $0.FirstName + " " + $0.LastName }
                            self.txtChooseClient.didSelect{(selectedText, index, id) in
                                self.txtChooseClient.selectedIndex = index
                                self.selectedClientId = id
                                let arr = self.arrCustomer.filter{$0.id == id}
                                self.setViewOnSelectClient()
                                for dic in arr {
                                    let imgUrl = URL(string: dic.ProfileImg)
                                    self.imgCustomer.kf.setImage(with: imgUrl)
                                    self.lblClientUsername.text = dic.FirstName + " " + dic.LastName
                                    self.lblClientEmail.text = dic.email
                                    self.lblClientPhoneNumber.text = dic.Phone
                                    self.lblClientAmount.text = "$" + dic.giftcardbal
                                    
                                    self.lblEmail.text = dic.email
                                }
                            
                                self.callMemberPackageAPI(clientId: id)
                            }
                            
                            if self.isEditCompletedOrder {
                                let arr = self.arrCustomer.filter{$0.id == self.selectedClientId}
                                self.setViewOnSelectClient()
                                for dic in arr {
                                    self.txtChooseClient.text = dic.FirstName.capitalized + " " + dic.LastName.capitalized
                                    let imgUrl = URL(string: dic.ProfileImg)
                                    self.imgCustomer.kf.setImage(with: imgUrl)
                                    self.lblClientUsername.text = dic.FirstName + " " + dic.LastName
                                    self.lblClientEmail.text = dic.email
                                    self.lblClientPhoneNumber.text = dic.Phone
                                    self.lblClientAmount.text = "$" + dic.giftcardbal
                                    
                                    self.lblEmail.text = dic.email
                                }
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "resonse") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                        }
                    }
                }
            }
        }
    }
    
    func callMemberPackageAPI(clientId: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["clientId": clientId]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + MEMBER_PACKAGE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrMemberPackage.removeAll()
                            for dict in response {
                                self.arrMemberPackage.append(MemberPackage(dictionary: dict)!)
                            }
                            self.txtSelectPackage.optionArray = self.arrMemberPackage.map{($0.name ?? "")}
                            self.txtSelectPackage.didSelect { (selectedText, index, id) in
                                
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
    
    @IBAction func btnAddCustomerClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "CustomerDetailsVC") as! CustomerDetailsVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnEditProfileClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "CustomerDetailsVC") as! CustomerDetailsVC
        VC.selectedClientDetailID = selectedClientId
        VC.isFromClientDetail = true
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnClientProfileImgClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ClientDetailVC") as! ClientDetailVC
        VC.selectedId = selectedClientId
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnServiceClick(_ sender: UIButton) {
        if setServicetValidation() {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "SelectServiceVC") as! SelectServiceVC
            VC.modalPresentationStyle = .overCurrentContext
            VC.modalTransitionStyle = .crossDissolve
            VC.delegate = self
            VC.selectedClientId = selectedClientId
            self.present(VC, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnProductClick(_ sender: UIButton) {
        if setServicetValidation() {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "SelectProductVC") as! SelectProductVC
            VC.modalPresentationStyle = .overCurrentContext
            VC.modalTransitionStyle = .crossDissolve
            VC.delegate = self
            for dic in arrCartList {
                if dic.selectedItem == "Product" {
                    VC.arrAddedProductIds = dic.productIds ?? []
                    VC.arrCartListProduct.append(dic)
                }
            }
            self.present(VC, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnPackageClick(_ sender: UIButton) {
        if setServicetValidation() {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "SelectPackageVC") as! SelectPackageVC
            VC.modalPresentationStyle = .overCurrentContext
            VC.modalTransitionStyle = .crossDissolve
            VC.delegate = self
            VC.selectedClientName = txtChooseClient.text ?? ""
            self.present(VC, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnGiftCardClick(_ sender: UIButton) {
        if setServicetValidation() {
            if !giftCardAdded {
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddGiftCardVC") as! AddGiftCardVC
                VC.modalPresentationStyle = .overCurrentContext
                VC.modalTransitionStyle = .crossDissolve
                VC.delegate = self
                VC.selectedClientId = selectedClientId
                VC.selectedClientName = txtChooseClient.text ?? ""
                self.present(VC, animated: true, completion: nil)
            } else {
                showAlert(alertMainTitle: "", alertTitle: "Gift Card already added.")
            }
        }
    }
    
    @IBAction func btnCheckOutClick(_ sender: UIButton) {
        if setCheckOutValidation() {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "OrderSummaryVC") as! OrderSummaryVC
            VC.arrShowCartList = arrCartList
            VC.servicePrice = lblServicePrice.text ?? ""
            VC.giftCardPrice = lblGiftCardPrice.text ?? ""
            VC.productPrice = lblProductPrice.text ?? ""
            VC.packagePrice = lblPackagePrice.text ?? ""
            VC.tips = txtTipsValue1.text ?? ""
            VC.salesTax = lblSalesTax.text ?? ""
            VC.total = lblTotalAmount.text ?? ""
            VC.selectedClientId = selectedClientId
            VC.arrServiceIds = arrServiceIds
            VC.arrServiceProviderIds = arrServiceProviderIds
            VC.arrServiceStartTime = arrServiceStartTime
            VC.productIds = productIds
            VC.arrMembershipIds = arrPackageIds
            VC.arrNoofvisit = arrNoOfVisit
            VC.arrPackageExpireDate = arrPackageExpiryDate
            if email == "Custom" {
                VC.email = txtEmail.text ?? ""
            } else if email == "Email" {
                VC.email = lblEmail.text ?? ""
            } else if email == "" {
                VC.email = email
            }
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    @IBAction func btnCancelOrderClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnRadioSendInvoiceClick(_ sender: UIButton) {
        switch sender.tag {
            case 0:
                if btnRadioNone.currentImage?.description.contains("radio-off-button") == true {
                    btnRadioNone.setImage(UIImage(named: "radio-on-button"), for: .normal)
                    btnRadioEmail.setImage(UIImage(named: "radio-off-button"), for: .normal)
                    btnRadioCustom.setImage(UIImage(named: "radio-off-button"), for: .normal)
                    vw_email.isHidden = true
                    vw_emailHeight.constant = 0
                    email = ""
                }
            case 1:
                if btnRadioEmail.currentImage?.description.contains("radio-off-button") == true {
                    btnRadioEmail.setImage(UIImage(named: "radio-on-button"), for: .normal)
                    btnRadioNone.setImage(UIImage(named: "radio-off-button"), for: .normal)
                    btnRadioCustom.setImage(UIImage(named: "radio-off-button"), for: .normal)
                    vw_email.isHidden = true
                    vw_emailHeight.constant = 0
                    email = "Email"
                }
            case 2:
                if btnRadioCustom.currentImage?.description.contains("radio-off-button") == true {
                    btnRadioCustom.setImage(UIImage(named: "radio-on-button"), for: .normal)
                    btnRadioNone.setImage(UIImage(named: "radio-off-button"), for: .normal)
                    btnRadioEmail.setImage(UIImage(named: "radio-off-button"), for: .normal)
                    vw_email.isHidden = false
                    vw_emailHeight.constant = 30
                    email = "Custom"
                }
            default:
                print("Default")
        }
    }
    
}

extension AddOrderVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCartList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblCartList.dequeueReusableCell(withIdentifier: "AddOrderCell", for: indexPath) as! AddOrderCell
 
        cell.model = arrCartList[indexPath.row]
        cell.setCell(index: indexPath.row)
        cell.delegate = self
        cell.parent = self
        cell.arrCartListCell = arrCartList
        cell.index = indexPath.row
        setServiceAndTotalAmt()
        return cell
    }
}

extension AddOrderVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}

extension AddOrderVC: AddOrderProtocol {
    func callServiceProviderAPI(serviceID: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["service_id": serviceID]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + GET_SERVICE_PROVIDER, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let provider = res.value(forKey: "Provider") as? [[String:Any]] {
                    self.arrServiceProvider.removeAll()
                    
                    for dict in provider {
                        self.arrServiceProvider.append(ProviderData(dict: dict))
                    }
                    
                    for item in self.arrServiceProvider {
                        self.arrServiceProviderIds.append("\(item.id)")
                    }
                }
            }
        }
    }
    
    func callOrderServiceAPI(clientId: Int, serviceId: Int, serviceProviderId: Int?=nil, startTime: String?=nil) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["clientId": clientId,
                  "serviceId": serviceId,
                  "serviceProvider": serviceProviderId ?? 0,
                  "time": startTime ?? ""
        ]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + ORDER_SERVICE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let serviceName = res.value(forKey: "serviceName") as? String {
                    self.item = serviceName
                }
                if let servicePrice = res.value(forKey: "servicePrice") as? String {
                    self.price = Float(servicePrice) ?? 0.00
                }
                if let serviceDiscount = res.value(forKey: "serviceDiscount") as? Float {
                    self.discount = serviceDiscount
                }
                if let servicePercentage = res.value(forKey: "servicePercentage") as? Float {
                    self.discountPercent = servicePercentage
                }
                if let serviceCommission = res.value(forKey: "serviceCommission") as? Int {
                    self.serviceCommissionAmt = serviceCommission
                }
                
                self.arrServiceIds.append("\(serviceId)")
                self.callServiceProviderAPI(serviceID: serviceId)
                self.arrServiceStartTime.append(startTime ?? "")
                
                self.dictService = CartList(item: self.item, qty: "--", price: self.price, tax: 0.00, discount: self.discount, discountPercent: self.discountPercent, totalPrice: self.price, showTax: false, selectedItem: "Service", serviceComissionAmt: self.serviceCommissionAmt)
                self.arrCartList.append(self.dictService)
                
                self.totalServicePrice = 0.00
                for i in self.arrCartList {
                    if i.selectedItem == "Service" {
                        self.totalServicePrice = self.totalServicePrice + i.price
                    }
                }
                self.setServiceAndTotalAmt(selectedItem: "Service")
                self.setShowHideCartView()
                DispatchQueue.main.async {
                    self.tblCartList.reloadData()
                }
            }
            if self.arrCartList.count == 0 {
                self.txtTipsValue1.isUserInteractionEnabled = false
                self.txtTipsValue2.isUserInteractionEnabled = false
            } else {
                self.txtTipsValue1.isUserInteractionEnabled = true
                self.txtTipsValue2.isUserInteractionEnabled = true
            }
        }
    }
    
    func callOrderProductAPI(productIds: String, arrSelectedProductIds: [String]) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["productId": productIds]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + ORDER_PRODUCT, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            self.arrAddProductIds = arrSelectedProductIds
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrOrderProduct.removeAll()
                            self.arrTitle.removeAll()
                            self.arrFinalIds.removeAll()
                            self.showProductAlert = false
                            for dict in response {
                                self.arrOrderProduct.append(OrderProduct(dict: dict))
                            }
                            
                            for dict in self.arrCartList {
                                for i in dict.productIds ?? [] {
                                    self.arrFinalIds.append(i)
                                }
                            }
                            self.arrFinalIds = self.arrFinalIds.uniqued()
                            for i in arrSelectedProductIds {
                                if self.arrFinalIds.contains(i) {
                                    for tit in self.arrOrderProduct {
                                        if "\(tit.productId)" == i {
                                            self.arrTitle.append(tit.productTitle)
                                            self.showProductAlert = true
                                        }
                                    }
                                }
                            }
                            
                            if self.showProductAlert {
                                self.showAlert(alertMainTitle: "Already Exist: " + self.arrTitle.joined(separator: ","), alertTitle: "" )
                            }
                            
                            if self.arrFinalIds.count == 0 {
                                for dic in self.arrOrderProduct {
                                    self.dictService = CartList(item: dic.productTitle, qty: "\(dic.productQuantity)", price: Float(dic.productPrice), tax: dic.tax_on_qty1, discount: Float(dic.productDiscount), discountPercent: Float(dic.productPercentage), totalPrice: Float(dic.productPrice) + dic.tax_on_qty1, showTax: true, selectedItem: "Product", productIds: self.arrAddProductIds, productCostPrice: dic.productCostPrice, productComissionAmt: dic.productCommission)
                                    self.arrCartList.append(self.dictService)
                                }
                            } else {
                                for dic in self.arrOrderProduct {
                                    if !self.arrFinalIds.contains("\(dic.productId)") {
                                        self.dictService = CartList(item: dic.productTitle, qty: "\(dic.productQuantity)", price: Float(dic.productPrice), tax: dic.tax_on_qty1, discount: Float(dic.productDiscount), discountPercent: Float(dic.productPercentage), totalPrice: Float(dic.productPrice) + dic.tax_on_qty1, showTax: true, selectedItem: "Product", productIds: self.arrAddProductIds, productCostPrice: dic.productCostPrice, productComissionAmt: dic.productCommission)
                                        self.arrCartList.append(self.dictService)
                                    }
                                }
                            }
                            
                            self.totalProductPrice = 0.00
                            for i in self.arrCartList {
                                if i.selectedItem == "Product" {
                                    self.totalProductPrice = self.totalProductPrice + i.totalPrice
                                }
                            }
                            self.setServiceAndTotalAmt(selectedItem: "Product")
                            self.setShowHideCartView()
                            self.productIds = productIds
                            DispatchQueue.main.async {
                                self.tblCartList.reloadData()
                            }
                            self.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        
                    }
                }
            }
            if self.arrCartList.count == 0 {
                self.txtTipsValue1.isUserInteractionEnabled = false
                self.txtTipsValue2.isUserInteractionEnabled = false
            } else {
                self.txtTipsValue1.isUserInteractionEnabled = true
                self.txtTipsValue2.isUserInteractionEnabled = true
            }
        }
    }
    
    func callOrderPackageAPI(packageId: Int, packageExpire: String, packageAmount: String, Noofvisit: String) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["packageId": packageId,
                  "packageExpire": packageExpire,
                  "packageAmount": packageAmount,
                  "Noofvisit": Noofvisit
        ]
        if (APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + ORDER_PACKAGE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let packageName =  res.value(forKey: "packageName") as? String {
                    self.item = packageName
                }
                if let packageAmount = res.value(forKey: "packageAmount") as? String {
                    self.price = Float(packageAmount) ?? 0.00
                }
                if let packageDiscount = res.value(forKey: "packageDiscount") as? Float {
                    self.discount = packageDiscount
                }
                if let packagepercentage = res.value(forKey: "packagepercentage") as? Float {
                    self.discountPercent = packagepercentage
                }
                if let packageCommission = res.value(forKey: "packageCommission") as? Int {
                    self.packageCommissionAmt = packageCommission
                }
                self.arrPackageIds.append("\(packageId)")
                if Noofvisit == "Unlimited" {
                    self.arrNoOfVisit.append("-1")
                } else {
                    self.arrNoOfVisit.append(Noofvisit)
                }
                self.arrPackageExpiryDate.append(packageExpire)
                self.dictService = CartList(item: self.item, qty: "--", price: self.price, tax: 0.00, discount: self.discount, discountPercent: self.discountPercent, totalPrice: self.price, showTax: false, selectedItem: "Package", packageComissionAmt: self.packageCommissionAmt)
                self.arrCartList.append(self.dictService)
                self.totalPackagePrice = 0.00
                for i in self.arrCartList {
                    if i.selectedItem == "Package" {
                        self.totalPackagePrice = self.totalPackagePrice + i.price
                    }
                }
                self.setServiceAndTotalAmt(selectedItem: "Package")
                self.setShowHideCartView()
                DispatchQueue.main.async {
                    self.tblCartList.reloadData()
                }
            }
            if self.arrCartList.count == 0 {
                self.txtTipsValue1.isUserInteractionEnabled = false
                self.txtTipsValue2.isUserInteractionEnabled = false
            } else {
                self.txtTipsValue1.isUserInteractionEnabled = true
                self.txtTipsValue2.isUserInteractionEnabled = true
            }
        }
    }
    
    func callOrderGiftAPI(clientId: Int, giftCardAmount: String) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["clientId": clientId,
                  "giftCardAmount": giftCardAmount
        ]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + ORDER_GIFT, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let selctedService =  res.value(forKey: "selctedService") as? String {
                    self.item = selctedService
                }
                if let selectedPrice = res.value(forKey: "selectedPrice") as? String {
                    self.price = Float(selectedPrice) ?? 0.00
                }
                
                self.dictService = CartList(item: self.item, qty: "--", price: self.price, tax: 0.00, discount: 0, discountPercent: 0.00, totalPrice: self.price, showTax: false, selectedItem: "Gift Card")
                self.arrCartList.append(self.dictService)
//                if self.arrCartList.count == 0 {
//                    self.dictService = CartList(item: self.item, qty: "--", price: self.price, tax: 0.00, discount: 0, discountPercent: 0.00, totalPrice: self.price, showTax: false, selectedItem: "Gift Card")
//                    self.arrCartList.append(self.dictService)
//                } else {
//                    for i in self.arrCartList {
//                        if i.selectedItem == "Gift Card" {
//                            self.showAlert(alertMainTitle: "", alertTitle: "Gift Card already added.")
//                        } else {
//                            self.dictService = CartList(item: self.item, qty: "--", price: self.price, tax: 0.00, discount: 0, discountPercent: 0.00, totalPrice: self.price, showTax: false, selectedItem: "Gift Card")
//                            self.arrCartList.append(self.dictService)
//                        }
//                    }
//                }
                
                self.totalGiftCardPrice = 0.00
                for i in self.arrCartList {
                    if i.selectedItem == "Gift Card" {
                        self.totalGiftCardPrice = self.totalGiftCardPrice + i.price
                    }
                }
                self.giftCardAdded = true
                self.setServiceAndTotalAmt(selectedItem: "Gift Card")
                self.setShowHideCartView()
                DispatchQueue.main.async {
                    self.tblCartList.reloadData()
                }
            }
            if self.arrCartList.count == 0 {
                self.txtTipsValue1.isUserInteractionEnabled = false
                self.txtTipsValue2.isUserInteractionEnabled = false
            } else {
                self.txtTipsValue1.isUserInteractionEnabled = true
                self.txtTipsValue2.isUserInteractionEnabled = true
            }
        }
    }
    
    func setServiceAndTotalAmt(selectedItem: String? = nil, totalAmt: Float? = nil, arrCart: [CartList]? = nil) {
        if totalAmt != nil {
            arrCartList = arrCart ?? [CartList]()
        }
        
        if totalServicePrice >= 0.00 {
            lblServicePrice.text = "$" + String(format:"%.02f",totalServicePrice)
        }
        if totalProductPrice >= 0.00 {
            lblProductPrice.text = "$" + String(format:"%.02f",totalProductPrice)
        }
        if totalPackagePrice >= 0.00 {
            lblPackagePrice.text = "$" + String(format:"%.02f",totalPackagePrice)
        }
        lblGiftCardPrice.text = "$" + String(format:"%.02f",totalGiftCardPrice)
        
        setChooseTipsValue(totalPrice: totalServicePrice + totalProductPrice + totalPackagePrice + totalGiftCardPrice)
        lblSalesTax.text = "$" + String(format: "%.02f", arrCartList.sum(\.tax))
        lblTotalAmount.text = "$" + String(format:"%.02f",arrCartList.sum(\.totalPrice) + (txtTipsValue1.text?.floatValue() ?? 0.00))
        
     /*   if totalAmt != nil {
            arrCartList = arrCart ?? [CartList]()
        }
        arrSetFromCart = arrCartList
        switch selectedItem {
            case "Service":
                for i in arrCartList {
                    if (i.item == self.dictService.item) {
                        arrSetFromCart = arrSetFromCart.filter{$0.selectedItem == selectedItem}
                        lblServicePrice.text = "$" + String(format:"%.02f",arrSetFromCart.sum(\.totalPrice))
                    } else {
                        lblServicePrice.text = "$" + String(format:"%.02f",0.00)
                    }
                }
            case "Product":
                for i in arrCartList {
                    if (i.item == self.dictService.item) {
                        arrSetFromCart = arrSetFromCart.filter{$0.selectedItem == selectedItem}
                        lblProductPrice.text = "$" + String(format:"%.02f",arrSetFromCart.sum(\.totalPrice))
                    } else {
                        lblProductPrice.text = "$" + String(format:"%.02f",0.00)
                    }
                }
            case "Package":
                for i in arrCartList {
                    if (i.item == self.dictService.item) {
                        arrSetFromCart = arrSetFromCart.filter{$0.selectedItem == selectedItem}
                        lblPackagePrice.text = "$" + String(format:"%.02f",arrSetFromCart.sum(\.totalPrice))
                    } else {
                        lblPackagePrice.text = "$" + String(format:"%.02f",0.00)
                    }
                }
            case "Gift Card":
                for i in arrCartList {
                    if (i.item == self.dictService.item) {
                        arrSetFromCart = arrSetFromCart.filter{$0.selectedItem == selectedItem}
                        lblGiftCardPrice.text = "$" + String(format:"%.02f",arrSetFromCart.sum(\.totalPrice))
                    } else {
                        lblGiftCardPrice.text = "$" + String(format:"%.02f",0.00)
                    }
                }
            default:
                print("Default")
        }          */
        
        
    }
}

extension AddOrderVC: UITextFieldDelegate {
 /*   func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            if textField == txtTipsValue1 {
//                let inputView = UIView(frame: .zero)
//                inputView.backgroundColor = UIColor.clear
//                inputView.isOpaque = false
//                txtTipsValue1.inputView = inputView
                
              //  txtTipsValue1.isEnabled = false
                if arrCartList.count == 0 {
                    txtTipsValue1.isUserInteractionEnabled = false
                } else {
                    txtTipsValue1.isUserInteractionEnabled = true
                    txtTipsValue1.isEnabled = true
                }
                return false
            } else if textField == txtTipsValue2 {
//                let inputView = UIView(frame: .zero)
//                inputView.backgroundColor = UIColor.clear
//                inputView.isOpaque = false
//                txtTipsValue2.inputView = inputView
                txtTipsValue2.isUserInteractionEnabled = false
             //   txtTipsValue2.isEnabled = false
                return false
            }
        
        return true
    }       */
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtTipsValue1 {
            if arrCartList.count != 0 {
                vw_chooseTipsHeight.constant = 30
                vw_tipsSeparatorTop.constant = 43
                vw_chooseTips.isHidden = false
                txtTipsValue1.isUserInteractionEnabled = true
            } else {
                vw_chooseTipsHeight.constant = 0
                vw_tipsSeparatorTop.constant = 5
                vw_chooseTips.isHidden = true
                txtTipsValue1.isUserInteractionEnabled = false
            }
        } else if textField == txtTipsValue2 {
            if arrCartList.count != 0 {
                vw_chooseTipsHeight.constant = 30
                vw_tipsSeparatorTop.constant = 43
                vw_chooseTips.isHidden = false
                txtTipsValue2.isUserInteractionEnabled = true
            } else {
                vw_chooseTipsHeight.constant = 0
                vw_tipsSeparatorTop.constant = 5
                vw_chooseTips.isHidden = true
                txtTipsValue2.isUserInteractionEnabled = false
            }
        } else if textField == txtEmail {
            vw_mainHeight.constant = 1500
        }
        txtChooseClient.resignFirstResponder()
        txtSelectPackage.resignFirstResponder()
        txtChooseTips.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtEmail {
            vw_mainHeight.constant = 1320
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == txtTipsValue1 {
            calculateTipsValueInPercent()
            setServiceAndTotalAmt()
        } else if textField == txtTipsValue2 {
            calculateTipsValue()
            setServiceAndTotalAmt()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtEmail.resignFirstResponder()
        txtTipsValue2.resignFirstResponder()
        txtTipsValue1.resignFirstResponder()
        return true
    }
}
