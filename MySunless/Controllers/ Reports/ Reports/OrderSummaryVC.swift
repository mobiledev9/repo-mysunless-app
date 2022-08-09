//
//  Order SummaryVC.swift
//  MySunless
//
//  Created by Daydream Soft on 08/04/22.
//

import UIKit
import iOSDropDown
import Alamofire

class OrderSummaryVC: UIViewController {

    @IBOutlet var vw_orderPriceData: UIView!
    @IBOutlet var vw_cartList: UIView!
    @IBOutlet var lblServicePrice: UILabel!
    @IBOutlet var lblGiftCardPrice: UILabel!
    @IBOutlet var lblProductPrice: UILabel!
    @IBOutlet var lblPackagePrice: UILabel!
    @IBOutlet var lblGiftCardApplied: UILabel!
    @IBOutlet var lblTips: UILabel!
    @IBOutlet var tblCartList: UITableView!
    @IBOutlet var lblSalesTax: UILabel!
    @IBOutlet var lblTotalAmount: UILabel!
    @IBOutlet var btnApplyGiftCardBalance: UIButton!
    @IBOutlet var btnApplyGiftCardBalanceTop: NSLayoutConstraint!   //10
    @IBOutlet var btnApplyGiftCardBalanceHeight: NSLayoutConstraint!    //35
    @IBOutlet var lblApplyGiftCardBalance: UILabel!
    @IBOutlet var vw_enterAmount: UIView!
    @IBOutlet var vw_enterAmountTop: NSLayoutConstraint!   //55
    @IBOutlet var vw_enterAmountHeight: NSLayoutConstraint!     //35
    @IBOutlet var txtEnterAmount: UITextField!
    @IBOutlet var btnApply: UIButton!
    @IBOutlet var btnApplyHeight: NSLayoutConstraint!      //35
    @IBOutlet var btnApplyHeightWidth: NSLayoutConstraint!   //100
    @IBOutlet var btnConfirmOrderTop: NSLayoutConstraint!   //145
    
    var token = String()
    var arrShowCartList = [CartList]()
    var servicePrice = String()
    var giftCardPrice = String()
    var productPrice = String()
    var packagePrice = String()
    var tips = String()
    var tipsInFloat = Float()
    var salesTax = String()
    var totalAmt = Float()
    var total = String()
    var selectedClientId = Int()
    var giftCardApplied = Float()
    var savedGiftCard = Float()
    
