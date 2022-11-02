//
//  SelectPaymentTypeVC.swift
//  MySunless
//
//  Created by Daydream Soft on 18/04/22.
//

import UIKit
import iOSDropDown
import Alamofire
import PassKit

class SelectPaymentTypeVC: UIViewController {
    
    @IBOutlet var vw_mainView: UIView!
    @IBOutlet var vw_cashView: UIView!
    @IBOutlet var vw_cashViewHeight: NSLayoutConstraint! //230

    //230
    @IBOutlet var vw_chequeView: UIView!
    @IBOutlet var vw_cardStripView: UIView!
    @IBOutlet var vw_cardSquareView: UIView!
    @IBOutlet var vw_applePayView: UIView!
    @IBOutlet var vw_chequeViewHeight: NSLayoutConstraint!   //550
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var vw_cashRecivedAmount: UIView!
    @IBOutlet var txtCashRecivedAmount: UITextField!
    @IBOutlet var txtApplePayRecivedAmount: UITextField!
    @IBOutlet var txtApplePayRemark: UITextField!

    @IBOutlet var vw_chequeRecivedAmount: UIView!
    @IBOutlet var txtChequeRecivedAmount: UITextField!
    @IBOutlet var vw_ChequeNumber: UIView!
    @IBOutlet var txtChequeNumber: UITextField!
    @IBOutlet var vw_NameOfBank: UIView!
    @IBOutlet var txtNameOfBank: UITextField!
    @IBOutlet var vw_SubmitDate: UIView!
    @IBOutlet var txtSubmitDate: UITextField!
    @IBOutlet var vw_SelectChequeStatus: UIView!
    @IBOutlet var txtSelectChequeStatus: DropDown!
    
    @IBOutlet var vw_mainHeight: NSLayoutConstraint!   //950
    @IBOutlet var vw_cash: UIView!
    @IBOutlet var vw_cashHeight: NSLayoutConstraint!   //150
    @IBOutlet var vw_cheque: UIView!
    @IBOutlet var vw_chequeHeight: NSLayoutConstraint!    //470
    @IBOutlet var vw_cashTitle: UIView!
    @IBOutlet var vw_chequeTitle: UIView!
    @IBOutlet var btnSetUpCreditCardPaymentAPI: UIButton!
    
    @IBOutlet var vw_cardStripViewHeight: NSLayoutConstraint!
   
    @IBOutlet weak var vw_cardSquareViewHeight: NSLayoutConstraint!
    @IBOutlet var vw_applePayViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var vw_cardStripeHeight: NSLayoutConstraint!
    @IBOutlet weak var vw_cardStripe: UIView!
    @IBOutlet weak var vw_cardStripeTitle: UIView!
    @IBOutlet weak var vw_cardSquareTitle: UIView!
    //vw_cardStripHeight
    @IBOutlet weak var vw_cardSquare: UIView!
    
    @IBOutlet weak var vw_applePayTitle: UIView!
    @IBOutlet weak var vw_applePay: UIView!
    
