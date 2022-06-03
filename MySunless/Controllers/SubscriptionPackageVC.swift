//
//  SubscriptionPackageVC.swift
//  MySunless
//
//  Created by iMac on 27/05/22.
//

import UIKit
import StoreKit

class SubscriptionPackageVC: UIViewController {
    
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
    
    var iapProducts = [SKProduct]()
    var arr:NSMutableArray = NSMutableArray()
    var productID = String()
    var selectedSubScription = Int()
    var isSubscribed = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAvailableProducts()
        
        // Fetch the Current Subscription to UserDefaults
        if UserDefaults.standard.object(forKey: "currentSubscription") != nil {
            productID = UserDefaults.standard.object(forKey: "currentSubscription") as! String
            isSubscribed = true
            DispatchQueue.main.async {
                self.tblSubscription.reloadData()
            }
        }
    }
    
    func setInitially() {
        vw_top.layer.cornerRadius = 12
        vw_top.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        vw_bottom.layer.cornerRadius = 12
        vw_bottom.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        tblSubscription.tableFooterView = UIView()
        btnRestore.layer.cornerRadius = 12
    }
    
    func fetchAvailableProducts() {
        DispatchQueue.main.async {
            AppData.sharedInstance.showLoader()
        }
        let productIdentifiers = Set<String>(ProductType.all.map({$0.rawValue}))
        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
        
    }
    
    func buyProduct(_ product: SKProduct) {
        // Add the StoreKit Payment Queue for ServerSide
        SKPaymentQueue.default().add(self)
        if SKPaymentQueue.canMakePayments() {
            print("Sending the Payment Request to Apple")
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
            productID = product.productIdentifier
        } else {
            print("cant purchase")
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print(request)
        print(error)
    }
    
    // function for get the receiptValidation from the server for get  receiptValiation we need to recieptString and shared secret which will provided by Apple and we have pass those in following way to get All the subscription Data
    func receiptValidation() {
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let jsonDict: [String: AnyObject] = ["receipt-data" : recieptString! as AnyObject, "password" : "d223e7df9689472295a6d7a62e8864ba" as AnyObject]
        
        do {
            let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let storeURL = URL(string: verifyReceiptURL)!
            var storeRequest = URLRequest(url: storeURL)
            storeRequest.httpMethod = "POST"
            storeRequest.httpBody = requestData
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: storeRequest, completionHandler: { [weak self] (data, response, error) in
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    print("=======>",jsonResponse)
                    if let date = self?.getExpirationDateFromResponse(jsonResponse as! NSDictionary) {
                        print(date)
                    }
                } catch let parseError {
                    print(parseError)
                }
            })
            task.resume()
        } catch let parseError {
            print(parseError)
        }
    }
    
    func getExpirationDateFromResponse(_ jsonResponse: NSDictionary) -> Date? {
        if let receiptInfo: NSArray = jsonResponse["latest_receipt_info"] as? NSArray {
            let lastReceipt = receiptInfo.lastObject as! NSDictionary
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            if let expiresDate = lastReceipt["expires_date"] as? String {
                return formatter.date(from: expiresDate)
            }
            return nil
        }
        else {
            return nil
        }
    }
    
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnPurchaseClick(_ sender: UIButton) {
        buyProduct(iapProducts[sender.tag])
    }
    
    @IBAction func btnRestoreClick(_ sender: UIButton) {
        if SKPaymentQueue.canMakePayments() {
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().restoreCompletedTransactions()
            print("Restore Purchase")
        }
    }
}

extension SubscriptionPackageVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblSubscription.dequeueReusableCell(withIdentifier: "SubscriptionPackageCell", for: indexPath) as! SubscriptionPackageCell
        
        cell.setCell(index: indexPath.row)
        cell.btnPurchase.tag = indexPath.row
        
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

extension SubscriptionPackageVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSubScription = indexPath.row
    }
}

extension SubscriptionPackageVC: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            AppData.sharedInstance.dismissLoader()
        }
        if (response.products.count > 0) {
            iapProducts = response.products
            self.arr.removeAllObjects()
            for prod in response.products {
                print(prod.productIdentifier)
                print(prod.localizedTitle)
                print(prod.localizedDescription)
                print(prod.price)
                arr.add(prod)
            }
            DispatchQueue.main.async {
                self.tblSubscription.reloadData()
            }
        } else {
            print("No products found")
        }
        
        
    }
     
}

extension SubscriptionPackageVC: SKPaymentTransactionObserver {
    // function for details of all the transtion done for spacific Account
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                    case .purchasing:
                    DispatchQueue.main.async {
                        AppData.sharedInstance.showLoader()
                    }
                    case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    print("Success")
                    
                    DispatchQueue.main.async {
                        AppData.sharedInstance.dismissLoader()
                    }
                    UserDefaults.standard.setValue(productID, forKey: "currentSubscription")
                    isSubscribed = true
                    self.tblSubscription.reloadData()
                        self.receiptValidation()
                        break
                    case .failed:
                        SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                        print("Fail")
                        
                        break
                    case .restored:
                        print("restored")
//                        SKPaymentQueue.default().restoreCompletedTransactions()
                        break
                    default:
                        break
                }
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("transactions refresh")
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
            case "32323232":
                print("Monthly subscription refreshed!")
                break
            default:
                print("IAP not found")
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print(error)
    }
}
