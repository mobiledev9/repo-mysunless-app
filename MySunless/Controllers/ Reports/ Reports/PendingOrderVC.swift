//
//  PendingOrderVC.swift
//  MySunless
//
//  Created by iMac on 22/02/22.
//

import UIKit
import Alamofire
import Kingfisher

protocol PendingOrderProtocol {
    func updatedPendingOrderList(date: String?,selectedDateIndex : Int?, userIds: [(String,String)]?, customerIds:[(String,String)]?, filterBadgeCount: Int)
    
}

class PendingOrderVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet var btnFilter: UIButton!
    @IBOutlet var btnPayment: UIButton!
    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblPendingOrder: UITableView!
    @IBOutlet var lblBadgeNumber: UILabel!
    
    //MARK:- Variable Declarations
    var token = String()
    var arrPendingOrder = [ShowPendingOrder]()
    var arrFilterPendingOrder = [ShowPendingOrder]()
    var searching = false
    var model = ShowPendingOrder(dict: [:])
    var arrFilterUserIds = [(String,String)]()
    var arrFilterCustIds = [(String,String)]()
    var selectedDatefilterIndex : Int = -1
    var isFilter = false
    var strFilterDate  = ""
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setInitially()
        hideKeyboardWhenTappedAround()
        tblPendingOrder.tableFooterView = UIView()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        searchBar.delegate = self
        tblPendingOrder.refreshControl = UIRefreshControl()
        tblPendingOrder.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callShowPendingOrderAPI()
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
    
    func callShowPendingOrderAPI(isFilter : Bool? = false) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_PENDING_ORDER, param: params, header: headers) { (response, error) in
            AppData.sharedInstance.dismissLoader()
            print(response ?? "")
            
            if let res = response as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let resonse = res.value(forKey: "resonse") as? [[String:Any]] {
                            self.arrPendingOrder.removeAll()
                            for dict in resonse {
                                self.arrPendingOrder.append(ShowPendingOrder(dict: dict))
                            }
                            self.arrFilterPendingOrder = self.arrPendingOrder
                            DispatchQueue.main.async {
                                self.tblPendingOrder.reloadData()
                            }
                        }
                    } else {
                        if let resonse = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: resonse, viewController: self)
                            self.arrPendingOrder.removeAll()
                            self.arrFilterPendingOrder.removeAll()
                            self.tblPendingOrder.reloadData()
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
                          //  AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                            AppData.sharedInstance.alert(message: message, viewController: self) { (alert) in
                                self.callShowPendingOrderAPI()
                            }
                        }
                    } else {
                        if let message = res.value(forKey: "message") as? String {
                            AppData.sharedInstance.alert(message: message, viewController: self) { (alert) in
                                self.callShowPendingOrderAPI()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        arrFilterPendingOrder = arrPendingOrder.filter({ (completedOrder: ShowPendingOrder) -> Bool in
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
            self.callShowPendingOrderAPI()
            self.tblPendingOrder.refreshControl?.endRefreshing()
            self.tblPendingOrder.reloadData()
        }
    }
    
    //MARK:- Actions
    @IBAction func btnFilterClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "LoginLogFilterVC") as! LoginLogFilterVC
        VC.modalPresentationStyle = .overCurrentContext
        VC.modalTransitionStyle = .crossDissolve
        VC.isFromPendingOrder = true
        VC.delegateOfPendingOrder = self
        VC.selectedDatefilterIndex = self.selectedDatefilterIndex
        VC.arrSelectedCustIds = self.arrFilterCustIds
        VC.arrSelectedUserIds = self.arrFilterUserIds
        
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBAction func btnPaymentClick(_ sender: UIButton) {
    }
    
    @IBAction func btnViewClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "InvoiceVC") as! InvoiceVC
        VC.modalPresentationStyle = .overCurrentContext
        VC.modalTransitionStyle = .crossDissolve
        VC.orderId = searching ? arrFilterPendingOrder[sender.tag].orderid : arrPendingOrder[sender.tag].orderid
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBAction func btnDeleteClick(_ sender: UIButton) {
    }
    
    @IBAction func btnEditClick(_ sender: UIButton) {
    }
    
}

