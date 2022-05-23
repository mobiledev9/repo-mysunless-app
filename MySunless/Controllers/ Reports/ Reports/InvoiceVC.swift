//
//  InvoiceVC.swift
//  MySunless
//
//  Created by Daydream Soft on 25/03/22.
//

import UIKit
import Alamofire
import SCLAlertView

protocol SendMailProtocol {
    func callOrderInvoiceMailAPI(email: String, orderId: Int)
}

class InvoiceVC: UIViewController {
    
    @IBOutlet var tblItemList: UITableView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgLogo: UIImageView!
    @IBOutlet var imgSign: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblPhoneNumber: UILabel!
    @IBOutlet var lblOrderDate: UILabel!
    @IBOutlet var lblInvoiceNumber: UILabel!
    @IBOutlet var lblPaymentMode: UILabel!
    @IBOutlet var lblService: UILabel!
    @IBOutlet var lblGiftCard: UILabel!
    @IBOutlet var lblProduct: UILabel!
    @IBOutlet var lblMembership: UILabel!
    @IBOutlet var lblSalesTax: UILabel!
    @IBOutlet var lblTips: UILabel!
    @IBOutlet var lblGiftApplied :UILabel!
    @IBOutlet var lblTotal :UILabel!
    @IBOutlet var lblSignatureBy :UILabel!
    @IBOutlet var lblOtherNote :UILabel!
    @IBOutlet var lblNoteFirst :UILabel!
    @IBOutlet var lblNoteSecond :UILabel!
    @IBOutlet var vw_Invoice :UIView!
    @IBOutlet var vw_main: UIView!
    @IBOutlet var vw_first: UIView!
    @IBOutlet var vw_second: UIView!
    