    var arrServiceIds = [String]()
    var arrServiceProviderIds = [String]()
    var arrServiceStartTime = [String]()
    var arrServiceStartDate = [String]()
    var arrServicePrice = [String]()
    var arrServiceDiscount = [String]()
    var arrServiceDiscoutInParentage = [String]()
    var arrServiceFianlPrice = [String]()
    var productIds = String()
    var arrProdcutQuality = [String]()
    var arrProductPrice = [String]()
    var arrProductTaxPrice = [String]()
    var arrProductDiscount = [String]()
    var arrProductDiscountInParentage = [String]()
    var arrProductFianlPrice = [String]()
    var arrProductCostPrice = [String]()
    var arrMembershipIds = [String]()
    var arrMembershipPrice = [String]()
    var arrMembershipDiscount = [String]()
    var arrMemberDiscoutInParentage = [String]()
    var arrMembershipFianlPrice = [String]()
    var arrNoofvisit = [String]()
    var arrPackageExpireDate = [String]()
    var gServiceName = String()
    var gServicePrice = String()
    var gServiceDiscount = String()
    var gServiceDiscoutInParentage = String()
    var gServiceFianlPrice = String()
    var arrServiceCommissionAmt = [String]()
    var arrProductCommissionAmt = [String]()
    var arrpackageCommissionAmt = [String]()
    var email = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setInitially()
        setValues()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callGiftCardBalAPI()
    }

    func setInitially() {
        vw_orderPriceData.layer.borderWidth = 1.0
        vw_orderPriceData.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_orderPriceData.layer.cornerRadius = 10.0
        vw_cartList.layer.borderWidth = 1.0
        vw_cartList.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_cartList.layer.cornerRadius = 10.0
        vw_enterAmount.layer.borderWidth = 0.5
        vw_enterAmount.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_enterAmount.layer.cornerRadius = 10.0
        btnApplyGiftCardBalance.layer.borderWidth = 1.0
        btnApplyGiftCardBalance.layer.borderColor = UIColor.init("#15B0DA").cgColor
        btnApplyGiftCardBalance.layer.cornerRadius = 10.0
        txtEnterAmount.delegate = self
        
        total = total.replacingOccurrences(of: "$", with: "", options: NSString.CompareOptions.literal, range: nil)
        totalAmt = total.floatValue() ?? 0.00
        
        for i in arrShowCartList {
            if i.selectedItem == "Service" {
                arrServicePrice.append(String(format: "%.02f", i.price))
                arrServiceDiscount.append(String(format: "%.02f", i.discount))
                arrServiceDiscoutInParentage.append(String(format: "%.02f", i.discountPercent))
                arrServiceFianlPrice.append(String(format: "%.02f", i.totalPrice))
                arrServiceCommissionAmt.append("\(i.serviceComissionAmt ?? 0)")
            } else if i.selectedItem == "Product" {
                arrProdcutQuality.append(i.qty)
                arrProductPrice.append(String(format: "%.02f", i.price))
                arrProductCostPrice.append("\(i.productCostPrice ?? 0)")
                arrProductTaxPrice.append(String(format: "%.02f", i.tax))
                arrProductDiscount.append(String(format: "%.02f", i.discount))
                arrProductDiscountInParentage.append(String(format: "%.02f", i.discountPercent))
                arrProductFianlPrice.append(String(format: "%.02f", i.totalPrice))
                arrProductCommissionAmt.append("\(i.productComissionAmt ?? 0)")
            } else if i.selectedItem == "Package" {
                arrMembershipPrice.append(String(format: "%.02f", i.price))
                arrMembershipDiscount.append(String(format: "%.02f", i.discount))
                arrMemberDiscoutInParentage.append(String(format: "%.02f", i.discountPercent))
                arrMembershipFianlPrice.append(String(format: "%.02f", i.totalPrice))
                arrpackageCommissionAmt.append("\(i.packageComissionAmt ?? 0)")
            } else if i.selectedItem == "Gift Card" {
                gServiceName = i.item
                gServicePrice = String(format: "%.02f", i.price)
                gServiceDiscount = String(format: "%.02f", i.discount)
                gServiceDiscoutInParentage = String(format: "%.02f", i.discountPercent)
                gServiceFianlPrice = String(format: "%.02f", i.totalPrice)
            }
        }
    }
    
    func setValues() {
        lblServicePrice.text = servicePrice
        lblGiftCardPrice.text = giftCardPrice
        lblProductPrice.text = productPrice
        lblPackagePrice.text = packagePrice
        tipsInFloat = tips.floatValue() ?? 0.00
        lblTips.text = "$" + String(format: "%.02f", tipsInFloat)
        lblSalesTax.text = salesTax
        lblTotalAmount.text = "$" + "\(totalAmt)"
    }
    
    func setNoGiftCardHeight() {
        btnApplyGiftCardBalance.isHidden = true
        btnApplyGiftCardBalanceHeight.constant = 0
        lblApplyGiftCardBalance.isHidden = true
        vw_enterAmount.isHidden = true
        vw_enterAmountHeight.constant = 0
        btnApply.isHidden = true
        btnApplyHeight.constant = 0
        btnConfirmOrderTop.constant = 100
    }
    
    func setGiftCardHeight() {
        btnApplyGiftCardBalance.isHidden = false
        btnApplyGiftCardBalanceHeight.constant = 40
        lblApplyGiftCardBalance.isHidden = false
        btnApplyGiftCardBalanceTop.constant = 20
        vw_enterAmount.isHidden = true
        vw_enterAmountHeight.constant = 0
        btnApply.isHidden = true
        btnApplyHeight.constant = 0
        btnConfirmOrderTop.constant = 100
    }
    
    func enterGiftCardAmt() {
        vw_enterAmount.isHidden = false
        vw_enterAmountHeight.constant = 35
        vw_enterAmountTop.constant = 20
        btnApply.isHidden = false
        btnApplyHeight.constant = 35
        btnApplyGiftCardBalance.isHidden = true
        btnApplyGiftCardBalanceHeight.constant = 0
        lblApplyGiftCardBalance.isHidden = true
        btnConfirmOrderTop.constant = 120
    }
    
    func setValidationForEnterAmt() -> Bool {
        if txtEnterAmount.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter amount", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func callGiftCardBalAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["clientId": selectedClientId]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + GIFT_CARD_BAL, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? Int {
                            self.savedGiftCard = Float(response)
                            self.lblApplyGiftCardBalance.text = "Apply Gift Card Balance" + " " + "($\(self.savedGiftCard))"
                            self.setGiftCardHeight()
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            print(response)
                            self.setNoGiftCardHeight()
                        }
                    }
                }
            }
        }
    }
    
    func callOrderBookAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["cid": selectedClientId,
                  "eid": "",
                  "pservicepackage": "",
                  "pservicename": "",
                  "pvisit": "",
                  "ServiceName": arrServiceIds.joined(separator: ","),
                  "ServicProvider": arrServiceProviderIds.joined(separator: ","),
                  "ServiceDate": arrServiceStartDate.joined(separator: ","),
                  "servicetime": arrServiceStartTime.joined(separator: ","),
                  "ServicePrice": arrServicePrice.joined(separator: ","),
                  "ServiceDiscount": arrServiceDiscount.joined(separator: ","),
                  "ServiceDiscoutInParentage": arrServiceDiscoutInParentage.joined(separator: ","),
                  "ServiceFianlPrice": arrServiceFianlPrice.joined(separator: ","),
                  "ProdcutName": productIds,
                  "ProdcutQuality": arrProdcutQuality.joined(separator: ","),
                  "ProductPrice": arrProductPrice.joined(separator: ","),
                  "ProductCostPrice": arrProductCostPrice.joined(separator: ","),
                  "ProductTaxPrice": arrProductTaxPrice.joined(separator: ","),
                  "ProductDiscount": arrProductDiscount.joined(separator: ","),
                  "ProductDiscountInParentage": arrProductDiscountInParentage.joined(separator: ","),
                  "ProductFianlPrice": arrProductFianlPrice.joined(separator: ","),
                  "MembershipName": arrMembershipIds.joined(separator: ","),
                  "MembershipPrice": arrMembershipPrice.joined(separator: ","),
                  "MembershipDiscount": arrMembershipDiscount.joined(separator: ","),
                  "MemberDiscoutInParentage": arrMemberDiscoutInParentage.joined(separator: ","),
                  "MembershipFianlPrice": arrMembershipFianlPrice.joined(separator: ","),
                  "Noofvisit": arrNoofvisit.joined(separator: ","),
                  "package_expire_date": arrPackageExpireDate.joined(separator: ","),
                  "gServiceName": gServiceName,
                  "gServicePrice": gServicePrice,
                  "gServiceDiscount": gServiceDiscount,
                  "gServiceDiscoutInParentage": gServiceDiscoutInParentage,
                  "gServiceFianlPrice": gServiceFianlPrice,
                  "TotalgiftAmount": giftCardPrice,
                  "TotalOrderAmount": totalAmt,
                  "TotalseriveAmount": servicePrice,
                  "TotalProductAmount": productPrice,
                  "TotalMembershipAmount": packagePrice,
                  "GetTotalPoint": 0,
                  "UsePoint": 0,
                  "giftapp": giftCardApplied,
                  "sales_tax": salesTax.replacingOccurrences(of: "$", with: ""),
                  "payment_status": "PENDING",
                  "tips": tips,
                  "serCommissionAmount": arrServiceCommissionAmt.joined(separator: ","),
                  "proCommissionAmount": arrProductCommissionAmt.joined(separator: ","),
                  "memCommissionAmount": arrpackageCommissionAmt.joined(separator: ",")
        ]
        
        if (APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + ORDER_BOOK, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let Message = res.value(forKey: "Message") as? String {
                            print(Message)
                        }
                        if let orderid = res.value(forKey: "orderid") as? Int {
                            let VC = self.storyboard?.instantiateViewController(withIdentifier: "SelectPaymentTypeVC") as! SelectPaymentTypeVC
                            VC.orderId = orderid
                            VC.totalAmt = self.lblTotalAmount.text ?? ""
                            VC.selectedClientId = self.selectedClientId
                            VC.email = self.email
                            self.navigationController?.pushViewController(VC, animated: true)
                        }
                    } else {
                        if let Message = res.value(forKey: "Message") as? String {
                            print(Message)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnApplyGiftCardBalanceClick(_ sender: UIButton) {
        enterGiftCardAmt()
    }
    
    @IBAction func btnApplyClick(_ sender: UIButton) {
        if btnApply.titleLabel?.text == "Apply" {
            if setValidationForEnterAmt() {
                giftCardApplied = txtEnterAmount.text?.floatValue() ?? 0.00
                if giftCardApplied > savedGiftCard {
                    AppData.sharedInstance.showSCLAlert(alertMainTitle: "Sorry!", alertTitle: "Amount is greater than Gift-Balance")
                } else {
                    giftCardApplied = txtEnterAmount.text?.floatValue() ?? 0.00
                    lblGiftCardApplied.text = "$" + String(format: "%.02f", giftCardApplied)
                    vw_enterAmount.isHidden = true
                    vw_enterAmountHeight.constant = 0
                    btnApply.setTitle("Remove Gift Card", for: .normal)
                    btnApply.layer.backgroundColor = UIColor.init("#E95268").cgColor
                    btnApplyHeightWidth.constant = 200
                    totalAmt = totalAmt - Float(giftCardApplied)
                    setValues()
                }
            }
        } else if btnApply.titleLabel?.text == "Remove Gift Card" {
            setGiftCardHeight()
            lblGiftCardApplied.text = "$0.00"
            btnApply.setTitle("Apply", for: .normal)
            btnApply.layer.backgroundColor = UIColor.init("#15B0DA").cgColor
            btnApplyHeightWidth.constant = 100
            totalAmt = totalAmt + Float(giftCardApplied)
            setValues()
        }
    }
    
    @IBAction func btnConfirmOrderClick(_ sender: UIButton) {
        callOrderBookAPI()
    }
    
    @IBAction func btnSaveForLaterClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "OrderListVC") as! OrderListVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnBackToOrderClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension OrderSummaryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrShowCartList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblCartList.dequeueReusableCell(withIdentifier: "OrderSummaryCell", for: indexPath) as! OrderSummaryCell
        
        cell.model = arrShowCartList[indexPath.row]
        cell.setCell(index: indexPath.row)
        
        return cell
    }
    
    
}

extension OrderSummaryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}

extension OrderSummaryVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtEnterAmount.resignFirstResponder()
    }
}
