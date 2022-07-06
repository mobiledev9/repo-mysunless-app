//
//  SubscriptionPackageVC.swift
//  MySunless
//
//  Created by iMac on 27/05/22.
//

import UIKit
import StoreKit
import SwiftyStoreKit
import Toast_Swift
import Alamofire

struct PendingRenewalInfo {
    let auto_renew_product_id: Int
    let auto_renew_status: Int
    let original_transaction_id: Int
    let product_id: Int
    
    init(dict: [String:Any]) {
        self.auto_renew_product_id = dict["auto_renew_product_id"] as? Int ?? 0
        self.auto_renew_status = dict["auto_renew_status"] as? Int ?? 0
        self.original_transaction_id = dict["original_transaction_id"] as? Int ?? 0
        self.product_id = dict["product_id"] as? Int ?? 0
    }
}

struct InApp {
    let expires_date: String
    let expires_date_ms: Int
    let expires_date_pst: String
    let in_app_ownership_type: String
    let is_in_intro_offer_period: Bool
    let is_trial_period: Bool
    let original_purchase_date: String
    let original_purchase_date_ms: Int
    let original_purchase_date_pst: String
    let original_transaction_id: Int
    let product_id: Int
    let purchase_date: String
    let purchase_date_ms: Int
    let purchase_date_pst: String
    let quantity: Int
    let transaction_id: String
    let web_order_line_item_id: Int
    
    init(dict: [String:Any]) {
        self.expires_date = dict["expires_date"] as? String ?? ""
        self.expires_date_ms = dict["expires_date_ms"] as? Int ?? 0
        self.expires_date_pst = dict["expires_date_pst"] as? String ?? ""
        self.in_app_ownership_type = dict["in_app_ownership_type"] as? String ?? ""
        self.is_in_intro_offer_period = dict["is_in_intro_offer_period"] as? Bool ?? Bool()
        self.is_trial_period = dict["is_trial_period"] as? Bool ?? Bool()
        self.original_purchase_date = dict["original_purchase_date"] as? String ?? ""
        self.original_purchase_date_ms = dict["original_purchase_date_ms"] as? Int ?? 0
        self.original_purchase_date_pst = dict["original_purchase_date_pst"] as? String ?? ""
        self.original_transaction_id = dict["original_transaction_id"] as? Int ?? 0
        self.product_id = dict["product_id"] as? Int ?? 0
        self.purchase_date = dict["purchase_date"] as? String ?? ""
        self.purchase_date_ms = dict["purchase_date_ms"] as? Int ?? 0
        self.purchase_date_pst = dict["purchase_date_pst"] as? String ?? ""
        self.quantity = dict["quantity"] as? Int ?? 0
        self.transaction_id = dict["transaction_id"] as? String ?? ""
        self.web_order_line_item_id = dict["web_order_line_item_id"] as? Int ?? 0
    }
}

class SubscriptionPackageVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var vw_main: UIView!
    @IBOutlet var vw_top: UIView!
    @IBOutlet var vw_bottom: UIView!
    @IBOutlet var vw_searchbar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblSubscription: UITableView!
    @IBOutlet weak var btnRestore: UIButton!
    
    // Receipt Validation Url
    #if DEBUG
    let verifyReceiptURL = "https://sandbox.itunes.apple.com/verifyReceipt"
    #else
   // let verifyReceiptURL = "https://buy.itunes.apple.com/verifyReceipt"
    #endif
    
    //MARK:- Variable Declarations
    var iapProducts = [SKProduct]()
    var arr:NSMutableArray = NSMutableArray()
    var productID = String()
    var selectedSubScription = Int()
    var isSubscribed = Bool()
    
    var productsIds = ["32323232"]
    var token = String()
    var arrPendingRenewal = [PendingRenewalInfo]()
    var arrInApp = [InApp]()
    
    var packageName = String()
    var expiryDate = String()
    var purchaseDate = String()
    var invoiceID = String()
    var userID = Int()
    var status = "InActive"
    var amount = String()
    var packageDesc = String()
    var packagetype = String()
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        userID = UserDefaults.standard.value(forKey: "userid") as? Int ?? 0
        
        SwiftyStoreKit.fetchReceipt(forceRefresh: true) { result in
            switch result {
            case .success(let receiptData):
                let encryptedReceipt = receiptData.base64EncodedString(options: [])
                print("Fetch receipt success:\n\(result)")
            case .error(let error):
                print("Fetch receipt failed: \(error)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "currentSubscription") == true {
            isSubscribed = true
        } else {
            isSubscribed = false
        }
        DispatchQueue.main.async {
            self.tblSubscription.reloadData()
        }
    }
    
    //MARK:- User-Defined Funstions
    func setInitially() {
        vw_top.layer.cornerRadius = 12
        vw_top.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        vw_bottom.layer.cornerRadius = 12
        vw_bottom.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        tblSubscription.tableFooterView = UIView()
        btnRestore.layer.cornerRadius = 12
        btnRestore.isHidden = true
    }
    
    func checkIfPurchaed(productId: String) {
        let appleValidator = AppleReceiptValidator(service: .sandbox, sharedSecret: "d223e7df9689472295a6d7a62e8864ba")
        AppData.sharedInstance.showLoader()
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                // Verify the purchase of a Subscription
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable, //or .nonRenewing
                    productId: productId,
                    inReceipt: receipt)

                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    AppData.sharedInstance.dismissLoader()
                    UserDefaults.standard.setValue(true, forKey: "currentSubscription")
                    self.isSubscribed = true
                    self.tblSubscription.reloadData()
                    print("\(productId) is valid until \(expiryDate)\n\(items)\n")
                case .expired(let expiryDate, let items):
                    AppData.sharedInstance.dismissLoader()
                    UserDefaults.standard.setValue(false, forKey: "currentSubscription")
                    self.isSubscribed = false
                    self.tblSubscription.reloadData()
                    print("\(productId) is expired since \(expiryDate)\n\(items)\n")
                case .notPurchased:
                    AppData.sharedInstance.dismissLoader()
                    UserDefaults.standard.setValue(false, forKey: "currentSubscription")
                    self.isSubscribed = false
                    self.tblSubscription.reloadData()
                    print("The user has never purchased \(productId)")
                }

            case .error(let error):
                AppData.sharedInstance.dismissLoader()
                print("Receipt verification failed: \(error)")
            }
        }

    }
    
    func callPurchaseAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["Packageid": productID,
                  "Name": packageName,
                  "Expirydate": expiryDate,
                  "Purchasedate": purchaseDate,
                  "Invoiceid": invoiceID,
                  "Userid": userID,
                  "status": status,
                  "promocodeid": "",
                  "amount": amount,
                  "Desc": packageDesc,
                  "packagetype": packagetype
        ]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + IN_APP_PURCHASE, param: params, header: headers) { respnse, error in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
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

    //MARK:- Actions
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnPurchaseClick(_ sender: UIButton) {
      //  buyProduct(iapProducts[sender.tag])
        if(AppData.sharedInstance.isConnectedToNetwork()){
            AppData.sharedInstance.showLoader()
            
            productID = productsIds[sender.tag]
            checkIfPurchaed(productId: productID)
            SwiftyStoreKit.purchaseProduct(productID, quantity: 1, atomically: true) { result in
                    switch result {
                    case .success(let product):
                        // fetch content from your server, then:
                        if product.needsFinishTransaction {
                            SwiftyStoreKit.finishTransaction(product.transaction)
                        }
                        print("Purchase Success: \(product.productId)")
                        
                        let appleValidator = AppleReceiptValidator(service: .sandbox, sharedSecret: "d223e7df9689472295a6d7a62e8864ba")
                        
                        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
                            if case .success(let receipt) = result {
                             //   self.savePurchaseToDefault(planId: self.selectedPlan)
                                AppData.sharedInstance.dismissLoader()
                                self.view.makeToast("Purchased Successfully")
                                print("Purchased Successfully")
                                print("Verify receipt success: \(receipt)")
                                
                                self.status = "Active"
                                
                                if let pending_renewal_info = receipt["pending_renewal_info"] as? [[String:Any]] {
                                    print("pending_renewal_info:- ",pending_renewal_info)
                                    self.arrPendingRenewal.removeAll()
                                    for dict in pending_renewal_info {
                                        self.arrPendingRenewal.append(PendingRenewalInfo(dict: dict))
                                    }
                                    print("arrPendingRenewal:-", self.arrPendingRenewal)
                                }
                                
                                if let receipt = receipt["receipt"] as? NSDictionary {
                                    if let in_app = receipt.value(forKey: "in_app") as? [[String:Any]] {
                                        self.arrInApp.removeAll()
                                        for dict in in_app {
                                            self.arrInApp.append(InApp(dict: dict))
                                        }
                                      //  print("arrInAppFirst:-", self.arrInApp.first!)
                                    }
                                }
                                print("arrInAppLast:-", self.arrInApp.last!)
                                let dict = self.arrInApp.last
                                self.expiryDate = dict?.expires_date ?? ""
                                self.purchaseDate = dict?.purchase_date ?? ""
                                self.invoiceID = dict?.transaction_id ?? ""
                                
                                self.callPurchaseAPI()
                                
                                UserDefaults.standard.setValue(true, forKey: "currentSubscription")
                                self.isSubscribed = true
                                self.tblSubscription.reloadData()
//                                self.delegate?.unlockaudio()

                            } else {
                                UserDefaults.standard.setValue(false, forKey: "currentSubscription")
                                self.isSubscribed = false
                                self.tblSubscription.reloadData()
                                AppData.sharedInstance.dismissLoader()
                                // receipt verification error
                            }
                        }
                        
                    case .error(let error):
                        AppData.sharedInstance.dismissLoader()
                        switch error.code {
                        case .unknown:
                            self.view.makeToast("Unknown error. Please contact support")
                        case .clientInvalid:
                            self.view.makeToast("Not allowed to make the payment")
                        case .paymentCancelled:
                            break
                        case .paymentInvalid:
                            self.view.makeToast("The purchase identifier was invalid")
                        case .paymentNotAllowed:
                            self.view.makeToast("The device is not allowed to make the payment")
                        case .storeProductNotAvailable:
                            self.view.makeToast("The product is not available in the current storefront")
                        case .cloudServicePermissionDenied:
                            self.view.makeToast("Access to cloud service information is not allowed")
                        case .cloudServiceNetworkConnectionFailed:
                            self.view.makeToast("Could not connect to the network")
                        case .cloudServiceRevoked:
                            self.view.makeToast("User has revoked permission to use this cloud service")
                        case .invalidSignature:
                            self.view.makeToast("Unknown error. Please contact support")
                        case .privacyAcknowledgementRequired:
                            self.view.makeToast("Unknown error. Please contact support")
                        case .unauthorizedRequestData:
                            self.view.makeToast("Unknown error. Please contact support")
                        case .invalidOfferPrice:
                            self.view.makeToast("Unknown error. Please contact support")
                        case .invalidOfferIdentifier:
                            self.view.makeToast("Unknown error. Please contact support")
                        case .missingOfferParams:
                            self.view.makeToast("Unknown error. Please contact support")
                        case .overlayCancelled:
                            self.view.makeToast("Unknown error. Please contact support")
                        case .overlayInvalidConfiguration:
                            self.view.makeToast("Unknown error. Please contact support")
                        case .overlayTimeout:
                            self.view.makeToast("Unknown error. Please contact support")
                        case .ineligibleForOffer:
                            self.view.makeToast("Unknown error. Please contact support")
                        case .unsupportedPlatform:
                            self.view.makeToast("Unknown error. Please contact support")
                        case .overlayPresentedInBackgroundScene:
                            self.view.makeToast("Unknown error. Please contact support")
                        @unknown default:
                            self.view.makeToast("Unknown error. Please contact support")
                        }
                    }
                }
            } else {
                AppData.sharedInstance.dismissLoader()
                self.view.makeToast("Check your network connection")
            }
        }
    
    @IBAction func btnRestoreClick(_ sender: UIButton) {
    /*    if AppData.sharedInstance.isConnectedToNetwork() {
            AppData.sharedInstance.showLoader()
            SwiftyStoreKit.restorePurchases(atomically: true) { results in
                if results.restoreFailedPurchases.count > 0 {
                    AppData.sharedInstance.dismissLoader()
                    print("Restore Failed: \(results.restoreFailedPurchases)")
                    self.view.makeToast("\(results.restoreFailedPurchases)")
                    UserDefaults.standard.setValue(false, forKey: "currentSubscription")
                    self.isSubscribed = false
                    self.tblSubscription.reloadData()
                }
                if results.restoredPurchases.count > 0 {
                    var isrestore = false
                    for purchase in results.restoredPurchases {
                        // fetch content from your server, then:
//                        if purchase.needsFinishTransaction {
//                            SwiftyStoreKit.finishTransaction(purchase.transaction)
//                        }
                        
                        let str = Set<String>(ProductType.all.map({$0.rawValue}))
                        if str.count > 0 {
                            isrestore = true
//                            if str.first == InappKeyForever{
//                                UserDefaults.standard.set(true, forKey: kIsUnlockAllPurchased)
//                                UserDefaults.standard.synchronize()
//                            }else{
//                                 self.savePurchaseToDefault(planId: str.first!)
//                            }
                        }
                    }
                    AppData.sharedInstance.dismissLoader()
                    if isrestore{
                        self.checkIfPurchaed()
                        print("Restored Successfully.")
                        self.view.makeToast("Restored Successfully.")
                        
//                        UserDefaults.standard.setValue(true, forKey: "currentSubscription")
//                        self.isSubscribed = true
//                        self.tblSubscription.reloadData()
//                        self.delegate?.unlockaudio()
//                        self.dismiss(animated: false, completion: nil)
                    }else{
                        print("Nothing to Restore")
                        self.view.makeToast("Nothing to Restore")
                        UserDefaults.standard.setValue(false, forKey: "currentSubscription")
                        self.isSubscribed = false
                        self.tblSubscription.reloadData()
                    }
                    
                } else {
                    AppData.sharedInstance.dismissLoader()
                    print("Nothing to Restore")
                    self.view.makeToast("Nothing to Restore")
                    UserDefaults.standard.setValue(false, forKey: "currentSubscription")
                    self.isSubscribed = false
                    self.tblSubscription.reloadData()
                }
            }
        } else {
            self.view.makeToast("Check your network connection")
            print("Check your network connection")
        }  */
    }
}

//MARK:- UITableView DataSource Methods
extension SubscriptionPackageVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblSubscription.dequeueReusableCell(withIdentifier: "SubscriptionPackageCell", for: indexPath) as! SubscriptionPackageCell
        
        cell.setCell(index: indexPath.row)
        cell.btnPurchase.tag = indexPath.row
        cell.parent = self
        
        if isSubscribed {
            cell.btnPurchase.setTitle("Active", for: .normal)
            cell.btnPurchase.backgroundColor = UIColor.init("#149A14")
            cell.btnPurchase.isUserInteractionEnabled = false
        } else {
            cell.btnPurchase.setTitle("Purchase", for: .normal)
            cell.btnPurchase.backgroundColor = UIColor.init("#15B0DA")
            cell.btnPurchase.isUserInteractionEnabled = true
        }
        
        return cell
    }
    
    
}

//MARK:- UITableView Delegate Methods
extension SubscriptionPackageVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedSubScription = indexPath.row
//    }
}