    var orderId = Int()
    var token = String()
    var arrItemList = [CartList]()
    var arrResponseService = [Response_service]()
    var arrResponseProduct = [Response_product]()
    var arrResponsePackage = [Response_membership]()
    var arrResponseGiftCard = [Allgiftcard]()
    var fname = String()
    var lname = String()
    var address = String()
    var city = String()
    var zip = String()
    var state = String()
    var country = String()
    var dictItem = CartList()
    var email = String()
    var downloadPdfUrl : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callOrderInvoiceModalAPI(orderId: orderId)
    }
    
    func setInitially() {
        vw_Invoice.layer.borderWidth = 1.0
        vw_Invoice.layer.borderColor = UIColor.init("#005CC8").cgColor
        vw_main.layer.borderWidth = 1.0
        vw_main.layer.borderColor = UIColor.init("#005CC8").cgColor
        vw_first.layer.cornerRadius = 12
        vw_first.layer.masksToBounds = true
        vw_first.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        vw_second.layer.cornerRadius = 12
        vw_second.layer.masksToBounds = true
        vw_second.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func showSendMailAlert() {
        let alert = SCLAlertView()
        alert.addButton("Change Mail?", backgroundColor: UIColor.init("#E95268"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "ChangeEmailVC") as! ChangeEmailVC
            VC.modalPresentationStyle = .overCurrentContext
            VC.modalTransitionStyle = .crossDissolve
            VC.delegate = self
            VC.orderId = self.orderId
            self.present(VC, animated: true, completion: nil)
        })
        alert.addButton("Yes, Send", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            self.callOrderInvoiceMailAPI(email: self.lblEmail.text ?? "", orderId: self.orderId)
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(lblEmail.text ?? "", subTitle: "Are you sure you want to send invoice on above customer's mail or want to change mail?")
    }
    
    func callOrderInvoiceModalAPI(orderId: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["orderid": orderId]
        if (APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + VIEW_INVOICE, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                self.arrItemList.removeAll()
                if let response_service = res.value(forKey: "response_service") as? [[String:Any]] {
                    self.arrResponseService.removeAll()
                    for dict in response_service {
                        self.arrResponseService.append(Response_service(dictionary: dict)!)
                    }
                    for dic in self.arrResponseService {
                        self.dictItem = CartList(item: dic.serviceName ?? "", qty: "-", price: dic.servicePrice?.floatValue() ?? 0.00, tax: 0.00, discount: dic.serviceDiscount?.floatValue() ?? 0.00, discountPercent: dic.serviceDiscoutInParentage?.floatValue() ?? 0.00, totalPrice: dic.serviceFianlPrice?.floatValue() ?? 0.00, showTax: false, selectedItem: "Service")
                        self.arrItemList.append(self.dictItem)
                    }
                }
                if let response_product = res.value(forKey: "response_product") as? [[String:Any]] {
                    self.arrResponseProduct.removeAll()
                    for dict in response_product {
                        self.arrResponseProduct.append(Response_product(dictionary: dict)!)
                    }
                    for dic in self.arrResponseProduct {
                        self.dictItem = CartList(item: dic.productTitle ?? "", qty: dic.prodcutQuality ?? "", price: dic.productPrice?.floatValue() ?? 0.00, tax: dic.productTaxPrice?.floatValue() ?? 0.00, discount: dic.productDiscount?.floatValue() ?? 0.00, discountPercent: dic.productDiscountInParentage?.floatValue() ?? 0.00, totalPrice: dic.productFianlPrice?.floatValue() ?? 0.00, showTax: true, selectedItem: "Product")
                        self.arrItemList.append(self.dictItem)
                    }
                }
                if let response_membership = res.value(forKey: "response_membership") as? [[String:Any]] {
                    self.arrResponsePackage.removeAll()
                    for dict in response_membership {
                        self.arrResponsePackage.append(Response_membership(dictionary: dict)!)
                    }
                    for dic in self.arrResponsePackage {
                        self.dictItem = CartList(item: dic.name ?? "", qty: "-", price: dic.membershipPrice?.floatValue() ?? 0.00, tax: 0.00, discount: dic.membershipDiscount?.floatValue() ?? 0.00, discountPercent: dic.memberDiscoutInParentage?.floatValue() ?? 0.00, totalPrice: dic.membershipFianlPrice?.floatValue() ?? 0.00, showTax: false, selectedItem: "Package")
                        self.arrItemList.append(self.dictItem)
                    }
                }
                if let allgiftcard = res.value(forKey: "allgiftcard") as? [[String:Any]] {
                    self.arrResponseGiftCard.removeAll()
                    for dict in allgiftcard {
                        self.arrResponseGiftCard.append(Allgiftcard(dictionary: dict)!)
                    }
                    for dic in self.arrResponseGiftCard {
                        self.dictItem = CartList(item: "Giftcard", qty: "-", price: dic.gServicePrice?.floatValue() ?? 0.00, tax: 0.00, discount: dic.gServiceDiscount?.floatValue() ?? 0.00, discountPercent: dic.gServiceDiscoutInParentage?.floatValue() ?? 0.00, totalPrice: dic.gServiceFianlPrice?.floatValue() ?? 0.00, showTax: false, selectedItem: "Gift Card")
                        self.arrItemList.append(self.dictItem)
                    }
                }
                if let response_order = res.value(forKey: "response_order") as? NSDictionary {
                    if let FirstName = response_order.value(forKey: "FirstName") as? String {
                        self.fname = FirstName
                    }
                    if let LastName = response_order.value(forKey: "LastName") as? String {
                        self.lname = LastName
                    }
                    self.lblName.text = self.fname + " " + self.lname
                    if let email = response_order.value(forKey: "email") as? String {
                        self.lblEmail.text = email
                    }
                    if let Address = response_order.value(forKey: "Address") as? String {
                        self.address = Address
                    }
                    if let City = response_order.value(forKey: "City") as? String {
                        self.city = City
                    }
                    if let Zip = response_order.value(forKey: "Zip") as? String {
                        self.zip = Zip
                    }
                    if let State = response_order.value(forKey: "State") as? String {
                        self.state = State
                    }
                    if let Country = response_order.value(forKey: "Country") as? String {
                        self.country = Country
                    }
                    self.lblAddress.text = self.address + "\n" + self.city + "," + self.zip + "," + self.state + "," + self.country
                    if let Phone = response_order.value(forKey: "Phone") as? String {
                        self.lblPhoneNumber.text = Phone
                    }
                    if let InvoiceNumber = response_order.value(forKey: "InvoiceNumber") as? String {
                        self.lblInvoiceNumber.text = InvoiceNumber
                    }
                    if let TotalseriveAmount = response_order.value(forKey: "TotalseriveAmount") as? String {
                        self.lblService.text = "$" + TotalseriveAmount
                    }
                    if let TotalgiftAmount = response_order.value(forKey: "TotalgiftAmount") as? String {
                        self.lblGiftCard.text = "$" + TotalgiftAmount
                    }
                    if let TotalProductAmount = response_order.value(forKey: "TotalProductAmount") as? String {
                        self.lblProduct.text = "$" + TotalProductAmount
                    }
                    if let TotalMembershipAmount = response_order.value(forKey: "TotalMembershipAmount") as? String {
                        self.lblMembership.text = "$" + TotalMembershipAmount
                    }
                    if let sales_tax = response_order.value(forKey: "sales_tax") as? String {
                        self.lblSalesTax.text = "$" + sales_tax
                    }
                    if let tips = response_order.value(forKey: "tips") as? String {
                        self.lblTips.text = "$" + tips
                    }
                    if let giftapp = response_order.value(forKey: "giftapp") as? String {
                        self.lblGiftApplied.text = "-$" + giftapp
                    }
                    
                    
                }
                if let OrderPayment = res.value(forKey: "OrderPayment") as? NSDictionary {
                    if let Orderdate = OrderPayment.value(forKey: "Orderdate") as? String {
                        self.lblOrderDate.text = AppData.sharedInstance.formattedDateFromString(dateString: Orderdate, withFormat: "yyyy-MM-dd")
                    }
                    if let PaymentType = OrderPayment.value(forKey: "PaymentType") as? String {
                        self.lblPaymentMode.text = PaymentType
                    }
                    if let amount = OrderPayment.value(forKey: "amount") as? String {
                        self.lblTotal.text = amount
                    }
                }
            }
            DispatchQueue.main.async {
                self.tblItemList.reloadData()
            }
        }
    }
    
    func calldownloadPdfAPI(id:Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["OrderId": orderId]
        
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DOWNLOAD_PDF, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let message = res.value(forKey: "response") as? String {
                            self.downloadPdfUrl = message
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
    
    func saveInvoicePdf() {
        let url = downloadPdfUrl.appending(".pdf")
        let fileName = downloadPdfUrl.components(separatedBy: "/").last ?? "0000"
        savePdf(urlString: url, fileName: fileName)
    }
    
    func savePdf(urlString:String, fileName:String) {
        DispatchQueue.main.async {
            let url = URL(string: urlString)
            let pdfData = try? Data.init(contentsOf: url!)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let pdfNameFromUrl = "\(fileName).pdf"
            let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            do {
                try pdfData?.write(to: actualPath, options: .atomic)
                print("File Saved Location:\(actualPath)")
                AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: "pdf successfully saved")
            } catch {
                AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: "pdf not saved")
            }
        }
    }
    
    @IBAction func btnTopCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnPrintClick(_ sender: UIButton) {
        saveInvoicePdf()
    }
    
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSendClick(_ sender: UIButton) {
        showSendMailAlert()
    }
    
}

