//
//  CompletedOrderVC.swift
//  MySunless
//
//  Created by iMac on 22/02/22.
//

import UIKit
import Alamofire
import Kingfisher

protocol CompletedOrderProtocol {
    func editOrder(index: Int)
    func updatedCompletedOrderList(date: String?,selectedDateIndex : Int?, userIds: [(String,String)]?, customerIds:[(String,String)]?, filterBadgeCount: Int,paymentStatus : String?,selectedPaymentIndex : Int?)
    
}

class CompletedOrderVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet var btnFilter: UIButton!
    @IBOutlet var btnPayment: UIButton!
    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblCompletedOrder: UITableView!
    @IBOutlet var lblBadgeNumber: UILabel!
    
    //MARK:- Variable Declarations
    var token = String()
    var arrCompletedOrder = [ShowCompletedOrder]()
    var arrFilterCompletedOrder = [ShowCompletedOrder]()
    var searching = false
    var selectedOrderID = Int()
    var model = ShowCompletedOrder(dict: [:])
    var arrService = [Service]()
    var arrProduct = [Product]()
    var arrProductIds = [String]()
    var arrMembership = [Membership]()
    var arrCartList = [CartList]()
    var isFilter = false
    var strFilterDate  = ""
    var arrFilterUserIds = [(String,String)]()
    var arrFilterCustIds = [(String,String)]()
    var strFilterPayment  = ""
    var selectedPaymentStatusIndex : Int = -1
    var selectedDatefilterIndex : Int = -1
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setInitially()
        hideKeyboardWhenTappedAround()
        tblCompletedOrder.tableFooterView = UIView()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        searchBar.delegate = self
        tblCompletedOrder.refreshControl = UIRefreshControl()
        tblCompletedOrder.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callShowCompletedOrderAPI()
    }
    
    //MARK:- UserDefined Functions
    func setInitially() {
        btnFilter.layer.borderWidth = 0.5
        btnFilter.layer.borderColor = UIColor.init("#FFCA00").cgColor
        btnPayment.layer.borderWidth = 0.5
        btnPayment.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
    }
    
    func callShowCompletedOrderAPI(isFilter : Bool? = false) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params : NSDictionary = [:]
        if isFilter! {
            var dict :[String:String] = [:]
            if strFilterDate != "" {
                dict["FilterDate"] = strFilterDate
            }
            if arrFilterUserIds.count > 0 {
                dict["orderuser"] = arrFilterUserIds.map{$0.1}.joined(separator:",")
           }
            if arrFilterCustIds.count > 0 {
                dict["ordercustomer"] = arrFilterCustIds.map{$0.1}.joined(separator:",")
            }
            if strFilterPayment != "" {
                dict["payment_status"] = strFilterPayment
            }
            params = dict as NSDictionary
            
        } else {
            params = [:]
        }
        
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_COMPLETED_ORDER, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let resonse = res.value(forKey: "resonse") as? [[String:Any]] {
                            self.arrCompletedOrder.removeAll()
                            for dict in resonse {
                                self.arrCompletedOrder.append(ShowCompletedOrder(dict: dict))
                            }
                            self.arrFilterCompletedOrder = self.arrCompletedOrder
                            DispatchQueue.main.async {
                                self.tblCompletedOrder.reloadData()
                            } 
                        }
                    } else {
                        if let resonse = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: resonse, viewController: self)
                            self.arrCompletedOrder.removeAll()
                            self.arrFilterCompletedOrder.removeAll()
                            self.tblCompletedOrder.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func callDeleteOrderAPI(orderId: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["id": orderId]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DELETE_ORDER, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let respnse = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: respnse, viewController: self)
                            self.callShowCompletedOrderAPI()
                        }
                    } else {
                        if let respnse = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: respnse, viewController: self)
                        }
                    }
                }
            }
        }
    }
    
    func callChangePaymentStatus(id: Int, status: String) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["id": id,
                  "status": status
        ]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + CHANGE_PAYMENT_STATUS, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.alert(message: message, viewController: self) { (alert) in
                                self.callShowCompletedOrderAPI()
                            }
                        }
                    } else {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.alert(message: message, viewController: self) { (alert) in
                                self.callShowCompletedOrderAPI()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        arrFilterCompletedOrder = arrCompletedOrder.filter({ (completedOrder: ShowCompletedOrder) -> Bool in
            let username = completedOrder.username
            let UserName = username.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let name = completedOrder.FirstName + " " + completedOrder.LastName
            let Name = name.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let type = completedOrder.PaymentType
            let Type = type.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let invoice = completedOrder.InvoiceNumber
            let Invoice = invoice.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let status = completedOrder.payment_status
            let Status = status.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let subTotal = completedOrder.PaymentAmount
            let SubTotal = subTotal.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let date = completedOrder.Orderdate
            let Date = date.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return UserName != nil || Name != nil || Type != nil || Invoice != nil || Status != nil || SubTotal != nil || Date != nil
        })
    }
    
    @objc func callPullToRefresh(){
        DispatchQueue.main.async {
            self.callShowCompletedOrderAPI(isFilter:true)
            self.tblCompletedOrder.refreshControl?.endRefreshing()
            self.tblCompletedOrder.reloadData()
        }
    }
    
    func getCartData(cart: ShowCompletedOrder) {
        for dic in cart.ServiceName {
            arrService.append(Service(dict: dic))
        }
        for i in arrService {
            arrCartList.append(CartList(item: i.servicename, qty: "-", price: i.ServicePrice.floatValue() ?? 0.00, tax: 0.00, discount: i.ServiceDiscount.floatValue() ?? 0.00, discountPercent: i.ServiceDiscoutInParentage.floatValue() ?? 0.00, totalPrice: i.ServiceFianlPrice.floatValue() ?? 0.00, showTax: false, selectedItem: "Service"))
        }
        
        for dic in cart.ProdcutName {
            arrProduct.append(Product(dict: dic))
        }
        for i in arrProduct {
            arrProductIds.append("\(i.productid)")
        }
        for i in arrProduct {
            arrCartList.append(CartList(item: i.productname, qty: i.productQuantity, price: i.productprice.floatValue() ?? 0.00, tax: i.ProductTaxPrice.floatValue() ?? 0.00, discount: i.ProductDiscount.floatValue() ?? 0.00, discountPercent: i.ProductDiscountInParentage.floatValue() ?? 0.00, totalPrice: i.ProductFianlPrice.floatValue() ?? 0.00, showTax: true, selectedItem: "Product", productIds: arrProductIds))
        }
        
        for dic in cart.MembershipName {
            arrMembership.append(Membership(dict: dic))
        }
        for i in arrMembership {
            arrCartList.append(CartList(item: i.membershipname, qty: "-", price: i.MembershipPrice.floatValue() ?? 0.00, tax: 0.00, discount: i.MembershipDiscount.floatValue() ?? 0.00, discountPercent: i.MemberDiscoutInParentage.floatValue() ?? 0.00, totalPrice: i.MembershipFianlPrice.floatValue() ?? 0.00, showTax: false, selectedItem: "Package"))
        }
        
        arrCartList.append(CartList(item: cart.gServiceName, qty: "-", price: cart.gServicePrice.floatValue() ?? 0.00, tax: 0.00, discount: cart.gServiceDiscount.floatValue() ?? 0.00, discountPercent: cart.gServiceDiscoutInParentage.floatValue() ?? 0.00, totalPrice: cart.gServiceFianlPrice.floatValue() ?? 0.00, showTax: false, selectedItem: "Gift Card"))
        
    }
    
    //MARK:- Actions
    @IBAction func btnFilterClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "LoginLogFilterVC") as! LoginLogFilterVC
        VC.modalPresentationStyle = .overCurrentContext
        VC.modalTransitionStyle = .crossDissolve
        VC.isFromCompletedOrder = true
        VC.delegateOfCompletedOrder = self
        VC.arrSelectedCustIds = self.arrFilterCustIds
        VC.arrSelectedUserIds = self.arrFilterUserIds
        VC.selectedDatefilterIndex = self.selectedDatefilterIndex
        VC.selectedPaymentStatusIndex = self.selectedPaymentStatusIndex
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBAction func btnPaymentClick(_ sender: UIButton) {
    }
    
    @IBAction func btnViewClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "InvoiceVC") as! InvoiceVC
        VC.modalPresentationStyle = .overCurrentContext
        VC.modalTransitionStyle = .crossDissolve
        VC.orderId = searching ? arrFilterCompletedOrder[sender.tag].orderid : arrCompletedOrder[sender.tag].orderid
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBAction func btnDeleteClick(_ sender: UIButton) {
        if searching {
            callDeleteOrderAPI(orderId: arrFilterCompletedOrder[sender.tag].orderid)
            arrFilterCompletedOrder.remove(at: sender.tag)
        } else {
            callDeleteOrderAPI(orderId: arrCompletedOrder[sender.tag].orderid)
            arrCompletedOrder.remove(at: sender.tag)
        }
        tblCompletedOrder.reloadData()
    }
    
}