    @IBOutlet weak var vw_cardSquareHeight: NSLayoutConstraint!
    @IBOutlet weak var vw_applePayHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnSetUpHeight: NSLayoutConstraint!
    @IBOutlet var vw_cashViewTopHeight: NSLayoutConstraint!
    @IBOutlet var vw_cardStripeViewTopHeight: NSLayoutConstraint!
    
    
    var orderId = Int()
    var showCash = false
    var showCardSqure = false
    var showCardStripe = false
    var showCheque = false
    var totalAmt = String()
    var showApplePay = false
    var selectedClientId = Int()
    var token = String()
    var email = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        setInitialHeight()
        hideKeyboardWhenTappedAround()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        callShowSquareAPI()
        callShowStripeDataAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppData.sharedInstance.showSCLAlert(alertMainTitle: "Information!", alertTitle: "Your order has been saved to 'Save for Later' section of Orderlist page. To continue your order, please payment now.")
    }
    
    //MARK:- UserDefined Functions
    func setInitially() {
        vw_cardSquareView.layer.borderWidth = 0.5
        vw_cardSquareView.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_cardSquareView.layer.cornerRadius = 12.0
        vw_cardStripView.layer.borderWidth = 0.5
        vw_cardStripView.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_cardStripView.layer.cornerRadius = 12.0
        vw_cashView.layer.borderWidth = 0.5
        vw_cashView.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_cashView.layer.cornerRadius = 12.0
        vw_chequeView.layer.borderWidth = 0.5
        vw_chequeView.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_chequeView.layer.cornerRadius = 12.0
        vw_applePayView.layer.borderWidth = 0.5
        vw_applePayView.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_applePayView.layer.cornerRadius = 12.0
        vw_cashRecivedAmount.layer.borderWidth = 0.5
        vw_cashRecivedAmount.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_cashRecivedAmount.layer.cornerRadius = 12.0
        vw_chequeRecivedAmount.layer.borderWidth = 0.5
        vw_chequeRecivedAmount.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_chequeRecivedAmount.layer.cornerRadius = 12.0
        vw_ChequeNumber.layer.borderWidth = 0.5
        vw_ChequeNumber.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_ChequeNumber.layer.cornerRadius = 12.0
        vw_NameOfBank.layer.borderWidth = 0.5
        vw_NameOfBank.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_NameOfBank.layer.cornerRadius = 12.0
        vw_SubmitDate.layer.borderWidth = 0.5
        vw_SubmitDate.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_SubmitDate.layer.cornerRadius = 12.0
        vw_SelectChequeStatus.layer.borderWidth = 0.5
        vw_SelectChequeStatus.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_SelectChequeStatus.layer.cornerRadius = 12.0
        vw_cashTitle.layer.cornerRadius = 12
        vw_cashTitle.layer.masksToBounds = true
        vw_cashTitle.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        vw_chequeTitle.layer.cornerRadius = 12
        vw_chequeTitle.layer.masksToBounds = true
        vw_chequeTitle.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        btnSetUpCreditCardPaymentAPI.layer.borderWidth = 0.5
        btnSetUpCreditCardPaymentAPI.layer.borderColor = UIColor.init("#15B0DA").cgColor
        btnSetUpCreditCardPaymentAPI.layer.cornerRadius = 12.0
        txtSubmitDate.delegate = self
        txtChequeNumber.delegate = self
        txtNameOfBank.delegate = self
        txtSelectChequeStatus.delegate = self
        lblAmount.text = totalAmt
        txtCashRecivedAmount.text = totalAmt.replacingOccurrences(of: "$", with: "")
        txtChequeRecivedAmount.text = totalAmt.replacingOccurrences(of: "$", with: "")
        txtApplePayRecivedAmount.text = totalAmt.replacingOccurrences(of: "$", with: "")
        txtApplePayRemark.text = "orderId -\(orderId)"
        txtSelectChequeStatus.optionArray = ["In Process (PROCESSING)", "Clear (CAPTURED)", "Bounce (FAILED)"]
        txtSelectChequeStatus.didSelect { selectedText, index, id in
            self.txtSelectChequeStatus.text = selectedText
            self.txtSelectChequeStatus.selectText = selectedText
        }
    }
    
    func setInitialHeight() {
        vw_cash.isHidden = true
        vw_cashHeight.constant = 0
        vw_cashViewHeight.constant = 80
        vw_cheque.isHidden = true
        vw_chequeHeight.constant = 0
        vw_chequeViewHeight.constant = 80
        vw_cardStripe.isHidden = true
        vw_cardStripeHeight.constant = 0
        vw_cardStripViewHeight.constant = 80
        vw_cardSquare.isHidden = true
        vw_cardSquareHeight.constant = 0
        vw_cardSquareViewHeight.constant = 80
        vw_applePay.isHidden = true
        vw_applePayHeight.constant = 0
        vw_applePayViewHeight.constant = 80
        btnSetUpHeight.constant = 40
        vw_mainHeight.constant = 850//330
    }
    
    func showCashView() {
        vw_cash.isHidden = false
        vw_cashHeight.constant = 150
        vw_cashViewHeight.constant = 230
        showCash = true
    }
    
    func hideCashView() {
        vw_cash.isHidden = true
        vw_cashHeight.constant = 0
        vw_cashViewHeight.constant = 80
        showCash = false
    }
    
    func showChequeView() {
        vw_cheque.isHidden = false
        vw_chequeHeight.constant = 470
        vw_chequeViewHeight.constant = 550
        showCheque = true
    }
    
    func hideChequeView() {
        vw_cheque.isHidden = true
        vw_chequeHeight.constant = 0
        vw_chequeViewHeight.constant = 80
        showCheque = false
    }
    
    func showCardSquareView() {
        vw_cardSquare.isHidden = false
        vw_cardSquareHeight.constant = 150
        vw_cardSquareViewHeight.constant = 230
        showCardSqure = true
    }
    
    func hideCardSquareView() {
        vw_cardSquare.isHidden = true
        vw_cardSquareHeight.constant = 0
        vw_cardSquareViewHeight.constant = 80
        showCardSqure = false
    }
    
    func showCardStripeView() {
        vw_cardStripe.isHidden = false
        vw_cardStripeHeight.constant = 150
        vw_cardStripViewHeight.constant = 230
        showCardStripe = true
    }
    
    func hideCardStripeView() {
        vw_cardStripe.isHidden = true
        vw_cardStripeHeight.constant = 0
        vw_cardStripViewHeight.constant = 80
        showCardStripe = false
    }
    
    func showApplePayView() {
        vw_applePay.isHidden = false
        vw_applePayHeight.constant = 220
        vw_applePayViewHeight.constant = 300
        showApplePay = true
    }
    
    func hideApplePayView() {
        vw_applePay.isHidden = true
        vw_applePayHeight.constant = 0
        vw_applePayViewHeight.constant = 80
        showApplePay = false
    }
   
    func setMainViewHeight() {
//        if (showCash == true && showCheque == true) {
//            vw_mainHeight.constant = 980
//        } else if (showCash == true && showCheque == false) {
//            vw_mainHeight.constant = 2000//480
//        } else if (showCash == false && showCheque == true) {
//            vw_mainHeight.constant = 2000//800
//        } else if (showCash == false && showCheque == false) {
//            vw_mainHeight.constant = 2000//330
//        } else if (showCardSqure == true && showCheque == false) {
//            vw_mainHeight.constant = 2000//330
//        } else if (showCardStripe == true && showCheque == false) {
//            vw_mainHeight.constant = 2000//330
//        } else if (showApplePay == true && showCheque == false) {
//            vw_mainHeight.constant = 2000//330
//        } else {
//            vw_mainHeight.constant = 2000
//        }
        var  height: Double = 650
        
        vw_mainHeight.constant = height + vw_cashHeight.constant + vw_applePayHeight.constant + vw_cardStripeHeight.constant +
        vw_cardSquareHeight.constant + vw_chequeHeight.constant
      
        
    }
    
    func setValidation() -> Bool {
        if txtChequeNumber.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter Cheque number", viewController: self)
        } else if txtNameOfBank.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please enter name of bank", viewController: self)
        } else if txtSubmitDate.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please select Cheque submit date", viewController: self)
        } else if txtSelectChequeStatus.text == "" {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please select cheque status", viewController: self)
        } else {
            return true
        }
        return false
    }
    
    func applePayAlert(PaymentTitle: String, paymentAmount: String) {
        let paymentNetworks = [PKPaymentNetwork.amex, .discover, .masterCard, .visa]
        let paymentItem = PKPaymentSummaryItem.init(label: PaymentTitle, amount: NSDecimalNumber(string:paymentAmount))
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            let request = PKPaymentRequest()
            request.currencyCode = currencyCode
            request.countryCode = countryCode
            request.merchantIdentifier = merchantId
            request.merchantCapabilities = PKMerchantCapability.capability3DS
            request.supportedNetworks = paymentNetworks
            request.paymentSummaryItems = [paymentItem]
            guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: request)
            else {
                AppData.sharedInstance.showSCLAlert(alertMainTitle: "Error", alertTitle: "Unable to present Apple Pay authorization.")
                return
            }
            paymentVC.delegate = self
            self.present(paymentVC, animated: true, completion: nil)
            
        } else {
            AppData.sharedInstance.showSCLAlert(alertMainTitle: "Error", alertTitle: "Unable to make Apple Pay transaction.")
        }
    }
    
    func callCashPaymentAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["orderid": orderId,
                  "orderdate": Date.getCurrentDate(),
                  "clientId": selectedClientId,
                  "amount": totalAmt.replacingOccurrences(of: "$", with: "")
        ]
        if (APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + CASH_PAYMENT, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? String {
                            print(response)
                            if self.email != "" {
                                self.callOrderInvoiceMailAPI(email: self.email, orderId: self.orderId)
                            }
                            let VC = self.storyboard?.instantiateViewController(withIdentifier: "OrderListVC") as! OrderListVC
                            self.navigationController?.pushViewController(VC, animated: true)
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            print(response)
                        }
                    }
                }
            }
        }
    }
    
    func callCheqPaymentAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["amount": totalAmt.replacingOccurrences(of: "$", with: ""),
                  "cheque_no": txtChequeNumber.text ?? "",
                  "name_of_bank": txtNameOfBank.text ?? "",
                  "submit_date": txtSubmitDate.text ?? "",
                  "Cid": selectedClientId,
                  "cheque_status": txtSelectChequeStatus.text ?? "",
                  "orderid": orderId
        ]
        if (APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + CHEQUE_PAYMENT, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let message = res.value(forKey: "message") as? String {
                            print(message)
                            if self.email != "" {
                                self.callOrderInvoiceMailAPI(email: self.email, orderId: self.orderId)
                            }
                            let VC = self.storyboard?.instantiateViewController(withIdentifier: "OrderListVC") as! OrderListVC
                            self.navigationController?.pushViewController(VC, animated: true)
                        }
                    } else {
                        if let message = res.value(forKey: "message") as? String {
                            print(message)
                        }
                    }
                }
            }
        }
    }
    
    func callOrderInvoiceMailAPI(email: String, orderId: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["clientemail": email,
                  "OrderId": orderId
        ]
        if (APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + ORDER_INVOICE_MAIL, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "sucess") as? Int {
                    if success == 1 {
                        if let message = res.value(forKey: "message") as? String {
                            print(message)
                        }
                    } else {
                        if let message = res.value(forKey: "message") as? String {
                            print(message)
                        }
                    }
                }
            }
        }
    }
    
    func callShowSquareAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = [:]
        if (APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_SQUARE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let message = res.value(forKey: "response") as? String {
                            // code show square option
                            self.btnSetUpHeight.constant = 0
                            self.vw_cardSquareViewHeight.constant = 80
                            self.vw_cardSquareView.isHidden = false
                            self.btnSetUpCreditCardPaymentAPI.isHidden = true
                            self.setMainViewHeight()
                           
                        }
                    } else {
                        if let message = res.value(forKey: "response") as? String {
                            print(message)
                            self.btnSetUpHeight.constant = 40
                            self.vw_cardSquareViewHeight.constant = 0.0;                         self.vw_cardSquareView.isHidden = true
                            self.btnSetUpCreditCardPaymentAPI.isHidden = false
                            self.setMainViewHeight()
                        }
                    }
                }
            }
        }
    }
    
    func callShowStripeDataAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = [:]
        if (APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_STRIPE_DATA, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let message = res.value(forKey: "response") as? String {
                            // code show stripe option
                            self.btnSetUpHeight.constant = 0
                            self.vw_cardStripViewHeight.constant = 80
                            self.vw_cardStripView.isHidden = false
                            self.btnSetUpCreditCardPaymentAPI.isHidden = true
                            self.setMainViewHeight()
                           
                        }
                    } else {
                        if let message = res.value(forKey: "response") as? String {
                            print(message)
                            self.vw_cashViewTopHeight.constant = 0
                            self.btnSetUpHeight.constant = 40
                            self.vw_cardStripViewHeight.constant = 0
                            self.vw_cardStripView.isHidden = true
                            self.btnSetUpCreditCardPaymentAPI.isHidden = false
                            self.setMainViewHeight()
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SetupCreditCardPaymentAPIClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentSetupVC") as! PaymentSetupVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func CashClick(_ sender: UIButton) {
        if sender.isSelected {
            hideCashView()
            sender.isSelected = !sender.isSelected
        } else {
            showCashView()
            sender.isSelected = !sender.isSelected
        }
        setMainViewHeight()
    }
    
    @IBAction func btnCashSubmitClick(_ sender: UIButton) {
        callCashPaymentAPI()
    }
    
    @IBAction func btnChequeSubmitClick(_ sender: UIButton) {
        if setValidation() {
            callCheqPaymentAPI()
        }
    }
    
    @IBAction func btnCardSquareSubmitClick(_ sender: UIButton) {
        
    }
    
    @IBAction func btnCardStripeSubmitClick(_ sender: UIButton) {
        
    }
    
    @IBAction func btnApplePaySubmitClick(_ sender: UIButton) {
        applePayAlert(PaymentTitle: txtApplePayRemark.text ?? "No Remark", paymentAmount: txtApplePayRecivedAmount.text ?? "0.0")
    }
    
    @IBAction func ChequeClick(_ sender: UIButton) {
        if sender.isSelected {
            hideChequeView()
            sender.isSelected = !sender.isSelected
        } else {
            showChequeView()
            sender.isSelected = !sender.isSelected
        }
        setMainViewHeight()
    }
    
    @IBAction func CardSquareClick(_ sender: UIButton) {
        if sender.isSelected {
            hideCardSquareView()
            sender.isSelected = !sender.isSelected
        } else {
            showCardSquareView()
            sender.isSelected = !sender.isSelected
        }
        setMainViewHeight()
    }
    
    @IBAction func CardStripeClick(_ sender: UIButton) {
        if sender.isSelected {
           hideCardStripeView()
            sender.isSelected = !sender.isSelected
        } else {
            showCardStripeView()
            sender.isSelected = !sender.isSelected
        }
        setMainViewHeight()
    }
    
    @IBAction func CardApplePayClick(_ sender: UIButton) {
        if sender.isSelected {
            hideApplePayView()
            sender.isSelected = !sender.isSelected
        } else {
            showApplePayView()
            sender.isSelected = !sender.isSelected
        }
        setMainViewHeight()
    }
    
    @objc func handleFromDate() {
        if let datePicker = self.txtSubmitDate.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            txtSubmitDate.text = dateFormatter.string(from: datePicker.date)
        }
        self.txtSubmitDate.resignFirstResponder()
    }
    
}

extension SelectPaymentTypeVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        txtSelectChequeStatus.resignFirstResponder()
        txtSubmitDate.setInputViewDatePicker(target: self, selector: #selector(handleFromDate))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtChequeNumber.resignFirstResponder()
        txtNameOfBank.resignFirstResponder()
        return true
    }
}

extension SelectPaymentTypeVC: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        dismiss(animated: true, completion: nil)
        print("payment ::\(payment.token)")
        AppData.sharedInstance.showSCLAlert(alertMainTitle: "Success", alertTitle: "The Apple Pay transaction was complete")
        if self.email != "" {
            self.callOrderInvoiceMailAPI(email: self.email, orderId: self.orderId)
        }
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "OrderListVC") as! OrderListVC
        self.navigationController?.pushViewController(VC, animated: true)
      }
    
    
}