//MARK:- TableView Delegate and Datasource Methods
extension InvoiceVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblItemList.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.lblItem.text = arrItemList[indexPath.row].item
        cell.lblQty.text = arrItemList[indexPath.row].qty
        if arrItemList[indexPath.row].tax != 0.00 {
            cell.lblPrice.text = String(format: "%.02f", arrItemList[indexPath.row].price + arrItemList[indexPath.row].tax) + "(TAX)"
        } else {
            cell.lblPrice.text = String(format: "%.02f", arrItemList[indexPath.row].price)
        }
        cell.lblDisc.text = String(format: "%.02f", arrItemList[indexPath.row].discount)
        cell.lblPer.text = String(format: "%.02f", arrItemList[indexPath.row].discountPercent)
        cell.lblTotalPrice.text = String(format: "%.02f", arrItemList[indexPath.row].totalPrice)
        return cell
    }
}

extension InvoiceVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension InvoiceVC: SendMailProtocol {
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
                            AppData.sharedInstance.showSCLAlert(alertMainTitle: "Mail Sent", alertTitle: "Invoice is successfully sent")
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
}

//MARK:- UITableViewCell Method
class ItemCell : UITableViewCell {
    @IBOutlet var lblItem: UILabel!
    @IBOutlet var lblQty: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblDisc: UILabel!
    @IBOutlet var lblPer: UILabel!
    @IBOutlet var lblTotalPrice: UILabel!
}