//MARK:- UITableview DataSource Methods
extension CompletedOrderVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return arrFilterCompletedOrder.count
        } else {
            return arrCompletedOrder.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblCompletedOrder.dequeueReusableCell(withIdentifier: "CompletedOrderCell", for: indexPath) as! CompletedOrderCell
        
        if (arrCompletedOrder[indexPath.row].PaymentType == "Cheque" || arrFilterCompletedOrder[indexPath.row].PaymentType == "Cheque") {
            cell.dropDownStatus.optionArray = ["Clear(CAPTURED)","In Process(PROCESSING)","Bounce(FAILED)"]
        } else {
            cell.dropDownStatus.optionArray = ["CAPTURED","PENDING"]
        }
        
        if searching {
            model = arrFilterCompletedOrder[indexPath.row]
        } else {
            model = arrCompletedOrder[indexPath.row]
        }
        
        let imgUserUrl = URL(string: model.userimg)
        cell.imgUser.kf.setImage(with: imgUserUrl)
        let customerImgUrl = URL(string: model.ProfileImg)
        cell.imgCustomer.kf.setImage(with: customerImgUrl)
        
        cell.lblUser.text = model.username
        cell.lblCustomer.text = model.FirstName + " " + model.LastName
        cell.lblType.text = model.PaymentType
        cell.lblInvoice.text = model.InvoiceNumber
        cell.lblSubTotal.text = "$" + model.PaymentAmount
        var date = model.Orderdate
        date.removeLast(9)
        cell.lblDate.text = date
        
        if model.PaymentType == "Cheque" {
            if model.payment_status == "CAPTURED" {
                cell.dropDownStatus.text = "CLEAR(CAPTURED)"
            }
        } else {
            cell.dropDownStatus.text = model.payment_status
        }
        
//        if model.PaymentType == "Cheque" {
//            switch model.payment_status {
//                case "CAPTURED":
//                    cell.dropDownStatus.text = "Clear(CAPTURED)"
//                    cell.btnEdit.isHidden = true
//                    cell.btnDelete.isHidden = true
//                case "PROCESSING":
//                    cell.dropDownStatus.text = "In Process(PROCESSING)"
//                    cell.btnEdit.isHidden = false
//                    cell.btnDelete.isHidden = false
//                case "FAILED":
//                    cell.dropDownStatus.text = "Bounce(FAILED)"
//                    cell.btnEdit.isHidden = false
//                    cell.btnDelete.isHidden = false
//                default:
//                    print("Default")
//            }
//        } else {
//            cell.dropDownStatus.text = model.payment_status
//        }
        
        cell.dropDownStatus.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index),id: \(id)")
            cell.dropDownStatus.selectedIndex = index
            var selectedStatus = String()
            selectedStatus = selectedText
            switch selectedStatus {
                case "Clear(CAPTURED)":
                    selectedStatus = "CAPTURED"
//                case "In Process (PROCESSING)":
//                    selectedStatus = "PROCESSING"
//                case "Bounce(FAILED)":
//                    selectedStatus = "FAILED"
                default:
                    selectedStatus = selectedText
            }
            self.callChangePaymentStatus(id: self.model.id, status: selectedStatus)
        }
        
        cell.btnView.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        cell.btnEdit.tag = indexPath.row
        cell.delegate = self
        
        return cell
    }
}