//MARK:- UITableview DataSource Methods
extension PendingOrderVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return arrFilterPendingOrder.count
        } else {
            return arrPendingOrder.count
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblPendingOrder.dequeueReusableCell(withIdentifier: "CompletedOrderCell", for: indexPath) as! CompletedOrderCell
        
        if (arrPendingOrder[indexPath.row].PaymentType == "Cheque" || arrFilterPendingOrder[indexPath.row].PaymentType == "Cheque") {
            cell.dropDownStatus.optionArray = ["Clear(CAPTURED)","In Process(PROCESSING)","Bounce(FAILED)"]
        } else {
            cell.dropDownStatus.optionArray = ["CAPTURED","PENDING"]
        }
        
        if searching {
            model = arrFilterPendingOrder[indexPath.row]
        } else {
            model = arrPendingOrder[indexPath.row]
        }
        
        let imgUserUrl = URL(string: model.userimg)
        cell.imgUser.kf.setImage(with: imgUserUrl)
        let customerImgUrl = URL(string: model.ProfileImg)
        cell.imgCustomer.kf.setImage(with: customerImgUrl)
        
        if model.PaymentType != "" {
            cell.lblType.text = model.PaymentType
            cell.lblTypeTitle.isHidden = false
        } else {
            cell.lblType.text = model.PaymentType
            cell.lblTypeTitle.isHidden = true
        }
        cell.lblUser.text = model.username
        cell.lblCustomer.text = model.FirstName + " " + model.LastName
        cell.lblInvoice.text = model.InvoiceNumber
        cell.dropDownStatus.text = model.payment_status
        cell.lblSubTotal.text = "$" + model.PaymentAmount
        var date = model.Orderdate
        date.removeLast(9)
        cell.lblDate.text = date
        
        if model.PaymentType == "Cheque" {
            switch model.OrderPayment_status {
//                case "CAPTURED":
//                    cell.dropDownStatus.text = "Clear(CAPTURED)"
//                    cell.btnEdit.isHidden = true
//                    cell.btnDelete.isHidden = true
                case "PROCESSING":
                    cell.dropDownStatus.text = "In Process(PROCESSING)"
                case "FAILED":
                    cell.dropDownStatus.text = "Bounce(FAILED)"
                default:
                    print("Default")
            }
        } else {
            cell.dropDownStatus.text = model.payment_status
        }
        
        cell.dropDownStatus.didSelect{(selectedText , index , id) in
            print("Selected String: \(selectedText) \n index: \(index),id: \(id)")
            cell.dropDownStatus.selectedIndex = index
            var selectedStatus = String()
            selectedStatus = selectedText
            switch selectedStatus {
                case "Clear(CAPTURED)":
                    selectedStatus = "CAPTURED"
                case "In Process(PROCESSING)":
                    selectedStatus = "PROCESSING"
                case "Bounce(FAILED)":
                    selectedStatus = "FAILED"
                case "PENDING":
                    selectedStatus = "PENDING"
                case "CAPTURED":
                    selectedStatus = "CAPTURED"
                default:
                    selectedStatus = selectedText
            }
            self.callChangePaymentStatus(id: self.model.id, status: selectedStatus)
        }
        
        cell.btnView.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        cell.btnEdit.tag = indexPath.row
        
        return cell
    }
        
}

//MARK:- UITableview Delegate Methods
extension PendingOrderVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
}

//MARK:- SearchBar Delegate Methods
extension PendingOrderVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                arrFilterPendingOrder = arrPendingOrder
            }
            tblPendingOrder.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblPendingOrder.reloadData()
        searchBar.resignFirstResponder()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}
//MARK:- filter Delegate Methods
extension PendingOrderVC : PendingOrderProtocol {
    func updatedPendingOrderList(date: String?, selectedDateIndex: Int?, userIds: [(String, String)]?, customerIds: [(String, String)]?, filterBadgeCount: Int) {
         strFilterDate = date ?? ""
                arrFilterCustIds = customerIds ?? [("","")]
                arrFilterUserIds = userIds ?? [("","")]
                self.isFilter = true
                
                selectedDatefilterIndex = selectedDateIndex ?? -1
                lblBadgeNumber.text = " \(filterBadgeCount) "
               callShowPendingOrderAPI(isFilter: true)
             
    }
    
    
}