//MARK:- UITableview Delegate Methods
extension CompletedOrderVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
}

//MARK:- SearchBar Delegate Methods
extension CompletedOrderVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                arrFilterCompletedOrder = arrCompletedOrder
            }
            tblCompletedOrder.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblCompletedOrder.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}

//MARK:- filter Delegate Methods
extension CompletedOrderVC: CompletedOrderProtocol {
    
    func updatedCompletedOrderList(date: String?, selectedDateIndex: Int?, userIds: [(String,String)]?, customerIds: [(String,String)]?, filterBadgeCount: Int, paymentStatus: String?, selectedPaymentIndex: Int?) {
            strFilterDate = date ?? ""
            arrFilterCustIds = customerIds ?? [("","")]
            arrFilterUserIds = userIds ?? [("","")]
            strFilterPayment = paymentStatus ?? ""
            self.isFilter = true
            selectedPaymentStatusIndex = selectedPaymentIndex ?? -1
            selectedDatefilterIndex = selectedDateIndex ?? -1
            lblBadgeNumber.text = " \(filterBadgeCount) "
            callShowCompletedOrderAPI(isFilter: true)
            tblCompletedOrder.reloadData()
         
    }
 
    func editOrder(index: Int) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddOrderVC") as! AddOrderVC
        VC.isEditCompletedOrder = true
     //   VC.editCompletedOrder = searching ? arrFilterCompletedOrder[index] : arrCompletedOrder[index]
        
        let dict = searching ? arrFilterCompletedOrder[index] : arrCompletedOrder[index]
        VC.selectedClientId = dict.clientID
        getCartData(cart: dict)
        VC.arrCartList = arrCartList
        VC.tips = dict.tips
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
}
